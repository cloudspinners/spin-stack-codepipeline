
resource "aws_codepipeline" "pipeline" {
  name     = "${var.stack_name}-pipeline"
  role_arn = "${aws_iam_role.pipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.artefact_repository.bucket}"
    type     = "S3"
    # encryption_key {
    #   id   = "${data.aws_kms_alias.s3kmskey.arn}"
    #   type = "KMS"
    # }
  }

  stage {
    name = "CheckoutCode"

    action {
      name             = "Checkout"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"

      output_artifacts  = [ "stack-source" ],

      configuration {
        Owner                 = "${var.github_owner}"
        Repo                  = "${var.github_repo}"
        PollForSourceChanges  = "yes"
        Branch                = "${var.github_branch}"
        OAuthToken            = "${var.github_oath_token}"
      }
    }
  }

  stage {
    name = "PackageArtefact"

    action {
      name            = "Package"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "stack-source" ]
      output_artifacts  = [ "stack-package" ]

      configuration {
        ProjectName = "${aws_codebuild_project.packaging-project.name}"
      }
    }
  }

  stage {
    name = "ApplyToTestEnvironment"

    action {
      name            = "ApplyToTestEnvironment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "stack-package" ]
      output_artifacts  = [ "testapply-results" ]

      configuration {
        ProjectName = "${aws_codebuild_project.testapply-project.name}"
      }
    }
  }

  stage {
    name = "ApproveForProduction"

    action {
      name            = "ApproveForProduction"
      category        = "Approval"
      provider        = "Manual"
      owner           = "AWS"
      version         = "1"
    }
  }

  stage {
    name = "ApplyToProdEnvironment"

    action {
      name            = "ApplyToProdEnvironment"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"

      input_artifacts = [ "stack-package" ]
      output_artifacts  = [ "prodapply-results" ]

      configuration {
        ProjectName = "${aws_codebuild_project.prodapply-project.name}"
      }
    }
  }
}

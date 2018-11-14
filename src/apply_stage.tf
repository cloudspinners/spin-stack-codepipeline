
resource "aws_codebuild_project" "apply-stage" {
  name          = "${var.stack_name}-ApplyToProdEnvironment"
  description   = "CodeBuild project to apply terraform to a ${var.stack_name} instance"
  build_timeout = "10"
  service_role  = "${aws_iam_role.apply_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.5.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "DEPLOYMENT_ID"
      "value" = "apply"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "apply_stage_buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}


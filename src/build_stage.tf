resource "aws_codebuild_project" "build-stage" {
  name          = "Package-${var.stack_name}"
  description   = "CodeBuild project to build the ${var.stack_name} codebase"
  build_timeout = "5"
  service_role  = aws_iam_role.build_role.arn

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.5.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "PACKAGE_TYPE"
      value = "pipeline"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "pipeline/build_stage_buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}


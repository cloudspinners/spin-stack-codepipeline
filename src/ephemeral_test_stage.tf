
resource "aws_codebuild_project" "emphemeral-test-stage" {
  name         = "${var.stack_name}-EphemeralTestStage"
  description  = "Create and test an ephemeral environment for the ${var.stack_name} stack definition"
  build_timeout      = "10"
  service_role = "${aws_iam_role.apply_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/ruby:2.5.1"
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "DEPLOYMENT_ID"
      "value" = "ephemeral"
    }
  }

  source {
    type = "CODEPIPELINE"
    buildspec = "ephemeral_test_stage_buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }
}


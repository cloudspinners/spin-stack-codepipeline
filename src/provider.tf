provider "aws" {
  region = "${var.region}"
  profile = "${var.aws_profile}"
  assume_role {
    role_arn  = "${var.assume_role_arn}"
    session_name = "session-${var.stack_name}"
  }
}

data "aws_caller_identity" "current" {}


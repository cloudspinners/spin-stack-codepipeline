resource "aws_s3_bucket" "artefact_repository" {
  bucket = var.repo_bucket_name

  # TODO: Refactor to use this instead:
  # bucket        = "delivery-${var.instance_identifier}-${var.stack_name}-${data.aws_caller_identity.current_aws_account.account_id}"
  force_destroy = "true"
  acl           = "private"
  versioning {
    enabled = "true"
  }
  tags = {
    Name               = "artefact_repository"
    InstanceIdentifier = var.instance_identifier
  }
}

resource "aws_ssm_parameter" "artefact_repository_reference" {
  name  = "/${var.instance_identifier}/${var.stack_name}/repo_bucket_name"
  type  = "String"
  value = var.repo_bucket_name
}


variable "region" { default = "eu-west-1" }
variable "aws_profile" { default = "default" }
variable "assume_role_arn" { default = "" }

variable "instance_identifier" {}
variable "stack_name" {}
variable "repo_bucket_name" {}

variable "github_owner" {}
variable "github_repo" {}
variable "github_branch" {}
variable "github_oath_token" {}

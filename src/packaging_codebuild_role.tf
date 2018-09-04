
resource "aws_iam_role" "packaging_codebuild_role" {
  name = "${var.stack_name}_Packager"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_policy" "packaging_codebuild_policy" {
  name        = "${var.stack_name}_Packaging_Codebuild_Policy"
  path        = "/service-role/"
  description = "Policies needed by the CodeBuild project for packaging the ${var.stack_name} stack"

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:List*",
        "s3:PutObject"
      ]
    }
  ]
}
POLICY
}


resource "aws_iam_policy_attachment" "packaging_codebuild_attachment" {
  name       = "${var.stack_name}_Packaging_Codebuild_Attachment"
  policy_arn = "${aws_iam_policy.packaging_codebuild_policy.arn}"
  roles      = ["${aws_iam_role.packaging_codebuild_role.id}"]
}


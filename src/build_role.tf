resource "aws_iam_role" "build_role" {
  name = "${var.stack_name}_BuildRole"

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

resource "aws_iam_policy" "build_stage_policy" {
  name = "${var.stack_name}_BuildStage_Policy"
  path = "/service-role/"
  description = "Policies needed by the build stage CodeBuild project for the ${var.stack_name} stack"

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

resource "aws_iam_policy_attachment" "attach_build_stage_policy_to_build_role" {
name       = "${var.stack_name}-BuildStage-PolicyAttachment"
policy_arn = aws_iam_policy.build_stage_policy.arn
roles      = [aws_iam_role.build_role.id]
}


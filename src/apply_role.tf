
resource "aws_iam_role" "apply_role" {
  name = "${var.stack_name}-ApplyRole"

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


resource "aws_iam_policy" "apply_policy" {
  name        = "${var.stack_name}-ApplyPolicy"
  path        = "/service-role/"
  description = "Policies for applying changes to instances of ${var.stack_name}"

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


resource "aws_iam_policy_attachment" "attach_ApplyPolicy_to_ApplyRole" {
  name       = "${var.stack_name}-ApplyStage-PolicyAttachment"
  policy_arn = "${aws_iam_policy.apply_policy.arn}"
  roles      = ["${aws_iam_role.apply_role.id}"]
}


resource "aws_iam_role_policy_attachment" "attach_PowerUserPolicy_to_ApplyRole" {
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
  role      = "${aws_iam_role.apply_role.id}"
}


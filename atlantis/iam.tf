resource "aws_iam_role_policy" "this" { # todo: this is basically the admin policy... needs to be locked down.
  name        = "atlantis"
  role       = "${aws_iam_role.this.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}


resource "aws_iam_role" "this" {
  name = "${var.name}"

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
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}"
  role = "${aws_iam_role.this.name}"
}

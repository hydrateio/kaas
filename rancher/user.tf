resource "aws_iam_user" "rancher" {
  name = "rancher"
}

resource "aws_iam_access_key" "rancher" {
  user    = "${aws_iam_user.rancher.name}"
}

resource "aws_iam_user_policy" "this" { # todo: this is basically the admin policy... needs to be locked down.
  name        = "rancher"
  user       = "${aws_iam_user.rancher.name}"

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
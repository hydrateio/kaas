resource "aws_s3_bucket" "build" {
  bucket = "${data.terraform_remote_state.main.aws_caller_identity_id}-terraform"
  acl    = "private"
}

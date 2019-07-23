resource "aws_s3_bucket" "terraform" {
  bucket = "hydrate-sandbox-terraform"
  acl    = "private"
}

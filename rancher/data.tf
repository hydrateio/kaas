data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket = "hydrate-sandbox-terraform"
    key    = "main.tfstate"
    region = "eu-west-1"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_caller_identity" "current" {}

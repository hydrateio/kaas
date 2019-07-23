terraform {
  backend "s3" {
    bucket = "hydrate-sandbox-terraform"
    key    = "main.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "${var.region}"
}

data "aws_caller_identity" "main" {}

terraform {
  backend "s3" {
    bucket = "hydrate-sandbox-terraform"
    key    = "atlantis.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket = "hydrate-sandbox-terraform"
    key    = "main.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "github" {
  token        = "${var.github_user_token}"
  organization = "${var.github_organization}"
}

terraform {
  backend "s3" {
    bucket = "hydrate-sandbox-terraform"
    key    = "image.tfstate"
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
  token        = "${data.external.github.result["token"]}"
  organization = "${var.github_organization}"
}

data "github_repository" "main" {
  full_name = "${var.github_organization}/${var.github_repository}"
}

data "aws_secretsmanager_secret" "github" {
  name = "github"
}

data "aws_secretsmanager_secret_version" "github" {
  secret_id = "${data.aws_secretsmanager_secret.github.id}"
}
data "external" "github" {
  program = ["echo", "${replace(data.aws_secretsmanager_secret_version.github.secret_string, "\\\"", "\"")}"]
}

terraform {
  backend "s3" {
    bucket = "hydrate-sandbox-terraform"
    key    = "clusters.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}


# Provider config
provider "rancher2" {
  api_url  = "https://rancher.${data.terraform_remote_state.main.public_dns_domain}/"
  insecure = true
  token_key = "${data.external.creds.result["token"]}"
}

data "terraform_remote_state" "main" {
  backend = "s3"

  config {
    bucket = "hydrate-sandbox-terraform"
    key    = "main.tfstate"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "rancher" {
  backend = "s3"

  config {
    bucket = "hydrate-sandbox-terraform"
    key    = "rancher.tfstate"
    region = "eu-west-1"
  }
}

data "aws_secretsmanager_secret" "rancher" {
  name = "rancher"
}

data "aws_secretsmanager_secret_version" "rancher" {
  secret_id = "${data.aws_secretsmanager_secret.rancher.id}"
}
data "external" "creds" {
  program = ["echo", "${replace(data.aws_secretsmanager_secret_version.rancher.secret_string, "\\\"", "\"")}"]
}

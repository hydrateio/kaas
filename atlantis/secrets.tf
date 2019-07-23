provider "sops" {}

data "sops_file" "secrets" {
  source_file = "secrets.json"
}

resource "random_id" "atlantis_infrastructure_webhook" {
  byte_length = "64"
}
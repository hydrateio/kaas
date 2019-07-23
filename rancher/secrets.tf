provider "sops" {}

data "sops_file" "secrets" {
  source_file = "secrets.json"
}

resource "aws_secretsmanager_secret" "rancher" {
  name = "rancher"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "rancher" {
  secret_id     = "${aws_secretsmanager_secret.rancher.id}"
  secret_string = "${jsonencode(local.rancher_creds)}"
}

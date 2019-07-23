data "aws_availability_zones" "available" {}

data "aws_subnet" "public" {
  count  = "${length(var.public_subnet_ids)}"
  id     = "${element(var.public_subnet_ids, count.index)}"
  vpc_id = "${var.vpc_id}"
}

data "aws_subnet" "private" {
  count  = "${length(var.private_subnet_ids)}"
  id     = "${element(var.private_subnet_ids, count.index)}"
  vpc_id = "${var.vpc_id}"
}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "rancher" {
  name = "rancher"
}

data "aws_caller_identity" "current" {}

data "aws_secretsmanager_secret_version" "rancher" {
  secret_id = "${data.aws_secretsmanager_secret.rancher.id}"
}
data "external" "creds" {
  program = ["echo", "${replace(data.aws_secretsmanager_secret_version.rancher.secret_string, "\\\"", "\"")}"]
}

data "aws_vpc" "selected" {
  id = "${var.vpc_id}"
}

data "aws_security_group" "rancher_nodes" {
  name = "rancher-nodes"
}

data "aws_subnet_ids" "selected" {
  vpc_id = "${data.aws_vpc.selected.id}"

  tags {
    Name = "k8s-db-${data.aws_region.current.name}*"
  }
}

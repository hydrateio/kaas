resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  domain_name           = "${var.name}"
  elasticsearch_version = "6.7"
  ebs_options {
      ebs_enabled = "true"
      volume_size = "500"
      volume_type = "gp2"
  }
  cluster_config {
    instance_type = "m4.large.elasticsearch"
  }

  vpc_options {
    subnet_ids = [
      "${data.aws_subnet_ids.selected.ids[0]}",
    ]

    security_group_ids = ["${data.aws_security_group.rancher_nodes.id}"]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": "*",
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.name}/*"
        }
    ]
}
CONFIG

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  tags {
    Domain = "TestDomain"
  }

  depends_on = [
    "aws_iam_service_linked_role.es",
  ]
}
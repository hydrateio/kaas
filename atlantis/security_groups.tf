module "atlantis_alb_https_sg" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "v2.0.0"

  name        = "atlantis-alb"
  vpc_id      = "${data.terraform_remote_state.main.vpc_id}"
  description = "Security group with HTTPS ports open for everybody (IPv4 CIDR), egress ports are all world open"

  ingress_cidr_blocks = "${data.github_ip_ranges.main.hooks}"
}

module "atlantis_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "v2.0.0"

  name        = "atlantis"
  vpc_id      = "${data.terraform_remote_state.main.vpc_id}"
  description = "Security group with open port for Atlantis (4141) from ALB, egress ports are all world open"

  computed_ingress_with_source_security_group_id = [
    {
      from_port                = 4141
      to_port                  = 4141
      protocol                 = "tcp"
      description              = "Atlantis"
      source_security_group_id = "${module.atlantis_alb_https_sg.this_security_group_id}"
    },
  ]

  number_of_computed_ingress_with_source_security_group_id = 1
  egress_rules                                             = ["all-all"]
}
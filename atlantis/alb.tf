module "atlantis_alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "v3.4.0"

  load_balancer_name = "atlantis"

  vpc_id          = "${data.terraform_remote_state.main.vpc_id}"
  subnets         = ["${data.terraform_remote_state.main.public_subnet_ids}"]
  security_groups = ["${module.atlantis_alb_https_sg.this_security_group_id}"]
  logging_enabled = false

  https_listeners = [{
    port            = 443
    certificate_arn = "${data.terraform_remote_state.main.main_ssl_cert_arn}"
  }]

  https_listeners_count = 1

  target_groups = [{
    name                 = "atlantis"
    backend_protocol     = "HTTP"
    backend_port         = 4141
    target_type          = "ip"
    deregistration_delay = 10
  }]

  target_groups_count = 1
}

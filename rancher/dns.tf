data "aws_route53_zone" "public" {
  name = "${data.terraform_remote_state.main.public_dns_domain}"
}

resource "aws_route53_record" "rancher" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "rancher"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.rancherserver.public_ip}"]
}

resource "aws_elb" "rancher" {
  name    = "rancher"
  subnets = ["${data.terraform_remote_state.main.public_subnet_ids}"]
  security_groups = ["${aws_security_group.rancher_sg_allow_whitelist.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  listener {
    instance_port      = 80
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = "${data.terraform_remote_state.main.main_ssl_cert_arn}"
  }

  instances                   = ["${aws_instance.rancherserver.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}

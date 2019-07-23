data "aws_route53_zone" "public" {
  name = "${data.terraform_remote_state.main.public_dns_domain}"
}

resource "aws_route53_record" "atlantis" {
  zone_id = "${data.aws_route53_zone.public.zone_id}"
  name    = "atlantis"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.atlantis_alb.dns_name}"]
}
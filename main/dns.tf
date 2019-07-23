resource "aws_route53_zone" "public" {
  name = "${var.public_dns_domain}"
}

resource "aws_route53_zone" "private" {
  name = "${var.private_dns_domain}"

  vpc {
    vpc_id = "${module.vpc.vpc_id}"
  }
}

resource "aws_route53_record" "test" {
  zone_id = "${aws_route53_zone.public.zone_id}"
  name    = "test"
  type    = "CNAME"
  ttl     = "300"
  records = ["www.google.com"]
}
resource "aws_kms_key" "ci" {
  description             = "KMS key used to encrypt and decrypt secrets in CI/CD pipeline"
}

resource "aws_acm_certificate" "main" {
  domain_name               = "${var.public_dns_domain}"
  subject_alternative_names = ["*.${var.public_dns_domain}"]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "main_cert_validation" {
  name    = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_name}"
  type    = "${aws_acm_certificate.main.domain_validation_options.0.resource_record_type}"
  zone_id = "${aws_route53_zone.public.zone_id}"
  records = ["${aws_acm_certificate.main.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "main" {
  certificate_arn         = "${aws_acm_certificate.main.arn}"
  validation_record_fqdns = ["${aws_route53_record.main_cert_validation.fqdn}"]
}
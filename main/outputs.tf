output "private_subnet_ids" {
    value = "${data.aws_subnet_ids.private.ids}"
}

output "public_subnet_ids" {
    value = "${data.aws_subnet_ids.public.ids}"
}

output "vpc_id" {
    value = "${module.vpc.vpc_id}"
}

output "region" {
    value = "${var.region}"
}

output "aws_caller_identity_id" {
    value = "${data.aws_caller_identity.main.account_id}"
}

output "aws_caller_user_id" {
    value = "${data.aws_caller_identity.main.user_id}"
}

output "public_dns_domain" {
    value = "${var.public_dns_domain}"
}

output "main_ssl_cert_arn" {
    value = "${aws_acm_certificate.main.arn}"
}

output "ci_kms_key_arn" {
    value = "${aws_kms_key.ci.arn}"
}
locals {
  # Atlantis
  atlantis_url        = "https://${coalesce(element(concat(aws_route53_record.atlantis.*.fqdn, list("")), 0), module.atlantis_alb.dns_name)}"
  atlantis_url_events = "${local.atlantis_url}/events"
}
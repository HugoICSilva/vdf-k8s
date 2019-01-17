output "zone_id" {
  value       = "${aws_route53_zone.tooling.zone_id}"
  description = "The hosted zone id"
}

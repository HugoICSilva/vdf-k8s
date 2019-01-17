output "elb_ucp" {
  description = "ID elb_ucp"
  value       = "${aws_alb.elb_ucp.arn}"
}

output "elb_ucp-zone_id" {
  description = "teste2"
  value       = "${aws_alb.elb_ucp.zone_id}"
}

output "alb_ucp-dns_name" {
  description = "teste"
  value       = "${aws_alb.elb_ucp.dns_name}"
}

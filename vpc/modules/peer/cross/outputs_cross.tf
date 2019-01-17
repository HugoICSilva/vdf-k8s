output "vpc_peer" {
  description = "Route Table Private ID for prod-VPC"
  value       = "${aws_vpc_peering_connection.peer.id}"
}

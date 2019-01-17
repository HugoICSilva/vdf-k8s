####################
## Variaveis atraves
## de Outputs

output "vpc_prod_id" {
  description = "ID of the VPC"
  value       = "${aws_vpc.prod_vpc.id}"
}

##------------> subenets
output "subnet_pub1_ids" {
  description = "List with IDs of the public subnets"
  value       = "${aws_subnet.prod_public1_subnet.id}"
}

output "subnet_pub2_ids" {
  description = "List with IDs of the public subnets"
  value       = "${aws_subnet.prod_public2_subnet.id}"
}

##------------> RTs
output "prod_public_rt" {
  description = "Route Table Public ID for prod-VPC"
  value       = "${aws_route_table.prod_public_rt.id}"
}

output "prod_private_rt" {
  description = "Route Table Private ID for prod-VPC"
  value       = "${aws_default_route_table.prod_private_rt.id}"
}

/**
##----------------> id da zona R53
output "zone_id" {
  description = "ID of R53"
  value       = "${module.route53.zone_id}"
}

##-----------------> id/url ALB-UCP
output "elb_ucp-zone_id" {
  description = "ID of the ALB"
  value       = "${module.elb_ucp.elb_ucp-zone_id}"
}

output "alb_ucp-dns_name"{
  description = "DNS Internal URL"
  value       = "${module.elb_ucp.alb_ucp-dns_name}"
  }
*/


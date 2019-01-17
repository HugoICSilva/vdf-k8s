####################
## Variaveis atraves
## de Outputs

output "vpc_id" {
  description = "Tooling VPC ID"
  value       = "${aws_vpc.dmz_vpc.id}"
}

##------------> subenets
output "subnet_pub1_ids" {
  description = "Public1 SubNet ID"
  value       = "${aws_subnet.dmz_public1_subnet.id}"
}

output "subnet_pub2_ids" {
  description = "Public2 SubNet ID"
  value       = "${aws_subnet.dmz_public2_subnet.id}"
}

##----------------> id da zona R53
output "zone_id" {
  description = "R53 private Domain ID"
  value       = "${module.route53.zone_id}"
}

##-----------------> id/url ALB-UCP
output "elb_ucp-zone_id" {
  description = "UCP private Domain ID"
  value       = "${module.elb_ucp.elb_ucp-zone_id}"
}

output "alb_ucp-dns_name" {
  description = "UCP ALB Domain Name"
  value       = "${module.elb_ucp.alb_ucp-dns_name}"
}

##-----------------> app-vpc id  
output "vpc_app_id" {
  description = "APP VPC Module ID"
  value       = "${module.app-vpc.vpc_app_id}"
}

##------------> app-vpc RTs

output "app_public_rt" {
  description = "Route Table Public ID for APP-VPC"
  value       = "${module.app-vpc.app_public_rt}"
}

output "app_private_rt" {
  description = "Route Table Private ID for APP-VPC"
  value       = "${module.app-vpc.app_private_rt}"
}

##-----------------> prod-vpc id  
output "vpc_prod_id" {
  description = "APP VPC Module ID"
  value       = "${module.prod-vpc.vpc_prod_id}"
}

##------------> prod-vpc RTs

output "prod_public_rt" {
  description = "Route Table Public ID for PROD-VPC"
  value       = "${module.prod-vpc.prod_public_rt}"
}

output "prod_private_rt" {
  description = "Route Table Private ID for PROD-VPC"
  value       = "${module.prod-vpc.prod_private_rt}"
}

##-------------> test peer


output "vpc_peer_app_id" {
  description = "VPC peer conection toolin to test ID"
  value       = "${module.peer-vpc-app.vpc_peer}"
}

output "vpc_peer_prod_id" {
  description = "VPC peer conection toolin to Prod ID"
  value       = "${module.peer-vpc-prod.vpc_peer}"
}

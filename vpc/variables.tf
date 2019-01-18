##############
## VPC VARs
##

variable "aws_region" {
  description = "used region"
}

variable "aws_profile" {
  description = "aws used profile"
}

variable "aws_region1" {
  description = "used region"
}

variable "aws_profile1" {
  description = "aws used profile"
}

data "aws_availability_zones" "available" {}

variable "vpc_cidr" {
  description = "range of ips used in vpc"
}

variable "cf_vpc" {
  description = "ID from CF VPN"
}

variable "cidrs" {
  description = "reserved ip's map for SubNets"
  type        = "map"
}

variable "auth_lista" {
  description = "1 Ip WhitList"
  type        = "list"
}

variable "auth_lista2" {
  description = "2 Ip WhitList"
  type        = "list"
}

variable "chave" {
  description = "Standard ssh key from aws"
}

variable "null_list" {
  description = " 0.0.0.0/0 IP"
}

variable "vpc_list" {
  description = "IP list from VPN and VPC"
  type        = "list"
}

##-----------> Compute modules

variable "instance_type_bastion" {
  description = " Type of machine used is bastion"
}

variable "bastion_ami" {
  description = " AMI used in bastion"
}

variable "instance_type_master" {
  description = " Type of machine used in Master's"
}

variable "instance_type_worker" {
  description = " Type of machine used in Worker's"
}

variable "privIPs" {
  description = "reserved ip's map for machines"
  type        = "map"
}

##-----------> R53 UCP

variable "domain_name" {
  description = "Route53 Private domanin name"
}

##----------> elb-ucp
variable "elb_port_ext_1a" {
  description = "port 443"
}

variable "elb_port_ext_1b" {
  description = "port 80"
}

variable "elb_port_ext_2" {
  description = "port 80"
}

variable "elb_protocol_ext_1a" {
  description = "TCP"
}

variable "elb_protocol_ext_1b" {
  description = "HTTPS"
}

variable "elb_protocol_ext_2" {
  description = "HTTP"
}

variable "target_master_instances" {
  description = "reserved master ip's map"
  type        = "map"
}

##--------------> peering

variable "app_cidr" {
  type        = "string"
  description = "APP-VPC CIDR "
}

variable "prod_cidr" {
  type        = "string"
  description = "PROD-VPC CIDR "
}

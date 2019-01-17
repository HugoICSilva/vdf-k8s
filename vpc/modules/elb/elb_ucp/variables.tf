variable "vpc_name" {}
variable "elb_port_ext_1a" {}
variable "elb_port_ext_1b" {}
variable "elb_port_ext_2" {}
variable "elb_protocol_ext_1a" {}
variable "elb_protocol_ext_1b" {}
variable "elb_protocol_ext_2" {}
variable "target1" {}
variable "target2" {}
variable "target3" {}

variable "availability_zones" {
  type = "list"
}

variable "sg_elb" {
  type = "list"
}

variable "elb_ucp_subnets" {
  type = "list"
}

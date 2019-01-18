##############
## VPC VARs
##

variable "aws_profile" {
  type    = "string"
  default = "Auto_CelFocus_prod"
}

variable "aws_region" {
  type    = "string"
  default = "eu-central-1"
}

variable "aws_profile1" {
  type    = "string"
  default = "Auto_CelFocus_prod"
}

variable "aws_region1" {
  type    = "string"
  default = "eu-central-1"
}

data "aws_availability_zones" "available" {}

variable "vpc_cidr" {
  default = "10.233.106.0/24"
}

variable "cidrs" {
  type = "map"

  default = {
    public1      = "10.233.106.0/28"
    public2      = "10.233.106.112/28"
    priv_master1 = "10.233.106.16/28"
    priv_master2 = "10.233.106.32/28"
    priv_master3 = "10.233.106.48/28"
    priv_worker1 = "10.233.106.64/28"
    priv_worker2 = "10.233.106.80/28"
    priv_worker3 = "10.233.106.96/28"
  }
}

variable "auth_lista" {
  type = "list"

  default = ["213.30.18.1/32", "85.246.181.205/32",
    "10.20.32.0/19",
    "88.157.199.114/32",
    "192.168.90.169/32",
    "172.16.0.0/22",
  ]
}

variable "auth_lista2" {
  type = "list"

  default = ["213.30.18.1/32", "85.246.181.205/32",
    "10.20.32.0/19",
    "10.0.0.0/16",
  ]
}

variable "chave" {
  default = "VDF-DE-TEST"
}

variable "null_list" {
  default = "0.0.0.0/0"
}

variable "vpc_list" {
  type = "list"

  default = ["10.233.105.0/26",
    "192.168.90.169/32",
    "172.16.0.0/22",
  ]
}

##-----------> Compute modules

variable "instance_type_worker" {
  default = "t2.large"
}

variable "privIPs" {
  type = "map"

  default = {
    bastion  = "10.233.106.6"
    dtr01    = "10.233.106.20"
    dtr02    = "10.233.106.36"
    dtr03    = "10.233.106.52"
    master01 = "10.233.106.21"
    master02 = "10.233.106.37"
    master03 = "10.233.106.53"
    worker01 = "10.233.106.68"
    worker02 = "10.233.106.85"
    worker03 = "10.233.106.101"
  }
}

#-------------> Peer


#variable "peer_rt" {}


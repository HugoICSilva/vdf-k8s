##############
## VPC VARs
##

data "aws_availability_zones" "available" {}

variable "vpc_cidr" {
  default = "10.233.105.0/24"
}

#variable "app_cidr" {}
#variable "peer_rt" {}

variable "cidrs" {
  type = "map"

  default = {
    public1      = "10.233.105.0/28"
    public2      = "10.233.105.112/28"
    priv_master1 = "10.233.105.16/28"
    priv_master2 = "10.233.105.32/28"
    priv_master3 = "10.233.105.48/28"
    priv_worker1 = "10.233.105.64/28"
    priv_worker2 = "10.233.105.80/28"
    priv_worker3 = "10.233.105.96/28"
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
    bastion  = "10.233.105.6"
    dtr01    = "10.233.105.20"
    dtr02    = "10.233.105.36"
    dtr03    = "10.233.105.52"
    master01 = "10.233.105.21"
    master02 = "10.233.105.37"
    master03 = "10.233.105.53"
    worker01 = "10.233.105.68"
    worker02 = "10.233.105.85"
    worker03 = "10.233.105.101"
  }
}

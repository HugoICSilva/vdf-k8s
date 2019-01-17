#####################################
## Terraform Main script
## Recursos:
## Criação da VPC, IGW, NATGTW, EIP
## SubNets, RT, SG, PEERINGS.
## Modules Call's
#####################################

###############
# AWS-CLI Provider
##
provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"

}

provider "aws" {
  region  = "${var.aws_region1}"
  profile = "${var.aws_profile1}"
  alias   = "accepter"
}

#data "aws_availability_zones" "available" {}

#------------IAM---------------- 
# Se necessario criar algum role
#

##############
#VPC
##
resource "aws_vpc" "dmz_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "dmz_vpc"
  }
}

resource "aws_vpn_gateway_attachment" "vpn_attachment" {
  vpc_id         = "${aws_vpc.dmz_vpc.id}"
  vpn_gateway_id = "${var.cf_vpc}"
}

##############
# Internet gateway
##
resource "aws_internet_gateway" "dmz_internet_gateway" {
  vpc_id = "${aws_vpc.dmz_vpc.id}"

  tags {
    Name = "dmz_igw"
  }
}

#-------------> A EIP for the NAT gateway.
resource "aws_eip" "dmz_nat_eip" {
  vpc = true
}

#-------------> The NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.dmz_nat_eip.id}"
  subnet_id     = "${aws_subnet.dmz_public2_subnet.id}"
}

#############
# Route tables
##
resource "aws_route_table" "dmz_public_rt" {
  vpc_id           = "${aws_vpc.dmz_vpc.id}"
  propagating_vgws = ["${var.cf_vpc}"]

  route {
    cidr_block = "${var.null_list}"
    gateway_id = "${aws_internet_gateway.dmz_internet_gateway.id}"
  }

 # route {
 #   cidr_block                = "${var.app_cidr}"
 #   vpc_peering_connection_id = "${module.peer_vpc_req.primary2secondary_req}"
 # }

  tags {
    Name = "dmz_public"
  }
}

resource "aws_default_route_table" "dmz_private_rt" {
  default_route_table_id = "${aws_vpc.dmz_vpc.default_route_table_id}"
  propagating_vgws       = ["${var.cf_vpc}"]

  route {
    cidr_block     = "${var.null_list}"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

 # route {
 #   cidr_block                = "${var.app_cidr}"
 #   vpc_peering_connection_id = "${module.peer_vpc_req.primary2secondary_req}"
 # }

  tags {
    Name = "dmz_private"
  }
}

##############
# Subenets
##
resource "aws_subnet" "dmz_public1_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "dmz_public1"
  }
}

resource "aws_subnet" "dmz_public2_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "dmz_public2"
  }
}

resource "aws_subnet" "priv_master1_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "priv_master1"
  }
}

resource "aws_subnet" "priv_master2_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "priv_master2"
  }
}

resource "aws_subnet" "priv_master3_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name = "priv_master3"
  }
}

resource "aws_subnet" "priv_worker1_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "priv_worker1"
  }
}

resource "aws_subnet" "priv_worker2_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "priv_worker2"
  }
}

resource "aws_subnet" "priv_worker3_subnet" {
  vpc_id                  = "${aws_vpc.dmz_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name = "priv_worker3"
  }
}

##############
#RT Associations
##
resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = "${aws_subnet.dmz_public1_subnet.id}"
  route_table_id = "${aws_route_table.dmz_public_rt.id}"
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = "${aws_subnet.dmz_public2_subnet.id}"
  route_table_id = "${aws_route_table.dmz_public_rt.id}"
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = "${aws_subnet.priv_master1_subnet.id}"
  route_table_id = "${aws_default_route_table.dmz_private_rt.id}"
}

###############
##Security groups
##

#---------> Public SG Bastion

resource "aws_security_group" "dmz_bastion_sg" {
  name        = "dmz_bastion_sg"
  description = "Used forBastion"
  vpc_id      = "${aws_vpc.dmz_vpc.id}"

  #SSH

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["${var.auth_lista}"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
  tags {
    Name = "Bastion SG T"
  }
}

#---------> Public SG ELB1

resource "aws_security_group" "dmz_elb1_sg" {
  name        = "dmz_elb1_sg"
  description = "Used for public ELB1"
  vpc_id      = "${aws_vpc.dmz_vpc.id}"

  #Open POrts

  ingress {
    from_port   = "8080"
    to_port     = "8080"
    protocol    = "tcp"
    cidr_blocks = ["${var.null_list}"]
  }
  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["${var.null_list}"]
  }

  #Outbound "public"

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
  tags {
    Name = "ELB1 SG T"
  }
}

#----------> Master SG

resource "aws_security_group" "dmz_master_sg" {
  name        = "dmz_master_sg"
  description = "Utilizado para o Master"
  vpc_id      = "${aws_vpc.dmz_vpc.id}"

  # INBounds

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_list}"]
  }
  # Outbound
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
  tags {
    Name = "Master SG T"
  }
}

# Cluster

resource "aws_security_group" "dmz_cluster_sg" {
  name        = "dmz_cluster_sg"
  description = "utilizado para o cluster"
  vpc_id      = "${aws_vpc.dmz_vpc.id}"

  #Open Ports

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.vpc_list}"]
  }

  #Outbound

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["${var.null_list}"]
  }
  tags {
    Name = "Cluster SG T"
  }
}

##==========> MODULES <=========##

############
## Bastion
#

module "bastion" {
  source = "modules/ec2/bastion/"

  instance_name         = "bastion"
  chave                 = "${var.chave}"
  bastion_ami           = "${var.bastion_ami}"
  instance_type_bastion = "${var.instance_type_bastion}"
  security_group        = "${aws_security_group.dmz_bastion_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.dmz_public1_subnet.id}"
  private_ip            = "${var.privIPs["bastion"]}"
  txt                   = "modules/ec2/bastion/user-bast-data.txt"
  public_ip             = "false"
  ambiente              = "tool"
}

##########
## DNS
#
module "DNS" {
  source = "modules/ec2/bastion/"

  instance_name         = "automation"
  chave                 = "${var.chave}"
  bastion_ami           = "${var.bastion_ami}"
  instance_type_bastion = "${var.instance_type_bastion}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.priv_master1_subnet.id}"
  private_ip            = "${var.privIPs["dns"]}"
  txt                   = "modules/ec2/bastion/inter-dns.txt"
  public_ip             = "false"
  ambiente              = "tool"
}

###########
## DTRs
#

module "dtr01" {
  source = "modules/ec2/worker/"

  instance_name         = "dtr01"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_master}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.priv_master1_subnet.id}"
  private_ip            = "${var.privIPs["dtr01"]}"
  ambiente              = "dmz"
  txt                   = "modules/ec2/worker/dtr-data.txt"

  # depends_on            = $"{module.master02}"
}

#----------------- DTR02 ------------------->
module "dtr02" {
  source = "modules/ec2/worker/"

  instance_name         = "dtr02"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_master}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[1]}"
  subnet_id             = "${aws_subnet.priv_master2_subnet.id}"
  private_ip            = "${var.privIPs["dtr02"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/dtr-data.txt"

  # public_ip_address     = "false"
}

#----------------- DTR03 ------------------->
module "dtr03" {
  source = "modules/ec2/worker/"

  instance_name         = "dtr03"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_master}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[2]}"
  subnet_id             = "${aws_subnet.priv_master3_subnet.id}"
  private_ip            = "${var.privIPs["dtr03"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/dtr-data.txt"

  # public_ip_address     = "false"
}

###########
## Masters
#

module "master01" {
  source = "modules/ec2/worker/"

  instance_name         = "master01"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_master}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.priv_master1_subnet.id}"
  private_ip            = "${var.privIPs["master01"]}"
  ambiente              = "dmz"
  txt                   = "modules/ec2/worker/master-data.txt"

  # depends_on            = $"{module.master02}"
}

#----------------- MASTER02 ------------------->
module "master02" {
  source = "modules/ec2/worker/"

  instance_name         = "master02"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_master}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[1]}"
  subnet_id             = "${aws_subnet.priv_master2_subnet.id}"
  private_ip            = "${var.privIPs["master02"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/dtr-data.txt"

  # public_ip_address     = "false"
}

#----------------- MASTER03 ------------------->
module "master03" {
  source = "modules/ec2/worker/"

  instance_name         = "master03"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_master}"
  security_group        = "${aws_security_group.dmz_master_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[2]}"
  subnet_id             = "${aws_subnet.priv_master3_subnet.id}"
  private_ip            = "${var.privIPs["master03"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/dtr-data.txt"

  # public_ip_address     = "false"
}

###########
## workers
#

module "worker01" {
  source = "modules/ec2/worker/"

  instance_name         = "worker01"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.dmz_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.priv_worker1_subnet.id}"
  private_ip            = "${var.privIPs["worker01"]}"
  ambiente              = "dmz"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "tool"
}

#----------------- WORKER02 ------------------->
module "worker02" {
  source = "modules/ec2/worker/"

  instance_name         = "worker02"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.dmz_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[1]}"
  subnet_id             = "${aws_subnet.priv_worker2_subnet.id}"
  private_ip            = "${var.privIPs["worker02"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "false"
}

#----------------- WORKER03 ------------------->
module "worker03" {
  source = "modules/ec2/worker/"

  instance_name         = "worker03"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.dmz_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[2]}"
  subnet_id             = "${aws_subnet.priv_worker3_subnet.id}"
  private_ip            = "${var.privIPs["worker03"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "false"
}

###########
## Elb-ucp
#
module "elb_ucp" {
  source = "modules/elb/elb_ucp"

  availability_zones = ["${data.aws_availability_zones.available.names[0]}",
    "${data.aws_availability_zones.available.names[1]}",
    "${data.aws_availability_zones.available.names[2]}",
  ]

  elb_ucp_subnets = ["${aws_subnet.priv_master1_subnet.id}",
    "${aws_subnet.priv_master2_subnet.id}",
    "${aws_subnet.priv_master3_subnet.id}",
  ]

  vpc_name            = "${aws_vpc.dmz_vpc.id}"
  target1             = "${var.privIPs["master01"]}"
  target2             = "${var.privIPs["master02"]}"
  target3             = "${var.privIPs["master03"]}"
  elb_protocol_ext_1a = "${var.elb_protocol_ext_1a}"
  elb_protocol_ext_1b = "${var.elb_protocol_ext_1b}"
  elb_protocol_ext_2  = "${var.elb_protocol_ext_2}"
  elb_port_ext_1a     = "${var.elb_port_ext_1a}"
  elb_port_ext_1b     = "${var.elb_port_ext_1b}"
  elb_port_ext_2      = "${var.elb_port_ext_2}"
  sg_elb              = ["${aws_security_group.dmz_elb1_sg.id}"]
}

###########
## Route53_UCP
#

module "route53" {
  source = "modules/route53/route_UCP/"

  domain_name     = "${var.domain_name}.com"
  main_vpc        = "${aws_vpc.dmz_vpc.id}"
  environment     = "tool"
  product_domain  = "de"
  name_alb        = "${module.elb_ucp.alb_ucp-dns_name}"
  elb_ucp-zone_id = "${module.elb_ucp.elb_ucp-zone_id}"
}

###########
## VPC
#
module "app-vpc" {
  source   = "modules/vpc/vpc_app"
#  app_cidr = "${var.vpc_cidr}"
#  peer_rt  = "${module.peer-vpc-app.primary2secondary_req}"

  # depends_on = ["${aws_vpc.dmz_vpc.id}"]
}

#----------- prod vpc -------------->

module "prod-vpc" {
  source = "modules/vpc/vpc_prod"
  
  providers = {
    aws = "aws.accepter"
  }
	  #peer_rt  = "${module.peer-vpc-prod.primary2secondary_req}"
  
  # depends_on = ["${aws_vpc.dmz_vpc.id}"]
}


#############
##Peering 
#
 
data "aws_caller_identity" "prod" {
  provider = "aws.accepter"
 }
 
module "peer-vpc-prod" {
  source = "modules/peer/cross/" 
  
   providers = {
    aws.accepter = "aws.accepter"
    aws = "aws"
  }
  
  # requester
  vpc_id        = "${aws_vpc.dmz_vpc.id}"
  peer_vpc_id   = "${module.prod-vpc.vpc_prod_id}"
  peer_owner_id = "${data.aws_caller_identity.prod.account_id}"
  auto_accept_req   = "false"

  #Accepter
  auto_accept_acc   = "true"

}

#----------- app vpc peer --------->

data "aws_caller_identity" "app" {
  provider = "aws"
 }
 
module "peer-vpc-app" {
  source = "modules/peer/inter/" 
  
   providers = {
    aws = "aws"
  }
 
  # requester
  vpc_id            = "${aws_vpc.dmz_vpc.id}"
  peer_vpc_id       = "${module.app-vpc.vpc_app_id}"
  peer_owner_id     = "${data.aws_caller_identity.app.account_id}"
  auto_accept_req   = "true"

  #Accepter
  auto_accept_acc   = "true"
#  prov = "aws"

}


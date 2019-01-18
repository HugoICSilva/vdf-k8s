#------------IAM---------------- 
# Se necessario criar algum role
#

#------------------ VPC ---------------------

resource "aws_vpc" "app_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "app_vpc"
  }
}

#----------------------> Internet gateway

resource "aws_internet_gateway" "app_internet_gateway" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  tags {
    Name = "app_igw"
  }
}

#-----------------------> NAT GATEWAY/EIP

# A EIP for the NAT gateway.
resource "aws_eip" "app_nat_eip" {
  vpc = true
}

# The NAT gateway, attached to the _public_ network.
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.app_nat_eip.id}"
  subnet_id     = "${aws_subnet.app_public2_subnet.id}"
}

###########
##Route tables
##
resource "aws_route_table" "app_public_rt" {
  vpc_id = "${aws_vpc.app_vpc.id}"

  route {
    cidr_block = "${var.null_list}"
    gateway_id = "${aws_internet_gateway.app_internet_gateway.id}"
  }

  tags {
    Name = "app_public"
  }
}

resource "aws_default_route_table" "app_private_rt" {
  default_route_table_id = "${aws_vpc.app_vpc.default_route_table_id}"

  route {
    cidr_block     = "${var.null_list}"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  #  route {
  #    cidr_block                = "${var.app_cidr}"
  #    vpc_peering_connection_id = "${var.peer_rt}"
  #  }

  tags {
    Name = "app_private"
  }
}

##########
#Subenets
##
resource "aws_subnet" "app_public1_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "app_public1"
  }
}

resource "aws_subnet" "app_public2_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "app_public2"
  }
}

/**
resource "aws_subnet" "priv_master1_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "priv_master1"
  }
}

resource "aws_subnet" "priv_master2_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "priv_master2"
  }
}

resource "aws_subnet" "priv_master3_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name = "priv_master3"
  }
}
*/

resource "aws_subnet" "priv_worker1_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "priv_worker1"
  }
}

resource "aws_subnet" "priv_worker2_subnet" {
  vpc_id                  = "${aws_vpc.app_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "priv_worker2"
  }
}

#resource "aws_subnet" "priv_worker3_subnet" {
#  vpc_id                  = "${aws_vpc.app_vpc.id}"
#  cidr_block              = "${var.cidrs["priv_worker3"]}"
#  map_public_ip_on_launch = false
#  availability_zone       = "${data.aws_availability_zones.available.names[2]}"
#
#  tags {
#    Name = "priv_worker3"
#  }
#}

##############
#RT Associations
##
resource "aws_route_table_association" "public1_assoc" {
  subnet_id      = "${aws_subnet.app_public1_subnet.id}"
  route_table_id = "${aws_route_table.app_public_rt.id}"
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = "${aws_subnet.app_public2_subnet.id}"
  route_table_id = "${aws_route_table.app_public_rt.id}"
}

resource "aws_route_table_association" "private_assoc" {
  # subnet_id      = "${aws_subnet.priv_master1_subnet.id}"
  subnet_id      = "${aws_subnet.priv_worker1_subnet.id}"
  route_table_id = "${aws_default_route_table.app_private_rt.id}"
}

###############
##Security groups
##
/**
#---------> Public SG Bastion

resource "aws_security_group" "app_bastion_sg" {
  name        = "app_bastion_sg"
  description = "Used forBastion"
  vpc_id      = "${aws_vpc.app_vpc.id}"

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
*/

#---------> Public SG ELB1

resource "aws_security_group" "app_elb1_sg" {
  name        = "app_elb1_sg"
  description = "Used for public ELB1"
  vpc_id      = "${aws_vpc.app_vpc.id}"

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

/**
#----------> Master SG

resource "aws_security_group" "app_master_sg" {
  name        = "app_master_sg"
  description = "Utilizado para o Master"
  vpc_id      = "${aws_vpc.app_vpc.id}"

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
*/

# Cluster

resource "aws_security_group" "app_cluster_sg" {
  name        = "app_cluster_sg"
  description = "utilizado para o cluster"
  vpc_id      = "${aws_vpc.app_vpc.id}"

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

###########
## workers
#

module "worker01" {
  source = "../../ec2/worker/"

  instance_name         = "app_worker01"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.app_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.priv_worker1_subnet.id}"
  private_ip            = "${var.privIPs["worker01"]}"
  ambiente              = "app"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "tool"
}

#---------------------------------------------------------------------------------
module "worker02" {
  source = "../../ec2/worker/"

  instance_name         = "app_worker02"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.app_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[1]}"
  subnet_id             = "${aws_subnet.priv_worker2_subnet.id}"
  private_ip            = "${var.privIPs["worker02"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "false"
}

#---------------------------------------------------------------------------------
/**
module "worker03" {
  source = "../../ec2/worker/"

  instance_name = "app_worker03"
  chave         = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.app_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[2]}"
  subnet_id             = "${aws_subnet.priv_worker3_subnet.id}"
  private_ip            = "${var.privIPs["worker03"]}"
  ambiente              = "tool"
  txt                   = "worker-data.txt"

  # public_ip_address     = "false"
}
*/


/**
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
  
  vpc_name            = "${aws_vpc.app_vpc.id}"
  target1             ="${var.privIPs["master01"]}"
  target2             ="${var.privIPs["master02"]}"
  target3             ="${var.privIPs["master03"]}"
  elb_protocol_ext_1a = "${var.elb_protocol_ext_1a}"
  elb_protocol_ext_1b = "${var.elb_protocol_ext_1b}"
  elb_protocol_ext_2  = "${var.elb_protocol_ext_2}"
  elb_port_ext_1a     = "${var.elb_port_ext_1a}"
  elb_port_ext_1b     = "${var.elb_port_ext_1b}"
  elb_port_ext_2      = "${var.elb_port_ext_2}"
  sg_elb              = ["${aws_security_group.app_elb1_sg.id}"]
}


###########
## Route53_UCP
#

module "route53" {
  source = "modules/route53/route_UCP/"

  domain_name        = "${var.domain_name}.com"
  main_vpc           = "${aws_vpc.app_vpc.id}"
  environment        = "tool"
  product_domain     = "de"
  name_alb           = "${module.elb_ucp.alb_ucp-dns_name}"
  elb_ucp-zone_id    = "${module.elb_ucp.elb_ucp-zone_id}"
}
*/


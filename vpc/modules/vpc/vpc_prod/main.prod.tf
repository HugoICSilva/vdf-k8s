#------------IAM---------------- 
# Se necessario criar algum role
#
provider "aws" {}

#  region  = "${var.aws_region}"
#  profile = "${var.aws_profile}"

#------------------ VPC ---------------------

resource "aws_vpc" "prod_vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "prod_vpc"
  }
}

#----------------------> Internet gateway

resource "aws_internet_gateway" "prod_internet_gateway" {
  vpc_id = "${aws_vpc.prod_vpc.id}"

  tags {
    Name = "prod_igw"
  }
}

#-----------------------> NAT GATEWAY/EIP

# A EIP for the NAT gateway.
resource "aws_eip" "prod_nat_eip" {
  vpc = true
}

# The NAT gateway, attached to the _public_ network.
resource "aws_nat_gateway" "nat" {
  allocation_id = "${aws_eip.prod_nat_eip.id}"
  subnet_id     = "${aws_subnet.prod_public2_subnet.id}"
}

###########
##Route tables
##
resource "aws_route_table" "prod_public_rt" {
  vpc_id = "${aws_vpc.prod_vpc.id}"

  route {
    cidr_block = "${var.null_list}"
    gateway_id = "${aws_internet_gateway.prod_internet_gateway.id}"
  }

  tags {
    Name = "prod_public"
  }
}

resource "aws_default_route_table" "prod_private_rt" {
  default_route_table_id = "${aws_vpc.prod_vpc.default_route_table_id}"

  route {
    cidr_block     = "${var.null_list}"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
  }

  tags {
    Name = "prod_private"
  }
}

##########
#Subenets
##
resource "aws_subnet" "prod_public1_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["public1"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "prod_public1"
  }
}

resource "aws_subnet" "prod_public2_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["public2"]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "prod_public2"
  }
}

/**
resource "aws_subnet" "priv_master1_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "priv_master1"
  }
}

resource "aws_subnet" "priv_master2_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "priv_master2"
  }
}

resource "aws_subnet" "priv_master3_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["priv_master3"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[2]}"

  tags {
    Name = "priv_master3"
  }
}
*/

resource "aws_subnet" "priv_worker1_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker1"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[0]}"

  tags {
    Name = "priv_worker1"
  }
}

resource "aws_subnet" "priv_worker2_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
  cidr_block              = "${var.cidrs["priv_worker2"]}"
  map_public_ip_on_launch = false
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"

  tags {
    Name = "priv_worker2"
  }
}

resource "aws_subnet" "priv_worker3_subnet" {
  vpc_id                  = "${aws_vpc.prod_vpc.id}"
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
  subnet_id      = "${aws_subnet.prod_public1_subnet.id}"
  route_table_id = "${aws_route_table.prod_public_rt.id}"
}

resource "aws_route_table_association" "public2_assoc" {
  subnet_id      = "${aws_subnet.prod_public2_subnet.id}"
  route_table_id = "${aws_route_table.prod_public_rt.id}"
}

resource "aws_route_table_association" "private_assoc" {
  # subnet_id      = "${aws_subnet.priv_master1_subnet.id}"
  subnet_id      = "${aws_subnet.priv_worker1_subnet.id}"
  route_table_id = "${aws_default_route_table.prod_private_rt.id}"
}

###############
##Security groups
##

#---------> Public SG ELB1

resource "aws_security_group" "prod_elb1_sg" {
  name        = "prod_elb1_sg"
  description = "Used for public ELB1"
  vpc_id      = "${aws_vpc.prod_vpc.id}"

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

resource "aws_security_group" "prod_master_sg" {
  name        = "prod_master_sg"
  description = "Utilizado para o Master"
  vpc_id      = "${aws_vpc.prod_vpc.id}"

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

resource "aws_security_group" "prod_cluster_sg" {
  name        = "prod_cluster_sg"
  description = "utilizado para o cluster"
  vpc_id      = "${aws_vpc.prod_vpc.id}"

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

  instance_name         = "prod_worker01"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.prod_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[0]}"
  subnet_id             = "${aws_subnet.priv_worker1_subnet.id}"
  private_ip            = "${var.privIPs["worker01"]}"
  ambiente              = "prod"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "tool"
}

#---------------------------------------------------------------------------------
module "worker02" {
  source = "../../ec2/worker/"

  instance_name         = "prod_worker02"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.prod_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[1]}"
  subnet_id             = "${aws_subnet.priv_worker2_subnet.id}"
  private_ip            = "${var.privIPs["worker02"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "false"
}

#---------------------------------------------------------------------------------

module "worker03" {
  source = "../../ec2/worker/"

  instance_name         = "prod_worker03"
  chave                 = "${var.chave}"
  instance_type_bastion = "${var.instance_type_worker}"
  security_group        = "${aws_security_group.prod_cluster_sg.id}"
  availability_zone     = "${data.aws_availability_zones.available.names[2]}"
  subnet_id             = "${aws_subnet.priv_worker3_subnet.id}"
  private_ip            = "${var.privIPs["worker03"]}"
  ambiente              = "tool"
  txt                   = "modules/ec2/worker/worker-data.txt"

  # public_ip_address     = "false"
}

/**
module "peer-vpc-prod" {
  source = "../../peer/acc/"
  providers = {"aws" = "aws.peer"}
 # peer_owner = "${data.aws_caller_identity.current.account_id}"
 # peer_vpc   = "${module.prod-vpc.vpc_prod_id}"
 # vpc_main   = "${aws_vpc.dmz_vpc.id}"
  connection_id =  "${var.peer_rt}"

}

*/
provider "aws" {
  alias   = "peer"
  region  = "${var.aws_region1}"
  profile = "${var.aws_profile1}"
}

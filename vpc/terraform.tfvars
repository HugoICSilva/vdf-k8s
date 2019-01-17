#####################################################
## Variaveis para trocar

aws_profile = "Auto_CelFocus"
aws_region  = "eu-central-1"

aws_profile1 = "Auto_CelFocus_prod"
aws_region1  = "eu-central-1"

vpc_cidr    = "10.233.104.0/24"
cf_vpc      = "vgw-0b823046bd444cd7d"
cidrs         = {
 public1      = "10.233.104.0/28"
 public2      = "10.233.104.112/28"
 priv_master1 = "10.233.104.16/28"
 priv_master2 = "10.233.104.32/28"
 priv_master3 = "10.233.104.48/28"
 priv_worker1 = "10.233.104.64/28"
 priv_worker2 = "10.233.104.80/28" 
 priv_worker3 = "10.233.104.96/28" 
 }

auth_lista = [ "213.30.18.1/32", "85.246.181.205/32",
              "10.20.32.0/19", "88.157.199.114/32",
			   "192.168.90.169/32", "172.16.0.0/22"]

auth_lista2 = [ "213.30.18.1/32", "85.246.181.205/32",
              "10.20.32.0/19", "10.0.0.0/16"]

			  
chave = "VDF-DE-TEST"
null_list = "0.0.0.0/0"
vpc_list = ["10.233.104.0/26", "192.168.90.169/32", "172.16.0.0/22"]
			  
##----------------------------> Compute
instance_type_bastion = "t2.micro"
bastion_ami           = "ami-034fffcc6a0063961"

instance_type_master  = "t2.large"
instance_type_worker  = "t2.2xlarge"
instance_type_ansible = "t2.large"
front_ami             = "ami-0dfe9c96aee4dc8d6"

privIPs   = {
 bastion  = "10.233.104.6"
 dtr01    = "10.233.104.20"
 dtr02    = "10.233.104.36"
 dtr03    = "10.233.104.52"
 master01 = "10.233.104.21"
 dns      = "10.233.104.25"
 master02 = "10.233.104.37" 
 master03 = "10.233.104.53"
 worker01 = "10.233.104.68"
 worker02 = "10.233.104.85"
 worker03 = "10.233.104.101"
 } 

##------------------------------ elb-ucp
target_master_instances = {
    master01 = "10.233.104.21" 
    master02 = "10.233.104.37" 
    master03 = "10.233.104.53"
	}
	
elb_port_ext_1a = "443"
elb_port_ext_1b = "80"
elb_port_ext_2 = "80"
elb_protocol_ext_1a = "TCP"
elb_protocol_ext_1b = "HTTPS"
elb_protocol_ext_2 = "HTTP"

##-----------------------------> prefix  
domain_name = "tooling"
elb2_lista = [ "10.0.3.0/24", "10.0.4.0/24"]

##-----------------------------> Peers

app_cidr  = "10.233.105.0/24"
prod_cidr = "10.233.106.0/24"

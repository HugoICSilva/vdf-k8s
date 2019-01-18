#####################################################
## Variaveis para trocar

aws_profile = "Auto_CelFocus"
aws_region  = "eu-central-1"

aws_profile1 = "Auto_CelFocus_prod"
aws_region1  = "eu-central-1"

vpc_cidr    = "10.233.104.0/24"
cf_vpc      = "vgw-0b823046bd444cd7d"
cidrs         = {
 priv_dmz     = "10.233.104.0/28" 
 public1      = "10.233.104.16/28"
 priv_master1 = "10.233.104.32/28"
 priv_master2 = "10.233.104.48/28"
 priv_master3 = "10.233.104.64/28"
 priv_worker1 = "10.233.104.80/28" 
 priv_worker2 = "10.233.104.96/28"
 priv_worker3 = "10.233.104.112/28"
 priv_worker4 = "10.233.104.128/28"
 priv_worker5 = "10.233.104.145/28"
 priv_worker6 = "10.233.104.161/28"
 priv_worker7 = "10.233.104.177/28"
 }

auth_lista = [ "0.0.0.0/0"] #cant put here my ip list

auth_lista2 = ["0.0.0.0/0"] #cant put here my ip list

			  
chave = "VDF-DE-TEST"
null_list = "0.0.0.0/0"
vpc_list = ["0.0.0.0/0"] #cant put here my ip list

			  
##----------------------------> Compute
instance_type_bastion = "t2.micro"
bastion_ami           = "ami-034fffcc6a0063961"

instance_type_master  = "t2.large"
instance_type_worker  = "t2.2xlarge"
instance_type_ansible = "t2.large"
front_ami             = "ami-0dfe9c96aee4dc8d6"

privIPs   = {
 bastion_dmz   = "10.233.104.6"
 bastion_prod  = "10.233.104.7"
 dns      = "10.233.104.8"
 dtr01    = "10.233.104.38"
 dtr02    = "10.233.104.53"
 dtr03    = "10.233.104.69"
 master01 = "10.233.104.39"
 master02 = "10.233.104.54" 
 master03 = "10.233.104.70"
 worker01 = "10.233.104.86"
 worker02 = "10.233.104.101"
 worker03 = "10.233.104.117"
 worker04 = "10.233.104.134"
 worker05 = "10.233.104.150"
 worker06 = "10.233.104.166"
 worker07 = "10.233.104.182"
 } 

##------------------------------ elb-ucp
target_master_instances = {
    master01 = "10.233.104.39" 
    master02 = "10.233.104.54" 
    master03 = "10.233.104.70"
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

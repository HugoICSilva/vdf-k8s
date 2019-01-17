#####################################################
## Variaveis para trocar

aws_profile = "Auto_CelFocus"
aws_region  = "eu-central-1"
vpc_cidr    = 
cf_vpc      = "vgw-0b823046bd444cd7d"




			  



			  
##----------------------------> Bastion/DTRs/Master/workers





##------------------------------ elb-ucp
target_master_instances = {
    master01 = "10.233.105.21" 
    master02 = "10.233.105.37" 
    master03 = "10.233.105.53"
	}
	
elb_port_ext_1a = "443"
elb_port_ext_1b = "80"
elb_port_ext_2 = "80"
elb_protocol_ext_1a = "TCP"
elb_protocol_ext_1b = "HTTPS"
elb_protocol_ext_2 = "HTTP"

##-----------------------------> prefix  
prefix = "rancher_teste"
instance_name = "dmz_bastion"
domain_name = "tooling"

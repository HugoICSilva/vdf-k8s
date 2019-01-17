#variable "bastion_ami" {
#  description = "ami para bastion"
#}
#-------------------------------------------------
variable "chave" {
  description = "ssh key"
}

#-------------------------------------------------
variable "instance_type_bastion" {
  description = "tipo de instancia"
}

#-------------------------------------------------
variable "security_group" {
  description = "SG Utilizado"
}

#-------------------------------------------------
variable "availability_zone" {
  type        = "string"
  description = "AZ utilizada"
}

#-------------------------------------------------
variable "subnet_id" {
  description = "subnet utilizada"
}

#-------------------------------------------------
variable "private_ip" {
  #  type        = "string"
  description = "ip privado"
}

#-------------------------------------------------
variable "instance_name" {
  type        = "string"
  description = "Nome da maquina"
}

#-------------------------------------------------
variable "ambiente" {
  type        = "string"
  description = "ambiente da maquina"
}

#-------------------------------------------------
#variable "public_ip_address" {
#  type        = "string"
#  description = "ambiente da maquina"
#}
#-------------------------------------------------
variable "txt" {
  type        = "string"
  description = "BootStrap file"
}

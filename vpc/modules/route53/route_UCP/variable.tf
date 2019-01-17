variable "product_domain" {
  type        = "string"
  description = "Abbreviation of the product domain this Route 53 zone belongs to"
}

variable "environment" {
  type        = "string"
  description = "Environment this Route 53 zone belongs to"
}

variable "main_vpc" {
  type = "string"
}

variable "force_destroy" {
  type        = "string"
  default     = false
  description = "Whether to destroy all records inside if the hosted zone is deleted"
}

variable "domain_name" {
  type = "string"
}

variable "name_alb" {}
variable "elb_ucp-zone_id" {}

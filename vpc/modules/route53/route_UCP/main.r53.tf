locals {
  description = "Private zone for ${var.domain_name}"
}

resource "aws_route53_zone" "tooling" {
  name          = "${var.domain_name}"
  vpc_id        = "${var.main_vpc}"
  comment       = "${local.description}"
  force_destroy = "${var.force_destroy}"

  tags = {
    "Name"          = "${var.domain_name}"
    "ProductDomain" = "${var.product_domain}"
    "Environment"   = "${var.environment}"
    "ManagedBy"     = "Terraform"
  }
}

#UCP_MANAGERS

resource "aws_route53_record" "UCP" {
  zone_id = "${aws_route53_zone.tooling.zone_id}"
  name    = "www.UCP"
  type    = "A"

  alias {
    name                   = "${var.name_alb}"
    zone_id                = "${var.elb_ucp-zone_id}"
    evaluate_target_health = true
  }
}

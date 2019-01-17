# Create a new load balancer

###########
## ALB
#
resource "aws_alb" "elb_ucp" {
  name                       = "elbucp"
  internal                   = true
  security_groups            = ["${var.sg_elb}"]
  subnets                    = ["${var.elb_ucp_subnets}"]
  enable_deletion_protection = false                      #proteçao contra destruição
}

###########
## Target Group
#
resource "aws_alb_target_group" "alb_ucp_master" {
  name = "albucpmaster"

  target_type = "ip"
  vpc_id      = "${var.vpc_name}"
  port        = "443"
  protocol    = "HTTPS"

  health_check {
    path                = "/"
    port                = "443"
    protocol            = "HTTPS"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 5
    timeout             = 4
    matcher             = "200-308"
  }
}

#############
## Targets
#

##-------------> targets 1
resource "aws_alb_target_group_attachment" "alb_backend-01_http" {
  target_group_arn = "${aws_alb_target_group.alb_ucp_master.arn}"
  target_id        = "${var.target1}"
  port             = 443

  lifecycle {
    create_before_destroy = true
  }
}

##-------------> targets 2
resource "aws_alb_target_group_attachment" "alb_backend-02_http" {
  target_group_arn = "${aws_alb_target_group.alb_ucp_master.arn}"
  target_id        = "${var.target2}"
  port             = 443

  lifecycle {
    create_before_destroy = true
  }
}

##-------------> targets 3
resource "aws_alb_target_group_attachment" "alb_backend-03_http" {
  target_group_arn = "${aws_alb_target_group.alb_ucp_master.arn}"
  target_id        = "${var.target3}"
  port             = 443

  lifecycle {
    create_before_destroy = true
  }
}

###############
## Listeners
#
resource "aws_alb_listener" "alb_front_https" {
  load_balancer_arn = "${aws_alb.elb_ucp.arn}"
  port              = "80"
  protocol          = "HTTP"

  #	ssl_policy		=	"ELBSecurityPolicy-2016-08"
  #	certificate_arn		=	"${aws_iam_server_certificate.url1_valouille_fr.arn}"
  default_action {
    target_group_arn = "${aws_alb_target_group.alb_ucp_master.arn}"
    type             = "forward"
  }
}

/**
resource "aws_route53_record" "UCP" {
  zone_id = "${var.zone_id}" # Replace with your zone ID
  name    = "www.DTR-tooling.com" # Replace with your name/domain/subdomain
  type    = "A"

  alias {
    name                   = "${aws_alb.elb_ucp.dns_name}"
    zone_id                = "${aws_alb.elb_ucp.zone_id}"
    evaluate_target_health = true
  }
}
*/


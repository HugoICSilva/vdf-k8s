# Create a new load balancer
resource "aws_elb" "elb1" {
  name = "elb1"

  #availability_zones = ["${data.aws_availability_zones.all.names}"]
  #availability_zones = ["${data.aws_availability_zones.available.names[0]}", "${data.aws_availability_zones.available.names[1]}", "${data.aws_availability_zones.available.names[2]}"]
  subnets = ["${aws_subnet.dmz_public1_subnet.id}"]

  #subnets = ["${aws_subnet.priv_master1_subnet.id}", "${aws_subnet.priv_master2_subnet.id}", "${aws_subnet.priv_master3_subnet.id}"]

  #  vpc_id             = "${aws_vpc.dmz_vpc.id}"
  security_groups = ["${aws_security_group.dmz_elb1_sg.id}"]
  internal        = "false"
  listener {
    instance_port     = "${var.elb_ext_1}"
    instance_protocol = "http"
    lb_port           = "${var.elb_ext_1}"
    lb_protocol       = "http"
  }
  listener {
    instance_port     = "${var.elb_ext_2}"
    instance_protocol = "http"
    lb_port           = "${var.elb_ext_2}"
    lb_protocol       = "http"
  }
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances                   = ["${module.master01.id}", "${module.master02.id}", "${module.master03.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
  tags {
    Name = "elb1"
  }
}

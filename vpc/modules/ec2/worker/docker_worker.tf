#------------ Instancias ----------------

resource "aws_instance" "compute" {
  # name                   = "${var.instance_name}"
  instance_type          = "${var.instance_type_bastion}"
  key_name               = "${var.chave}"
  vpc_security_group_ids = ["${var.security_group}"]

  # associate_public_ip_address = "${public_ip_address}"
  private_ip = "${var.private_ip}"

  #  user_data                   = "${file("worker-data.txt")}"
  user_data = "${file("${var.txt}")}"

  #  depends_on                  = "${var.depends_on}"
  ##
  ##--------------------------------------
  ##           Discos/Imagem

  root_block_device {
    volume_type           = "gp2"
    volume_size           = "35"
    delete_on_termination = "true"
  }
  ebs_block_device {
    device_name           = "/dev/sdg"
    volume_size           = 200
    volume_type           = "gp2"
    delete_on_termination = true
  }
  tags {
    Name = "${var.instance_name}"
    Env  = "${var.ambiente}"
  }
  ami               = "${data.aws_ami.rhe7_5.id}"
  availability_zone = "${var.availability_zone}"
  subnet_id         = "${var.subnet_id}"
}

##
##----------> escolher AMI rhe7_5
##
data "aws_ami" "rhe7_5" {
  # owners      = ["679593333241"] -> centos
  owners      = ["309956199498"]
  most_recent = true

  filter {
    name = "name"

    #values = ["CentOS Linux 7 x86_64 HVM EBS *"] -> centos
    values = ["RHEL-7.3_HVM-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

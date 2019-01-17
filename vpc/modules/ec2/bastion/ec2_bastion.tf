#------------ Instancias ----------------

# Bastion
resource "aws_instance" "instance" {
  instance_type               = "${var.instance_type_bastion}"
  key_name                    = "${var.chave}"
  vpc_security_group_ids      = ["${var.security_group}"]
  associate_public_ip_address = "${var.public_ip}"
  private_ip                  = "${var.private_ip}"
  user_data                   = "${file("${var.txt}")}"

  tags {
    Name = "${var.instance_name}"
    Env  = "${var.ambiente}"
  }

  ami               = "${var.bastion_ami}"
  availability_zone = "${var.availability_zone}"
  subnet_id         = "${var.subnet_id}"
}

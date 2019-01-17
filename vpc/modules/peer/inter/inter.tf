
# Requester's side of the connection.
resource "aws_vpc_peering_connection" "peer" {

  vpc_id        = "${var.vpc_id}"
  peer_vpc_id   = "${var.peer_vpc_id}"
  peer_owner_id = "${var.peer_owner_id}"
  auto_accept   = "${var.auto_accept_req}"
 
  tags = {
    SideR = "Requester"
  }
}

#--------- ACCEPTER ------------->

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "peer" {
  provider = "aws"

  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
  auto_accept               = "${var.auto_accept_acc}"
  
  tags = {
    SideA = "Accepter"
  }
}

#-------------- DNS RESOLVE ------->

resource "aws_vpc_peering_connection_options" "requester" {
  provider = "aws"

  # As options can't be set until the connection has been accepted
  # create an explicit dependency on the accepter.
  vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.peer.id}"

  requester {
    allow_remote_vpc_dns_resolution = true
  }
}



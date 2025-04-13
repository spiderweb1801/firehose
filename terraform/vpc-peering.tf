resource "aws_vpc_peering_connection" "app_splunk_peering_aps1" {
  provider    = aws.aps1
  vpc_id      = module.splunk-aps1.network_details.vpc_id
  peer_vpc_id = module.app-aps1.network_details.vpc_id
  auto_accept = true # Use false if accounts are different

  tags = {
    Name = "App-to-Splunk-Peering"
  }
}

resource "aws_route" "app_to_splunk_pub" {
  provider                  = aws.aps1
  route_table_id            = module.app-aps1.network_details.public_rtb
  destination_cidr_block    = var.splunk_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_splunk_peering_aps1.id
}

resource "aws_route" "app_to_splunk_private" {
  provider                  = aws.aps1
  route_table_id            = module.app-aps1.network_details.private_rtb
  destination_cidr_block    = var.splunk_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_splunk_peering_aps1.id
}

resource "aws_route" "splunk_to_app_pub" {
  provider                  = aws.aps1
  route_table_id            = module.splunk-aps1.network_details.public_rtb
  destination_cidr_block    = var.app_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_splunk_peering_aps1.id
}

resource "aws_route" "splunk_to_app_private" {
  provider                  = aws.aps1
  route_table_id            = module.splunk-aps1.network_details.private_rtb
  destination_cidr_block    = var.app_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_splunk_peering_aps1.id
}

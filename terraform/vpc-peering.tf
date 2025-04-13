resource "aws_vpc_peering_connection" "app_splunk_peering_aps1" {
  vpc_id      = module.splunk-aps1.network_details.vpc_id
  peer_vpc_id = module.app-aps1.network_details.vpc_id
  auto_accept = true # Use false if accounts are different

  tags = {
    Name = "App-to-Splunk-Peering"
  }
}

resource "aws_route" "app_to_splunk" {
  for_each                  = [module.app-aps1.network_details.public_rtb, module.app-aps1.network_details.private_rtb]
  route_table_id            = each.value
  destination_cidr_block    = var.splunk_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_splunk_peering_aps1.id
}

resource "aws_route" "splunk_to_app" {
  for_each                  = [module.app-aps1.splunk-aps1.public_rtb, module.splunk-aps1.network_details.private_rtb]
  route_table_id            = each.value
  destination_cidr_block    = var.app_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.splunk_peering.id
}

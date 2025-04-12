output "network_details" {
    value = {
        vpc_id = aws_vpc.main.id
        public_subnet_ids = [ for i in aws_subnet.public_subnets : i.id]
        private_subnet_ids = [ for i in aws_subnet.private_subnets : i.id]
        public_rtb  =   aws_route_table.public_rtb.id
        private_rtb  =   aws_route_table.private_rtb.id
    }
}

output "ec2_details" {
    value = {
        ec2_id = aws_instance.app_server.id
        ec2_public_ip = aws_instance.app_server.public_ip
        ec2_private_ip = aws_instance.app_server.private_ip
    }
}
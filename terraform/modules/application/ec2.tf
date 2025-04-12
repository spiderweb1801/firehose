resource "aws_instance" "app_server" {
  ami           = var.instance_config.ami_id
  instance_type = var.instance_config.instance_type
  key_name      = var.instance_config.key_name
  user_data     = var.instance_config.user_data
  subnet_id              = var.instance_config.public_enabled ? aws_subnet.public_subnets["subnet1"].id : aws_subnet.private_subnets["subnet1"].id
  root_block_device {
    volume_type = "gp3"
    volume_size = 30
    delete_on_termination = true
  }

  tags = {
    Name = var.instance_config.app_name
  }

  vpc_security_group_ids = [aws_security_group.default_sg.id]
}

resource "aws_security_group" "default_sg" {
  vpc_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = "${var.instance_config.app_name}-default-security-group"
  }
}


module "app-aps1" {
  source = "./modules/application"
  providers = {
    aws = aws.aps1
  }
  instance_config = {
    cidr_block     = var.app_cidr
    app_name       = var.app_name
    ami_id         = data.aws_ami.amazon_linux_gp3.id
    instance_type  = var.instance_type
    key_name       = var.key_name
    user_data      = data.template_file.user_data.rendered
    public_enabled = true
  }
  ingress_rules = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

data "template_file" "user_data" {
  template = file("${path.module}/scripts/application.sh")
}

data "aws_ami" "amazon_linux_gp3" {
  provider    = aws.aps1
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

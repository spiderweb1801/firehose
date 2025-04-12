module "app-aps1" {
  source = "./modules/application"
  providers = {
    aws = aws.aps1
  }
  instance_config = {
    cidr_range   = var.cidr
    app_name     = "app-aps1"
    ami_id    = data.aws_ami.amazon_linux_gp3.id
    instance_type = "string"
    key_name = "string"
    user_data = data.template_file.user_data.rendered
    public_enabled = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/userdata.sh")
}

data "aws_ami" "amazon_linux_gp3" {
  provider = aws.aps1
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp3"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

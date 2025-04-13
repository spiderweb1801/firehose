module "splunk-aps1" {
  source = "./modules/application"
  providers = {
    aws = aws.aps1
  }
  instance_config = {
    cidr_block     = var.splunk_cidr
    app_name       = "splunk-aps1"
    ami_id         = data.aws_ami.amazon_linux_gp3.id
    instance_type  = var.instance_type
    key_name       = var.key_name
    public_enabled = true
  }
  #   ingress_rules = [
  #     { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  #     { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  #     { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
  #     { from_port = 8000, to_port = 8000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  #   ]
}

data "template_file" "splunk_userdata" {
  template = file("${path.module}/scripts/splunk_userdata.sh.tftpl")

  vars = {
    indexer_port   = "9997"
    admin_password = "changeme" # Ideally pass via variable or secrets manager
  }
}

resource "aws_lb" "splunk_nlb" {
  provider           = aws.aps1
  name               = "splunk-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = module.splunk-aps1.network_details.public_subnet_ids
}

resource "aws_lb_target_group" "splunk_tg" {
  provider    = aws.aps1
  name        = "splunk-tg"
  port        = 8088
  protocol    = TCP
  vpc_id      = module.splunk-aps1.network_details.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "splunk_instance" {
  provider         = aws.aps1
  target_group_arn = aws_lb_target_group.splunk_tg.arn
  target_id        = module.splunk-aps1.ec2_details.ec2_id
  port             = 8088
}

resource "aws_lb_listener" "splunk_listener" {
  provider          = aws.aps1
  load_balancer_arn = aws_lb.splunk_nlb.arn
  port              = 8088
  protocol          = TCP

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.splunk_tg.arn
  }
}

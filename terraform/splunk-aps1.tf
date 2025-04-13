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

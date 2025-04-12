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
    user_data      = data.template_file.splunk_userdata.rendered
    public_enabled = true
  }
}

data "template_file" "splunk_userdata" {
  template = file("${path.module}/scripts/splunk_userdata.sh.tftpl")

  vars = {
    indexer_port   = "9997"
    admin_password = "changeme" # Ideally pass via variable or secrets manager
  }
}

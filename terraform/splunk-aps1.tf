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
  ingress_rules = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 8000, to_port = 8000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 8088, to_port = 8088, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
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
  protocol    = "TCP"
  vpc_id      = module.splunk-aps1.network_details.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "splunk_instance" {
  provider         = aws.aps1
  target_group_arn = aws_lb_target_group.splunk_tg.arn
  target_id        = module.splunk-aps1.ec2_details.ec2_id
  port             = 8088
}

# resource "aws_lb_listener" "splunk_listener" {
#   provider          = aws.aps1
#   load_balancer_arn = aws_lb.splunk_nlb.arn
#   port              = 8088
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.splunk_tg.arn
#   }
# }

resource "aws_lb_listener" "splunk_tls_listener" {
  provider          = aws.aps1
  load_balancer_arn = aws_lb.splunk_nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"
  certificate_arn   = aws_acm_certificate.splunk_internal_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.splunk_tg.arn
  }
}

# resource "aws_acm_certificate" "splunk_cert" {
#   provider          = aws.aps1
#   domain_name       = "splunk.internal.example.com"
#   validation_method = "DNS"
#   tags = {
#     Name = "splunk-acm"
#   }
# }

# resource "aws_route53_record" "splunk_cert_validation" {
#   provider = aws.aps1
#   zone_id  = aws_route53_zone.splunk_internal.zone_id

#   name    = tolist(aws_acm_certificate.splunk_cert.domain_validation_options)[0].resource_record_name
#   type    = tolist(aws_acm_certificate.splunk_cert.domain_validation_options)[0].resource_record_type
#   records = [tolist(aws_acm_certificate.splunk_cert.domain_validation_options)[0].resource_record_value]
#   ttl     = 300
# }

# resource "aws_acm_certificate_validation" "splunk_cert_validation" {
#   provider                = aws.aps1
#   certificate_arn         = aws_acm_certificate.splunk_cert.arn
#   validation_record_fqdns = [aws_route53_record.splunk_cert_validation.fqdn]
# }

resource "aws_acmpca_certificate_authority" "splunk_ca" {
  type = "ROOT"

  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA256WITHRSA"

    subject {
      common_name         = "splunk.internal.example.com"
      organization        = "Splunk"
      organizational_unit = "IT"
      country             = "IN"
      state               = "Delhi"
      locality            = "New Delhi"
    }
  }

  permanent_deletion_time_in_days = 7
}

# resource "aws_acm_certificate" "splunk_internal_cert" {
#   domain_name       = "splunk.internal.example.com"
#   certificate_authority_arn = aws_acmpca_certificate_authority.splunk_ca.arn
#   validation_method = "EMAIL"
# }

# resource "tls_private_key" "splunk_key" {
#   algorithm = "RSA"
#   rsa_bits  = 2048
# }

# resource "tls_cert_request" "splunk_csr" {
#   key_algorithm   = "RSA"
#   private_key_pem = tls_private_key.splunk_key.private_key_pem

#   subject {
#     common_name  = "splunk.internal.example.com"
#     organization = "Splunk"
#   }
# }

# resource "aws_acmpca_certificate" "splunk_cert" {
#   certificate_authority_arn = aws_acmpca_certificate_authority.splunk_ca.arn
#   certificate_signing_request = tls_cert_request.splunk_csr.cert_request_pem
#   signing_algorithm = "SHA256WITHRSA"
#   validity {
#     type  = "DAYS"
#     value = 365
#   }
# }

# resource "aws_acm_certificate" "imported_cert" {
#   private_key       = tls_private_key.splunk_key.private_key_pem
#   certificate_body  = aws_acmpca_certificate.splunk_cert.certificate
#   certificate_chain = aws_acmpca_certificate.splunk_cert.certificate_chain
# }

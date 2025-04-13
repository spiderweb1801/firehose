resource "aws_route53_zone" "splunk_internal" {
  provider = aws.aps1
  name     = "internal.example.com"
  vpc {
    vpc_id = module.splunk-aps1.network_details.vpc_id
  }
  comment = "Private zone for Splunk HEC endpoint"
}

resource "aws_route53_record" "splunk_dns" {
  provider = aws.aps1
  zone_id  = aws_route53_zone.splunk_internal.zone_id
  name     = "splunk.internal.example.com"
  type     = "A"
  alias {
    name                   = aws_lb.splunk_nlb.dns_name
    zone_id                = aws_lb.splunk_nlb.zone_id
    evaluate_target_health = true
  }
}

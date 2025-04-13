resource "aws_kinesis_firehose_delivery_stream" "splunk_stream" {
  provider    = aws.aps1
  name        = "vpc-flowlogs-to-splunk"
  destination = "splunk"

  splunk_configuration {
    hec_endpoint               = "https://splunk.internal.example.com:443" //"http://ip-10-0-2-4.ap-south-1.compute.internal:8000" #"http://${module.splunk-aps1.ec2_details.ec2_private_ip}:8000" # http://ip-10-0-2-4.ap-south-1.compute.internal:8000
    hec_token                  = var.splunk_hec_token
    hec_acknowledgment_timeout = 600
    hec_endpoint_type          = "Event"
    retry_duration             = 300
    s3_backup_mode             = "FailedEventsOnly"
    s3_configuration {
      role_arn           = aws_iam_role.firehose_role.arn
      bucket_arn         = aws_s3_bucket.backup.arn
      buffering_interval = 300
      buffering_size     = 5
      compression_format = "GZIP"
    }
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/splunk-stream"
      log_stream_name = "splunk-delivery"
    }
  }

  depends_on = [aws_iam_role.firehose_role]
}

resource "aws_s3_bucket" "backup" {
  provider = aws.aps1
  bucket   = "firehose-backup-splunk-${random_id.rand.hex}"
}

resource "random_id" "rand" {
  byte_length = 4
}

resource "aws_cloudwatch_log_group" "vpc_logs" {
  provider          = aws.aps1
  name              = "/vpc/flowlogs"
  retention_in_days = 7
}

resource "aws_flow_log" "vpc_flow" {
  provider             = aws.aps1
  log_destination_type = "cloud-watch-logs"
  iam_role_arn         = aws_iam_role.cw_logs_to_firehose.arn
  log_destination      = aws_cloudwatch_log_group.vpc_logs.arn
  traffic_type         = "ALL"
  vpc_id               = module.app-aps1.network_details.vpc_id
}

resource "aws_cloudwatch_log_subscription_filter" "flowlog_to_firehose" {
  provider        = aws.aps1
  name            = "flowlog-to-firehose"
  log_group_name  = aws_cloudwatch_log_group.vpc_logs.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.splunk_stream.arn
  role_arn        = aws_iam_role.cw_logs_to_firehose.arn

  depends_on = [aws_kinesis_firehose_delivery_stream.splunk_stream]
}

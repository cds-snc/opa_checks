resource "aws_cloudwatch_log_metric_filter" "yada" {
  name           = "MyAppAccessCount"
  pattern        = "/\"levelname\": \"ERROR\"/"
  log_group_name = aws_cloudwatch_log_group.dada.name

  metric_transformation {
    name      = "EventCount"
    namespace = "YourNamespace"
    value     = "1"
  }
}

resource "aws_cloudwatch_log_group" "dada" {
  name = "MyApp/access.log"
}
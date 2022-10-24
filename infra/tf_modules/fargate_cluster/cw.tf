/*----------------------------------------------------------------------------------------------------------------------
  Cloudwatch Log Group
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_cloudwatch_log_group" "main" {
  name              = "/fargate/${var.project_name}-${var.environment}"
  retention_in_days = 30
  tags = var.tags
}

/*----------------------------------------------------------------------------------------------------------------------
  Cloudwatch Log Stream
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_cloudwatch_log_stream" "main" {
  name           = "${var.project_name}-${var.environment}"
  log_group_name = aws_cloudwatch_log_group.main.name
}
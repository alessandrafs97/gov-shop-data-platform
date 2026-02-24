resource "aws_cloudwatch_log_group" "sfn_log_group" {
  name              = "/aws/states/${var.project_name}-${var.environment}-pipeline"
  retention_in_days = 14
}

resource "aws_cloudwatch_log_resource_policy" "sfn_logs_policy" {
  policy_name = "${var.project_name}-${var.environment}-sfn-logs-policy"

  policy_document = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowStepFunctionsLogging"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.sfn_log_group.arn}:*"
      }
    ]
  })
}
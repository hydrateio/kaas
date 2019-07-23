resource "aws_cloudwatch_log_group" "main" {
  name = "/aws/codebuild/${var.name}"
}

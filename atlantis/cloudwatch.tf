resource "aws_cloudwatch_log_group" "atlantis" {
  name = "/aws/fargate/atlantis"
}

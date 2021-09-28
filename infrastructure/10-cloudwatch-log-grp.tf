
resource "aws_cloudwatch_log_group" "springbootapp_log_group" {
    name       = "${local.prefix}-App-LogGroup"
}
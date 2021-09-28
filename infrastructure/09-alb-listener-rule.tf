
resource "aws_alb_listener_rule" "ecs_alb_listener_rule" {
  listener_arn = [data.terraform_remote_state.platform.outputs.ecs_alb_listener_arn]
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_target_group.arn
  }

  # condition {
  #   host_header {
  #     values = ["${lower(var.ecs_service_name)}.${data.terraform_remote_state.platform.outputs.ecs_domain_name}"]
  #   }
  # }
}
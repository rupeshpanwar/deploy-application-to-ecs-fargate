resource "aws_alb_target_group" "ecs_app_target_group" {
   name       = "${local.prefix}-APP-TG"
  port        = var.docker_container_port
  protocol    = "HTTP"
  vpc_id      = data.terraform_remote_state.infrastructure.outputs.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = "60"
    timeout             = "30"
    unhealthy_threshold = "3"
    healthy_threshold   = "3"
  }

      tags = merge(
    local.common_tags,
    {
        Name = "${local.prefix}-APP-TG"
    }
  )
}
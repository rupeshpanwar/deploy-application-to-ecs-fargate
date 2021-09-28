resource "aws_ecs_task_definition" "application-task-definition" {
  container_definitions     = data.template_file.ecs_task_definition_template.rendered
  family                    = var.ecs_service_name
  cpu                       = 512
  memory                    = var.memory
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  execution_role_arn        = aws_iam_role.fargate_iam_role.arn
  task_role_arn             = aws_iam_role.fargate_iam_role.arn
}

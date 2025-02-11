resource "aws_ecs_task_definition" "cat_gif_task" {
  family                   = "cat-gif-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "cat-gif-container",
      image     = "${aws_ecr_repository.cat_gif_repo.repository_url}:latest",
      memory    = 512,
      cpu       = 256,
      essential = true,
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
    }
  ])
}

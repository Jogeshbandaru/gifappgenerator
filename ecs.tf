resource "aws_ecs_cluster" "cat_gif_cluster" {
  name = "cat-gif-cluster"
}

resource "aws_ecs_task_definition" "cat_gif_task" {
  family                   = "cat-gif-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "cat-gif-container"
      image     = "${aws_ecr_repository.cat_gif_app_repo.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [{
        containerPort = 5000
        hostPort      = 5000
      }]
    }
  ])
}

resource "aws_ecs_service" "cat_gif_service" {
  name            = "cat-gif-service"
  cluster         = aws_ecs_cluster.cat_gif_cluster.id
  task_definition = aws_ecs_task_definition.cat_gif_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public.id, aws_subnet.private.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}

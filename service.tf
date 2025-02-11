resource "aws_ecs_service" "cat_gif_service" {
  name            = "cat-gif-service"
  cluster         = aws_ecs_cluster.cat_gif_cluster.id
  task_definition = aws_ecs_task_definition.cat_gif_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.cat_gif_tg.arn
    container_name   = "cat-gif-container"
    container_port   = var.container_port
  }

  desired_count = 1
}

resource "aws_lb" "cat_gif_alb" {
  name               = "cat-gif-alb"
  internal           = false
  load_balancer_type = "application"
  subnets           = aws_subnet.public[*].id
}

resource "aws_lb_target_group" "cat_gif_tg" {
  name        = "cat-gif-tg"
  port        = var.alb_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"
}

resource "aws_lb_listener" "cat_gif_listener" {
  load_balancer_arn = aws_lb.cat_gif_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cat_gif_tg.arn
  }
}

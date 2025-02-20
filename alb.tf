resource "aws_lb" "cat_gif_alb" {
  name               = "cat-gif-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.ecs_sg.id]
  subnets            = [aws_subnet.public.id, aws_subnet.private.id]
}

resource "aws_lb_target_group" "cat_gif_tg" {
  name     = "cat-gif-target-group"
  port     = 5000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb_listener" "cat_gif_listener" {
  load_balancer_arn = aws_lb.cat_gif_alb.arn
  port              = 5000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cat_gif_tg.arn
  }
}

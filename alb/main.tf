# main.tf - alb
resource "aws_lb" "alb_ecs" {
  # count              = length(var.alb_public_subnets)
  name               = "alb-fargate-ecs"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_public_sg.id]
  subnets            = [for subnet in var.alb_public_subnets : subnet.id]

  enable_deletion_protection = false

  tags = {
    Name        = "alb-ecs-fargate"
    Environment = "production"
  }
}


resource "aws_alb_target_group" "app_target_group" {
  name        = "blockchain"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"


  health_check {
    healthy_threshold   = "2"
    interval            = "60"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "30"
    path                = "/health"
    unhealthy_threshold = "2"
  }
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.alb_ecs.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app_target_group.arn
    type             = "forward"
  }

}

output "alb_metadata" {
  value = aws_lb.alb_ecs
}

output "alb_target_group_id" {
  value = aws_alb_target_group.app_target_group.id
}

output "aws_lb_id" {
  value = aws_lb.alb_ecs.id
}

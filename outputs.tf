
# output "elliott_vpc_public_sg" {
#   value = module.vpc
# }


output "elliott_vpc_id" {
  value = module.vpc.elliott_vpc_id
}


output "elliott_vpc_public_sg_id" {
  value = module.vpc.elliott_public_sg.id
}

output "public_subnets" {
  value = module.vpc.vpc_public_subnets[*].id
}

#ECS

output "ecs_arn" {
  value = module.ecs.ecs_metadata_from_module["arn"]
}

#Kratos Role
output "iam_role_for_ecs_alb_arn" {
  value = module.ecs.ecs_kratos_role.arn
}

#ALB
output "alb_arn" {
  value = module.alb.alb_metadata.arn
}


output "alb_target_group_id" {
  value = module.alb.alb_target_group_id
}

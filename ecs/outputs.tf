output "ecs_metadata_from_module" {
  value = aws_ecs_cluster.ecs_blockchain_cluster
}

output "ecs_kratos_role" {
  value = aws_iam_role.ecs_task_role
}


#
# resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_provider" {
#   cluster_name       = aws_ecs_cluster.ecs_blockchain_cluster.name
#   capacity_providers = ["FARGATE"]
# }

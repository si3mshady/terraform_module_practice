resource "aws_ecs_cluster" "ecs_blockchain_cluster" {
  name = "ecs_blockchain_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}



resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_provider" {
  cluster_name       = aws_ecs_cluster.ecs_blockchain_cluster.name
  capacity_providers = ["FARGATE"]
}

# TASK Def
resource "aws_ecs_task_definition" "ecs_task_def" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 512
  memory                   = 1024
  family                   = "blockchain"
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([
    {
      name = "blockchain"
      # image = "si3mshady/blockchaindev:latest"
      image     = "si3mshady/healthcheck-activepassive:2"
      cpu       = 512
      memory    = 1024
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])

}

#ECS Service
resource "aws_ecs_service" "service_handler" {
  depends_on      = [var.aws_lb_id]
  name            = "blockchain"
  cluster         = aws_ecs_cluster.ecs_blockchain_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  # iam_role        = aws_iam_role.ecs_kratos_role.arn
  #
  network_configuration {
    security_groups  = [var.alb_public_sg.id]
    subnets          = [for subnet in var.alb_public_subnets : subnet.id]
    assign_public_ip = true
  }
  #
  load_balancer {
    target_group_arn = var.target_group
    container_name   = "blockchain"
    container_port   = 80
  }

  # placement_constraints {
  #   type       = "memberOf"
  #   expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  # }
}


#IAM ROLE + POLICY
resource "aws_iam_role" "ecs_task_role" {
  name = "blockchain"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_policy" "ecs_task_policy" {
  name = "blockchain-policy"

  policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
       {
           "Effect": "Allow",
           "Action": "*",
           "Resource": "*"
       }
   ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}

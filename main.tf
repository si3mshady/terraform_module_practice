# root main.tf

module "vpc" {
  source               = "./vpc"
  my_ip                = var.my_ip
  vpc_cidr             = var.vpc_cidr
  aws_region           = var.aws_region
  public_subnet        = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnet       = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnet_az     = var.public_subnet_az
  private_subnet_az    = var.private_subnet_az
  public_subnet_count  = var.public_subnet_count
  private_subnet_count = var.private_subnet_count

}

module "alb" {
  source             = "./alb"
  vpc_id             = module.vpc.elliott_vpc_id
  alb_public_subnets = module.vpc.vpc_public_subnets
  alb_public_sg      = module.vpc.elliott_public_sg
}

module "ecs" {
  source             = "./ecs"
  vpc_id             = module.vpc.elliott_vpc_id
  alb_public_subnets = module.vpc.vpc_public_subnets
  alb_public_sg      = module.vpc.elliott_public_sg
  target_group       = module.alb.alb_target_group_id
  aws_lb_id          = module.alb.aws_lb_id

}

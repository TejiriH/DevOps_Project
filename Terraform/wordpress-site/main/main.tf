provider "aws" {
  region = "eu-north-1"
}

# VPC Module
module "vpc" {
  source = "../module/vpc"
  vpc_cidr_block = "145.255.0.0/20"
  vpc_id    = module.vpc.vpc_id
  public_subnet_cidrs = ["145.255.0.0/27", "145.255.0.32/27"]
  private_subnet_cidrs = ["145.255.0.64/27", "145.255.0.96/27", "145.255.0.128/27", "145.255.0.160/27"]
  public_subnet_ids   = module.vpc.public_subnet_ids
  private_subnet_ids  = module.vpc.private_subnet_ids
}

module "database" {
  source = "../module/database"

  private_subnet_ids  = module.vpc.private_subnet_ids
  security_group_id   = module.vpc.private_security_group_id
  database_user       = module.aws_secret.db_username
  database_pwd        = module.aws_secret.db_password
  database_name       = var.database_name
}

module "efs" {
  source            = "../module/efs"

  first_3_subnets         = module.vpc.first_3_distinct_subnets  # Pass private subnets for mount targets 
  private_security_id     = module.vpc.private_security_group_id  # Pass EFS security group
}

module "loadbalancer" {
  source            = "../module/loadbalancer"
  first_3_subnets    = module.vpc.first_3_distinct_subnets
  db_host             = module.database.db_endpoint
  database_user       = module.aws_secret.db_username
  database_pwd        = module.aws_secret.db_password
  database_name       = var.database_name
  private_security_id = module.vpc.private_security_group_id  # Pass EFS security group
  efs_mount_command   = module.efs.efs_mount_command
  efs_id              = module.efs.efs_id
  vpc_id              = module.vpc.vpc_id
  public_security_id  = module.vpc.public_security_group_id
  public_subnet_ids   = module.vpc.public_subnet_ids
}

module "autoscalar" {
  source            = "../module/autoscalar"
  first_3_subnets         = module.vpc.first_3_distinct_subnets  # Pass private subnets for mount targets 
  private_security_id     = module.vpc.private_security_group_id  # Pass EFS security group
  efs_mount_command       = module.efs.efs_mount_command
  efs_id                  = module.efs.efs_id
  db_host                 = module.database.db_endpoint
  database_user           = module.aws_secret.db_username
  database_pwd            = module.aws_secret.db_password
  database_name           = var.database_name
  target_group_arn        = module.loadbalancer.wordpress_target_group_arn
}

 module "route53" {
  source            = "../module/route53"

  domain_name       = var.domain_name  
  subdomain         = var.subdomain 
  loadbalancer_dns  = module.loadbalancer.wordpress_lb_dns
}

module "aws_secret" {
  source             = "../module/aws_secret"
}
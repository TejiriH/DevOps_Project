output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "public_route_table_id" {
  value = module.vpc.public_route_table_id
}

output "private_route_table_ids" {
  value = module.vpc.private_route_table_ids
}

output "private_security_group_id" {
  value = module.vpc.private_security_group_id
}

output "public_security_group_id" {
  value = module.vpc.public_security_group_id
}

output "first_3_distinct_subnets" {
  value = module.vpc.first_3_distinct_subnets
}

output "db_endpoint" {
  value = module.database.db_endpoint
}

output "db_port" {
  value = module.database.db_port
}

output "private_subnet_azs" {
  value = module.vpc.private_subnet_azs
}

output "nfs_mount_command" {
  value       = module.efs.efs_mount_command
  description = "The complete command to mount the EFS file system."
}

output "wordpress_target_group_arn" {
  value = module.loadbalancer.wordpress_target_group_arn
}

output "wordpress_lb_dns" {
  value = module.loadbalancer.wordpress_lb_dns
  description = "The ARN of the WordPress Target Group"
}

output "db_username" {
  value       = module.aws_secret.db_username
  description = "The database username"
  sensitive   = true
}

output "db_password" {
  value       = module.aws_secret.db_password
  description = "The database password"
  sensitive   = true
}
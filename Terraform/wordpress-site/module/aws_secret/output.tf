output "db_username" {
  value       = data.aws_ssm_parameter.db_username.value
  description = "The database username"
  sensitive   = true
}

output "db_password" {
  value       = data.aws_ssm_parameter.db_password.value
  description = "The database password"
  sensitive   = true
}

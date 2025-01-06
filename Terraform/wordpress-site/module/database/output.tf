output "db_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "db_port" {
  value = aws_db_instance.mysql.port
}

output "web_instance_ids" {
  value       = aws_instance.wordpress_instance.id
  description = "IDs of the web server instances."
}

output "wordpress_target_group_arn" {
  value = aws_lb_target_group.wordpress_target_group.arn
  description = "The ARN of the WordPress Target Group"
}

output "wordpress_lb_dns" {
  value = aws_lb.wordpress_lb.dns_name
  description = "The ARN of the WordPress Target Group"
}

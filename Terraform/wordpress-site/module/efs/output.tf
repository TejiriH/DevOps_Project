output "efs_mount_command" {
  value = aws_efs_file_system.example.dns_name
  description = "The complete NFS mount command for the EFS."
}

output "efs_id" {
  value = aws_efs_file_system.example.id
}



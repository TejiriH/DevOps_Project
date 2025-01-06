# Create the EFS file system
resource "aws_efs_file_system" "example" {
  creation_token = "wordpress-efs"
  performance_mode = "generalPurpose"
}

# Create mount targets for EFS in the subnets
resource "aws_efs_mount_target" "example" {
  count = length(var.first_3_subnets)

  file_system_id = aws_efs_file_system.example.id
  subnet_id      = var.first_3_subnets[count.index]
  security_groups = [var.private_security_id]  # Replace with your security group ID
}












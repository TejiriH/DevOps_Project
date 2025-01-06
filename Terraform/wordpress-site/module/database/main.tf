# RDS MySQL Instance (Free Tier)
resource "aws_db_instance" "mysql" {
  allocated_storage    = 20                     # Free tier allows up to 20 GB
  max_allocated_storage = 20                    # Set the maximum storage to avoid exceeding free tier
  engine               = "mysql"
  engine_version       = "8.0"                  # Use a free tier-supported MySQL version
  instance_class       = "db.t3.micro"          # Free tier instance class            # Database name
  username             = var.database_user                # Master username
  password             = var.database_pwd           # Master password
  parameter_group_name = "default.mysql8.0"     # Use default MySQL parameter group
  db_subnet_group_name = aws_db_subnet_group.mysql.name # Subnet group for private subnets
  vpc_security_group_ids = [var.security_group_id] # Security group

  skip_final_snapshot = true                    # Do not create a final snapshot (free tier optimization)

  tags = {
    Name = var.database_name
  }
}

# Subnet Group for RDS
resource "aws_db_subnet_group" "mysql" {
  name       = "mysql-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "MySQL-Subnet-Group"
  }
}




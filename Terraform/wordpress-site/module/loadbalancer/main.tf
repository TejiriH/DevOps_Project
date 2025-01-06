#locals {
#  db_endpoint_host = split(":", var.db_host)[0]
#}

resource "aws_instance" "wordpress_instance" {
  ami                       = "ami-0feeaea28736b320d"  # Amazon Linux 2 AMI
  instance_type             = "t3.micro"
  subnet_id = element(var.first_3_subnets, 0)
  associate_public_ip_address = false
  vpc_security_group_ids = [var.private_security_id]
  key_name                  = "Tej-ec2"

  # Use templatefile to inject the variables into userdata
  user_data = templatefile("${path.module}/userdata.sh", {
    db_name           = var.database_name,
    db_user           = var.database_user,
    db_password       = var.database_pwd,
    db_host           = split(":", var.db_host)[0], 
    efs_id            = var.efs_id,
    efs_mount_command = var.efs_mount_command
  })

  tags = {
    Name = "WordPress-Web-Server"
  }
}

# Second EC2 instance in the second private subnet
resource "aws_instance" "wordpress_instance_2" {
  ami                       = "ami-0feeaea28736b320d"  # Amazon Linux 2 AMI
  instance_type             = "t3.micro"
  subnet_id                 = element(var.first_3_subnets, 1) # Second private subnet
  associate_public_ip_address = false
  vpc_security_group_ids    = [var.private_security_id]
  key_name                  = "Tej-ec2"

  # Use templatefile to inject the variables into userdata
  user_data = templatefile("${path.module}/userdata.sh", {
    db_name           = var.database_name,
    db_user           = var.database_user,
    db_password       = var.database_pwd,
    db_host           = split(":", var.db_host)[0], 
    efs_id            = var.efs_id,
    efs_mount_command = var.efs_mount_command
  })

  tags = {
    Name = "WordPress-Web-Server-2"
  }
}

# Target Group for WordPress Instances
resource "aws_lb_target_group" "wordpress_target_group" {
  name        = "wordpress-tg"
  port        = 80                      # Port the target group listens on
  protocol    = "HTTP"                  # Protocol for the target group
  vpc_id      = var.vpc_id              # VPC where the target group will be created
  target_type = "instance"              # Register targets by instance ID

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"         # Expect a 200 OK response
  }

  tags = {
    Name = "WordPress-Target-Group"
  }
}

# Attach First Instance to the Target Group
resource "aws_lb_target_group_attachment" "wordpress_instance_1_attachment" {
  target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  target_id        = aws_instance.wordpress_instance.id
  port             = 80
}

# Attach Second Instance to the Target Group
resource "aws_lb_target_group_attachment" "wordpress_instance_2_attachment" {
  target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  target_id        = aws_instance.wordpress_instance_2.id
  port             = 80
}

resource "aws_lb" "wordpress_lb" {
  name               = "wordpress-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.public_security_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "WordPress-Load-Balancer"
  }
}

resource "aws_lb_listener" "wordpress_listener" {
  load_balancer_arn = aws_lb.wordpress_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress_target_group.arn
  }
}

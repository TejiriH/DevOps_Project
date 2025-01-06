# Launch Template for Auto Scaling
resource "aws_launch_template" "wordpress_launch_template" {
  name_prefix          = "wordpress-template"
  image_id             = "ami-0feeaea28736b320d"  # Amazon Linux 2 AMI
  instance_type        = "t3.micro"
  key_name             = "Tej-ec2"

   # Configure the network interface
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.private_security_id]
  }

  # User data to initialize WordPress instances
  user_data = base64encode(templatefile("${path.module}/userdata.sh", {
    db_name           = var.database_name,
    db_user           = var.database_user,
    db_password       = var.database_pwd,
    db_host           = split(":", var.db_host)[0],
    efs_id            = var.efs_id,
    efs_mount_command = var.efs_mount_command
  }))

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WordPress-ASG-Instance"
    }
  }

  tags = {
    Environment = "Production"
    Application = "WordPress"
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "wordpress_asg" {
  launch_template {
    id      = aws_launch_template.wordpress_launch_template.id
    version = "$Latest"
  }

  min_size            = 2
  max_size            = 4
  desired_capacity    = 2
  vpc_zone_identifier = var.first_3_subnets # Attach to private subnets

  # Target Group for Load Balancer
  target_group_arns = [var.target_group_arn]

  health_check_type         = "EC2"
  health_check_grace_period = 300

  # Tags block
  tag {
    key                 = "Name"
    value               = "WordPress-ASG"
    propagate_at_launch = true
  }
}

# Scaling Policies
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "scale-up-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "scale-down-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = aws_autoscaling_group.wordpress_asg.name
}

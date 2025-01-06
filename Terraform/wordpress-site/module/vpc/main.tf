resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "wordpress-vpc"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id = var.vpc_id
  cidr_block = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  tags = {
    Name = "Public-Subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  
  vpc_id = var.vpc_id
  cidr_block = var.private_subnet_cidrs[count.index]
  map_public_ip_on_launch = false

  # Use the modulo operator to cycle through the availability zones
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "Private-Subnet-${count.index + 1}"
  }
}


resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_main_route_table_association" "main_public" {
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table" "private" {
  count = 2
  vpc_id = var.vpc_id
  tags = {
    Name = "Private-Route-Table-${count.index + 1}"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_ids)
  route_table_id = aws_route_table.public.id
  subnet_id = var.public_subnet_ids[count.index]
}

resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_ids)
  route_table_id = aws_route_table.private[count.index % 2].id
  subnet_id = var.private_subnet_ids[count.index]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "wordpress-igw"
  }
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = 2
  tags = {
    Name = "NAT-EIP-${count.index + 1}"
  }
}

# NAT Gateways
resource "aws_nat_gateway" "nat" {
  count       = 2
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "NAT-Gateway-${count.index + 1}"
  }
}

# Route for Internet Access
resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

# Routes for Private Subnets via NAT Gateways
resource "aws_route" "private" {
  count                = 2
  route_table_id       = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id       = aws_nat_gateway.nat[count.index].id
}

# Security Group for Public Instances (e.g., Load Balancer)
resource "aws_security_group" "public" {
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow HTTP traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow HTTPS traffic"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "Allow SSH traffic for management"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # Replace with your IP address range
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Public-SG"
  }
}

# Security Group for Private Instances (e.g., Web Servers, Databases)
resource "aws_security_group" "private" {
  vpc_id = aws_vpc.main.id

  ingress {
    description      = "Allow HTTP traffic from Load Balancer"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.public.id] # Allow traffic from the public SG
  }

  ingress {
    description      = "Allow database traffic"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block] # Adjust based on your VPC CIDR
  }

    ingress {
    description      = "Allow EFS traffic"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block] # Adjust based on your VPC CIDR
  }

      ingress {
    description      = "Allow ssh traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_block] # Adjust based on your VPC CIDR
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Private-SG"
  }
}

# Network ACL for Public Subnets
resource "aws_network_acl" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Public-NACL"
  }
}

# Public NACL Rules
resource "aws_network_acl_rule" "public_inbound_http" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "public_inbound_https" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

resource "aws_network_acl_rule" "public_inbound_ssh" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 105
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

resource "aws_network_acl_rule" "public_inbound_ephemeral" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 108
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0" # VPC CIDR range
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "public_outbound_all" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Network ACL for Private Subnets
resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Private-NACL"
  }
}

# Private NACL Rules
resource "aws_network_acl_rule" "private_inbound_http" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr_block # VPC CIDR range
  from_port      = 80
  to_port        = 80
}

resource "aws_network_acl_rule" "private_inbound_efs" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 105
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr_block # VPC CIDR range
  from_port      = 2049
  to_port        = 2049
}

# Private NACL Rules
resource "aws_network_acl_rule" "private_inbound_ephemeral" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 108
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr_block # VPC CIDR range
  from_port      = 1024
  to_port        = 65535
}

resource "aws_network_acl_rule" "private_inbound_db" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 110
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr_block # VPC CIDR range
  from_port      = 3306
  to_port        = 3306
}

resource "aws_network_acl_rule" "private_inbound_ssh" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 125
  egress         = false
  protocol       = "tcp"
  rule_action    = "allow"
  cidr_block     = var.vpc_cidr_block # VPC CIDR range
  from_port      = 22
  to_port        = 22
}

# Inbound Rule: Allow all traffic
resource "aws_network_acl_rule" "allow_all_inbound" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 140
  egress         = false
  protocol       = "-1"           # "-1" means all protocols
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"    # Allow from any IP
  from_port      = 0              # All ports
  to_port        = 0              # All ports
}

resource "aws_network_acl_rule" "private_outbound_all" {
  network_acl_id = aws_network_acl.private.id
  rule_number    = 120
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
}

# Associate NACLs with Subnets
resource "aws_network_acl_association" "public" {
  count = length(aws_subnet.public)
  subnet_id        = aws_subnet.public[count.index].id
  network_acl_id   = aws_network_acl.public.id
}

resource "aws_network_acl_association" "private" {
  count = length(aws_subnet.private)
  subnet_id        = aws_subnet.private[count.index].id
  network_acl_id   = aws_network_acl.private.id
}



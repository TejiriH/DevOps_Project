output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_route_table_id" {
  value = aws_route_table.public.id
}

output "private_route_table_ids" {
  value = aws_route_table.private[*].id
}

output "private_security_group_id" {
  value = aws_security_group.private.id
}

output "public_security_group_id" {
  value = aws_security_group.public.id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}

output "private_subnet_azs" {
  value = aws_subnet.private[*].availability_zone
}

output "first_3_distinct_subnets" {
  value = [
    for idx, subnet in aws_subnet.private :
    subnet.id if idx < 3
  ]
}


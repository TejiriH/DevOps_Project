# Create a Route 53 Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Create a CNAME record pointing to the load balancer DNS
resource "aws_route53_record" "cname" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${var.domain_name}" # Combine subdomain and domain
  type    = "CNAME"
  ttl     = 300 # Time to live in seconds
  records = [var.loadbalancer_dns]

  # Explicit dependency (optional but ensures proper ordering)
  depends_on = [aws_route53_zone.main]
}
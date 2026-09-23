output "id" {
  description = "ID of the VPC."
  value       = aws_vpc.this.id
}

output "cidr_block" {
  description = "IPv4 CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}

output "subnet_ids" {
  description = "Subnet IDs keyed by Availability Zone."
  value       = { for availability_zone, subnet in aws_subnet.this : availability_zone => subnet.id }
}

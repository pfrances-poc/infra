output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.default.id
}

output "subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

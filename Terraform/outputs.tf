output "public_ec2_instance_ip" {
  value       = aws_instance.public_ec2.public_ip
  description = "The pulblic IP of the EC2"
}

output "private_ec2_instance_id" {
  value       = aws_instance.private_ec2.id
  description = "The ID of the EC2"
}

# Output cho VPC
output "vpc_id" {
  value       = aws_vpc.main_vpc.id
  description = "The ID of the VPC"
}

output "vpc_cidr" {
  value       = aws_vpc.main_vpc.cidr_block
  description = "The CIDR block of the VPC"
}

output "vpc_tags" {
  value       = aws_vpc.main_vpc.tags
  description = "The tags associated with the VPC"
}

# Output cho Public Subnet
output "public_subnet_id" {
  value       = aws_subnet.public_subnet.id
  description = "The ID of the Public Subnet"
}

output "public_subnet_cidr" {
  value       = aws_subnet.public_subnet.cidr_block
  description = "The CIDR block of the Public Subnet"
}

output "public_subnet_tags" {
  value       = aws_subnet.public_subnet.tags
  description = "The tags associated with the Public Subnet"
}

# Output cho Private Subnet
output "private_subnet_id" {
  value       = aws_subnet.private_subnet.id
  description = "The ID of the Private Subnet"
}

output "private_subnet_cidr" {
  value       = aws_subnet.private_subnet.cidr_block
  description = "The CIDR block of the Private Subnet"
}

output "private_subnet_tags" {
  value       = aws_subnet.private_subnet.tags
  description = "The tags associated with the Private Subnet"
}

# Output cho Internet Gateway
output "internet_gateway_id" {
  value       = aws_internet_gateway.igw.id
  description = "The ID of the Internet Gateway"
}

# Output cho NAT Gateway
output "nat_gateway_id" {
  value       = aws_nat_gateway.my_nat_gateway.id
  description = "The ID of the NAT Gateway"
}

# Output cho Route Tables
output "public_route_table_id" {
  value       = aws_route_table.public_route_table.id
  description = "The ID of the Public Route Table"
}

output "private_route_table_id" {
  value       = aws_route_table.private_route_table.id
  description = "The ID of the Private Route Table"
}
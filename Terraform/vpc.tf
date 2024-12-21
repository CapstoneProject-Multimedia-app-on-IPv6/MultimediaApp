# Tạo VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}

# Tạo Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "my_igw"
  }
}
# Tạo Elastic IP cho NAT Gateway
resource "aws_eip" "my_nat_eip" {
  domain = "vpc" # Thay thế vpc = true bằng domain = "vpc"
}

# Tạo NAT Gateway
resource "aws_nat_gateway" "my_nat_gateway" {
  allocation_id = aws_eip.my_nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "my_nat_gateway"
  }
}

# Tạo Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public_subnet"
  }
}

# Tạo Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = false

  tags = {
    Name = "private_subnet"
  }
}

# Tạo Route Table cho Public Subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    # Định tuyến lưu lượng Internet thông qua Internet Gateway
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Tạo Route Table cho Private Subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    # Định tuyến lưu lượng Internet thông qua NAT Gateway
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_nat_gateway.id
  }

  tags = {
    Name = "private_route_table"
  }
}





# Gán Route Table cho Public Subnet
resource "aws_route_table_association" "public_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Gán Route Table cho Private Subnet
resource "aws_route_table_association" "private_route_table_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}


# Tạo Public EC2 Instance
resource "aws_instance" "public_ec2" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.public_ec2_sg.id]
  key_name        = "demo"
  tags = {
    Name = "public_ec2_instance"
  }
}

# Tạo Private EC2 Instance
resource "aws_instance" "private_ec2" {
  ami             = var.ami_id
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.private_ec2_sg.id]
  key_name        = "demo"
  tags = {
    Name = "private_ec2_instance"
  }
}



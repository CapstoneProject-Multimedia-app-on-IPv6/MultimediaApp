# Tạo Security Group cho Public EC2 instance
resource "aws_security_group" "public_ec2_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["14.186.66.32/32"] #Chỉ cho phép public ip cụ thể truy cập vào máy public ec2
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "public_ec2_sg"
  }
}

# Tạo Security Group cho Private EC2 instance
resource "aws_security_group" "private_ec2_sg" {
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${aws_instance.public_ec2.private_ip}/32"] #chỉ cho public ec2 truy cập vào 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "private_ec2_sg"
  }
  depends_on = [aws_instance.public_ec2] # Đảm bảo Public EC2 được tạo trước khi gán IP vào Security Group
}

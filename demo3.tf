provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "ec2_demo_tf" {
  ami           = "ami-0607784b46cbe5816"
  instance_type = "t2.large"
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "Created_By_Terraform"
    App_Name = "Terraform"
  }
  user_data = <<-EOF
              #!/bin/bash
                yum update -y
                yum install -y httpd
                systemctl start httpd.service
                systemctl enable httpd.service
                echo "Welcome to Terraform Demo!!!, I am $(hostname -f) hosted by Terraform" > /var/www/html/index.html
              EOF
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0f6e702e601c2801a"

  ingress {
    description      = "SSH from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}
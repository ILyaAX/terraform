terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "nginx" {
  ami = "ami-09e67e426f25ce0d7"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx.id]
  user_data = <<-EOL
  #!/bin/bash
  apt update
  apt install -y nginx
  git clone https://github.com/ILyaAX/terraform.git
  rm -rf /var/www/html/*
  cp terraform/html/* /var/www/html/
  EOL
  
  tags = {
    Name = "nginx-server"
  }
}

resource "aws_security_group" "nginx" {
  name        = "nginx"
  description = "http"

  ingress {
      description      = "http"
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
    }

  tags = {
    Name = "nginx"
  }
}

output "instance_public_ip" {
  description = "IP address nginx"
  value       = aws_instance.nginx.public_ip
}
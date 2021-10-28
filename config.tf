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

resource "aws_instance" {
  ami = "ami-00d1ab6b335f217cf"
  instance_type = "t2.micro"
  user_data = <<-EOL
  #!/bin/bash
  apt update
  apt install -y nginx
  git clone https://github.com/ILyaAX/terraform.git
  rm -rf /var/www/html/*
  cp /teraform/html/* /var/www/html/*
  EOL
  
  tags = {
    Name = "nginx-server"
  }
}

resource "aws_security_group" "instance" {

  name = var.security_nginx

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
    }
}
variable "security_nginx" {
  description = "The name of the security group"
  type        = string
  default     = "nginx-instance"
}

output "instance_public_ip" {
  description = "IP address nginx"
  value       = aws_instance.app_server.public_ip
}
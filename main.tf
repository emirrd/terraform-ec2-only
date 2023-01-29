terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    bucket   = "emrah-aws-terraform-state-bucket"
    key      = "ec2-only/terraform.tfstate"
    region   = "eu-central-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

resource "aws_instance" "test-instance" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.aws-ec2-sg.id]

  user_data = file("aws-user-data.sh")

  tags = {
    "Name" = "FirstEC2withTerraform"
  }
}

# Define the security group for the EC2 Instance
resource "aws_security_group" "aws-ec2-sg" {
  name        = "ec2-sg"
  description = "Allow incoming connections"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming SSH connections"
  }  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }  
  tags = {
    Name = "ec2-sg"
  }
}
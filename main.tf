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

resource "aws_instance" "test-instance" {
  ami           = var.ami
  instance_type = var.instance_type

}
# terraform confiuration blck
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

provider "aws" {
  profile = "sukkwono"
  region  = "us-west-2"
}

resource "aws_instance" "my_server" {
  ami           = "ami-0e5b6b6a9f3db6db8"
  instance_type = "t2.micro"
  lifecycle {
    prevent_destroy = false
  }
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

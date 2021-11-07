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

resource "aws_s3_bucket" "bucket" {
  bucket = "48668435484-sk-bucket"
  acl    = "private"

  depends_on = [
    aws_instance.my_server
  ]
}

resource "aws_instance" "my_server" {
  ami           = "ami-0e5b6b6a9f3db6db8"
  instance_type = "t2.micro"
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

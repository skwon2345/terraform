# terraform confiuration blck
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

variable "instance_type" {
  type = string
  description = "The size of EC2 instance."
  sensitive = true
  
  validation {
    condition = can(regex("^t2.", var.instance_type))
    error_message = "The instance must be t2 instance."
  }
}

provider "aws" {
  profile = "sukkwono"
  region  = "us-west-2"
}

resource "aws_instance" "my_server" {
  ami           = "ami-0e5b6b6a9f3db6db8"
  instance_type = var.instance_type
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

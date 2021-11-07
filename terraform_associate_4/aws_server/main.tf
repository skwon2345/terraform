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

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "my_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
}

output "public_ip" {
  value = aws_instance.my_server.public_ip
}

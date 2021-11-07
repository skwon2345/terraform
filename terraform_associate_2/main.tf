terraform {
#   backend "remote" {
#     organization = "hits-sk"

#     workspaces {
#       name = "provisioners"
#     }
#   }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.64.1"
    }
  }
}

provider "aws" {
  profile = "sukkwono"
  region = "us-west-2"
}

data "aws_vpc" "main" {
    id = "vpc-9e96d5e6"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id

  ingress = [
    {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    },
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["121.189.75.7/32"] # /32 meaning use a single address
      ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  egress = [
    {
      description      = "outgoing traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCoav6OYzY6TvRSM8MkJ5/u4yD3higQ+wpB10eGaH5voqQxD266yNUil4iasF5DZ0l5vudktGoU7I3vLyADATNPmHnJil7gT6AJaltGDGs9KIw2w2/hxiuDeUfZhVPPj96U/hbHMkvZur2ZVv4vDPs5v729b//HsVEHYpm+sGM9zZzks2k95kRqgOse9j0k5MxwTdcQkPFew7SAxS5QGogcF4H10zTP7Syoi2c4Fk2fEG2YO1VdsfR+DKEjbqME0yCxAcYVkEQ5ysUg8EPiVGnHTO+Gn4/eP5X/3tTOQPxFnbrcxiRT+CkV/C2gSOkJggHonMahICzvSN6N2ya4XFx1NVrObKhYWoNVRtlY40GK9PUA56pjNPQ2EFjjFio0atZBI2vFXA7YNuSTzN4fglWzYr5ccyVL++Gl5L1Pj7f7TA5kbOZwcyOdS1LwW3oNEOl7Pvj08DOLFTYcrYvLYZz8eVOJ5QDVANP/5PQqM/EVVKHlTVdTkBdC+WiHhMrlcGE= onsukkwon@ONui-MacBookPro-2.local"
}

data "template_file" "user_data" {
    template = file("./userdata.yaml")
}

resource "aws_instance" "my_server" {
  ami           = "ami-0e5b6b6a9f3db6db8"
  instance_type = "t2.micro"
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  user_data = data.template_file.user_data.rendered
  provisioner "remote-exec" {
    inline = [
      "echo ${self.private_ip} >> /home/ec2-user/private_ips.txt",
    ]
    connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = "${self.public_ip}"
        private_key = "${file("~/.ssh/terraform")}"
    }
  }
  provisioner "file" {
    content = "mars"
    destination = "/home/ec2-user/barsoon.txt"
    connection {
        type     = "ssh"
        user     = "ec2-user"
        host     = "${self.public_ip}"
        private_key = "${file("~/.ssh/terraform")}"
    }
  }
  tags = {
    Name = "MyServer"
  }
}

output "public_ip" {
    value = aws_instance.my_server.public_ip
}
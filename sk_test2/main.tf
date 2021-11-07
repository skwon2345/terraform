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


resource "aws_iam_user" "hits_users" {
  name = "sk"

  tags = {
    team = "dev"
    access_level = "high"
  }
}

resource "aws_iam_group" "group" {
  name = "hits_dev_team"
}

resource "aws_iam_group_membership" "hits_iam_group" {
  name = "hits_iam_group"

  users = [aws_iam_user.hits_users.name]
  group = aws_iam_group.group.name
}

resource "aws_iam_user_login_profile" "u" {
  user    = "${aws_iam_user.hits_users.name}"
  pgp_key = "keybase:sukkwono"
}

output "password" {
  value = "${aws_iam_user_login_profile.u.encrypted_password}"
}

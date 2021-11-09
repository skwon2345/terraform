# terraform confiuration blck
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.63.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  profile = "sukkwono"
  region  = "us-west-2"
}


resource "aws_iam_user" "hits_users" {
  for_each = var.users
  name     = each.key

  tags = {
    access_level = each.value.access_level
  }
}

resource "aws_iam_access_key" "hits_access_key" {
  for_each = aws_iam_user.hits_users
  user     = each.value.name
}

resource "aws_iam_group" "group" {
  name = "hits_dev_team"
}

resource "aws_iam_group_membership" "hits_iam_group" {
  name = "hits_iam_group"

  users = [for user in aws_iam_user.hits_users : user.name]
  group = aws_iam_group.group.name
}

resource "aws_iam_user_login_profile" "u" {
  for_each = aws_iam_user.hits_users
  user     = each.value.name
  pgp_key  = "keybase:sukkwono"
}

output "password" {
  value     = { for user_profile in aws_iam_user_login_profile.u : user_profile.user => user_profile.encrypted_password }
  sensitive = true
}

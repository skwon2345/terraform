terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "hits-sk"

    workspaces {
      name = "getting-started"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.63.0"
    }
  }
}

locals {
  project_name = "Sukkwon"
}

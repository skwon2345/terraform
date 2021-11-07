provider "aws" {
  profile = "sukkwono"
  region  = "us-west-2"
}

provider "aws" {
  profile = "sukkwono"
  region  = "eu-west-1"
  alias   = "eu"
}
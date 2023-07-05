provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "e54t3h334g"
    key            = "global/s3/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
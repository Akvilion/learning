terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket         = "e54t3h334g"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
}
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "e54t3h334g"
  acl    = "private"

  tags = {
    Environment = "Dev"
    Name        = "learning_devops"
  }
}
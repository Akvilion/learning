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

#################################################################ECR
resource "aws_ecr_repository" "ecr_instance" {
  name                 = "devops_course"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "learningpolicy" {
  repository = aws_ecr_repository.ecr_instance.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 1 day",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 1
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
#################################################################
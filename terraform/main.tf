terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
}

resource "aws_instance" "terraform_instance" {
  count = 1  # створить 1 штуку
  ami           = "ami-053b0d53c279acc90"
  instance_type = "t2.micro"

  tags = {
    Name = "learning"
  }
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install docker
              sudo service docker start
              sudo usermod -a -G docker ubuntu
              EOF
}

resource "aws_ecr_repository" "ecr_instance" {
  name                 = "learning"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "learning2policy" {
  repository = aws_ecr_repository.ecr_instance.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 2 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 2
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}


# terraform init
# terraform plan
# terraform apply

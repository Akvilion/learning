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

# #################################################################
# resource "aws_instance" "learning2" {
#   ami                    = "ami-053b0d53c279acc90"
#   instance_type          = "t2.micro"
#   key_name               = "4820006"
#   vpc_security_group_ids = [aws_security_group.learning2.id]

#   tags = {
#     Name = "two"
#   }
#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install -y docker.io
#     sudo service docker start
#     sudo usermod -a -G docker ubuntu
# EOF
# }

# resource "aws_security_group" "learning2" {
#   name        = "WebServerSecurityGroup2"
#   description = "My first SG2"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_instance" "learning1" {
#   ami                    = "ami-053b0d53c279acc90"
#   instance_type          = "t2.micro"
#   key_name               = "4820006"
#   vpc_security_group_ids = [aws_security_group.learning1.id]

#   tags = {
#     Name = "one"
#   }
#   user_data = <<-EOF
#     #!/bin/bash
#     sudo apt update -y
#     sudo apt install -y docker.io
#     sudo service docker start
#     sudo usermod -a -G docker ubuntu
# EOF
# }

# resource "aws_security_group" "learning1" {
#   name        = "WebServerSecurityGroup1"
#   description = "My first SG1"

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     description = "SSH"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
# #################################################################

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
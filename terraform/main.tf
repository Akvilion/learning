terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.5.0"
    }
  }
  backend "s3" {
    bucket = "433t3g3"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}


provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "learning" {
  ami                    = "ami-053b0d53c279acc90"
  instance_type          = "t2.micro"
  key_name               = "ubuntu"
  vpc_security_group_ids = [aws_security_group.learning.id]

  tags = {
    Name = "learning"
  }
  user_data = <<-EOF
#!/bin/bash
sudo apt update -y
sudo apt install -y docker.io
sudo service docker start
sudo usermod -a -G docker ubuntu
EOF
}

resource "aws_security_group" "learning" {
  name        = "WebServerSecurityGroup"
  description = "My first SG"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecr_repository" "ecr_instance" {
  name                 = "learning"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  lifecycle {
    ignore_changes = all
  }
}

resource "aws_ecr_lifecycle_policy" "learningpolicy" {
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

output "ec2_ip" {
  value       = aws_instance.learning.public_ip
  description = "The public IP of the EC2 instance"
}

# terraform init
# terraform plan
# terraform apply

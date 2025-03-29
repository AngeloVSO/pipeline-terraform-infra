provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "infra_ec2_posinfnet" {
  ami                    = "ami-071226ecf16aa7d96"
  instance_type          = "t2.micro"
  key_name               = "posinfnet-keypair-ssh"
  vpc_security_group_ids = [aws_security_group.default.id]

  tags = {
    Name = "Infra-EC2-PosInfnet"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y docker.io
              systemctl start docker
              systemctl enable docker
              EOF
}

resource "aws_security_group" "default" {
  name        = "security_group_posinfnet"
  description = "Security group for EC2 instance PosInfnet"
  vpc_id      = "vpc-04d8163c122afdd65"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "80"
    to_port     = "80"
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

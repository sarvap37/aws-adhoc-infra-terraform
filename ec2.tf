# main.tf

# Specify the Terraform provider (AWS in this case)
provider "aws" {
  region = var.region  # Specify your desired AWS region
}

# Data source to retrieve the existing VPC by ID
data "aws_vpc" "existing_vpc" {
  id = var.vpc_id  # Replace with your existing VPC ID
}

# Data source to retrieve the existing subnet by ID
data "aws_subnet" "existing_subnet" {
  id = var.subnet_id # Replace with your existing Subnet ID
}

# Create a new EC2 key pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_ed25519.pub")  # Use an existing public key file
}

# Create a security group
resource "aws_security_group" "my_security_group" {
  vpc_id = data.aws_vpc.existing_vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-security-group"
  }
}

# Create an EC2 instance
resource "aws_instance" "my_instance" {
  ami           = var.ami_id  # Replace with your desired AMI ID
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.existing_subnet.id
  security_groups = [aws_security_group.my_security_group.id]
  key_name       = "my-key-pair"  # Replace with your EC2 key pair name

  tags = {
    Name = "stage-instance"
  }
}

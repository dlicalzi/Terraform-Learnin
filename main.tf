terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
  default_tags {
    tags= var.default_tags
  }
}
# Create VPC : CIDR 10.0.0.0/16
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    assign_generated_ipv6_cidr_block = true
    enable_dns_hostnames = true
    enable_dns_support = true 
    tags = {
      "Name" = "dlterra_vpc"
    }
  }

# Public Subnet 10.0.0.0/24
resource "aws_subnet" "public" {
  count = 2
  vpc_id = aws_vpc.main.id
  cidr_block = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  ipv6_cidr_block = cidrsubnet(aws_vpc.main.ipv6_cidr_block, 8, count.index)
  map_public_ip_on_launch = true
}

# Private Subnet 10.0.0.0/24

# public RT

#private RT 

#igw

# Nat
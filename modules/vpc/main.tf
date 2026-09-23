terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> v1.16.2" #he ~> patch version to be greater than but requires the major and minor versions (1.16)
}

resource "aws_vpc" "this" {
  tags = merge(var.tags, {
    Name = var.name
  })

  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

# This creates one subnet per Availability Zone and derives a unique CIDR block for each subnet.
# for_each block converts the Availability Zone list into a map:
# Given: var.availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
# Terraform creates:
# {
# eu-west-2a -> subnet index 0
# eu-west-2b -> subnet index 1
# eu-west-2c -> subnet index 2
# }
resource "aws_subnet" "this" {
  for_each = {
    for index, availability_zone in var.availability_zones : availability_zone => index
  }

  vpc_id                  = aws_vpc.this.id
  availability_zone       = each.key
  cidr_block              = cidrsubnet(var.cidr_block, 8, each.value)
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name = "${var.name}-${each.key}"
  })
}

# Internet Gateway and route-table pattern to the VPC module so the subnet can be public and internet-reachable 
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-igw"
  })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = merge(var.tags, {
    Name = "${var.name}-public-rt"
  })
}

resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.this
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

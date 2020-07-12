data "aws_availability_zones" "available" {}

resource "aws_vpc" "VPC_Neon" {
  cidr_block           = var.vpcCIDRblock
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  instance_tenancy = "default"
tags = {
    Name = "VPC Neon"
}
}

resource "aws_subnet" "Neon_subnet_us_east_2a" {
  vpc_id     = aws_vpc.VPC_Neon.id
  cidr_block = "10.7.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "Neon Subnet us-east-2a"
  }
}

resource "aws_subnet" "Neon_subnet_us_east_2b" {
  vpc_id     = aws_vpc.VPC_Neon.id
  cidr_block = "10.7.11.0/24"
  availability_zone = "us-east-2b"

  tags = {
    Name = "Neon Subnet us-east-2b"
  }
}

resource "aws_subnet" "Neon_subnet_us_east_2c" {
  vpc_id     = aws_vpc.VPC_Neon.id
  cidr_block = "10.7.12.0/24"
  availability_zone = "us-east-2c"

  tags = {
    Name = "Neon Subnet us-east-2c"
  }
}

resource "aws_internet_gateway" "IGW_Neon" {
 vpc_id = aws_vpc.VPC_Neon.id
 tags = {
        Name = "Internet gateway Neon"
}
}

resource "aws_route_table" "Neon_RT" {
 vpc_id = aws_vpc.VPC_Neon.id
 tags = {
        Name = "Neon Route table"
}
}

resource "aws_route" "Neon_internet_access" {
  route_table_id         = aws_route_table.Neon_RT.id
  destination_cidr_block = var.publicdestCIDRblock
  gateway_id             = aws_internet_gateway.IGW_Neon.id
}

resource "aws_route_table_association" "Neon_us_east_2a" {
    subnet_id = aws_subnet.Neon_subnet_us_east_2a.id
    route_table_id = aws_route_table.Neon_RT.id
}

resource "aws_route_table_association" "Neon_us_east_2b" {
    subnet_id = aws_subnet.Neon_subnet_us_east_2b.id
    route_table_id = aws_route_table.Neon_RT.id
}

resource "aws_route_table_association" "Neon_us_east_2c" {
    subnet_id = aws_subnet.Neon_subnet_us_east_2c.id
    route_table_id = aws_route_table.Neon_RT.id
}

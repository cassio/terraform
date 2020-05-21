resource "aws_vpc" "vpc_aula01" {
  cidr_block = "10.0.0.0/16"

  tags = {
	Name = "VPC Aula 01"
	}

}

resource "aws_subnet" "subnet_aula01" {
  vpc_id     = aws_vpc.vpc_aula01.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Subnet Aula 01"
  }
}

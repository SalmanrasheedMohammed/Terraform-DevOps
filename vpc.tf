resource "aws_vpc" "myntra-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myntra"
  }
}

# web subnet

resource "aws_subnet" "myntra-web-sn" {
  vpc_id     = aws_vpc.myntra-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Myntra-web-subnet"
  }
}

# Database subnet

resource "aws_subnet" "myntra-db-sn" {
  vpc_id     = aws_vpc.myntra-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = "true"

  tags = {
    Name = "Myntra-database-subnet"
  }
}
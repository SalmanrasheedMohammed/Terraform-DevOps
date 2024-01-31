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

# Internet gateway

resource "aws_internet_gateway" "myntra-igw" {
  vpc_id = aws_vpc.myntra-vpc.id

  tags = {
    Name = "myntra-internet-gateway"
  }
}

# web route table

resource "aws_route_table" "myntra-web-rt" {
  vpc_id = aws_vpc.myntra-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myntra-igw.id
  }

  tags = {
    Name = "myntra-web-route-table"
  }
}

# Database route table

resource "aws_route_table" "myntra-database-rt" {
  vpc_id = aws_vpc.myntra-vpc.id

 tags = {
    Name = "myntra-database-route-table"
  }
}

# Web Route table associtation

resource "aws_route_table_association" "myntra-web-asc" {
  subnet_id      = aws_subnet.myntra-web-sn.id
  route_table_id = aws_route_table.myntra-web-rt.id
}  

# Database Route table associtation
resource "aws_route_table_association" "myntra-database-asc" {
  subnet_id      = aws_subnet.myntra-db-sn.id
  route_table_id = aws_route_table.myntra-database-rt.id
}

# web NACL

resource "aws_network_acl" "myntra-web-nacl" {
  vpc_id = aws_vpc.myntra-vpc.id
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "myntra-web-nacl"
  }
}

# Databse NACL

resource "aws_network_acl" "myntra-db-nacl" {
  vpc_id = aws_vpc.myntra-vpc.id
  
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 65535
  }

  tags = {
    Name = "myntra-db-nacl"
  }
}

# Web NACL association
resource "aws_network_acl_association" "myntra-web-nacl-asc" {
  network_acl_id = aws_network_acl.myntra-web-nacl.id
  subnet_id      = aws_subnet.myntra-web-sn.id
}

# Databse NACL association
resource "aws_network_acl_association" "myntra-db-nacl-asc" {
  network_acl_id = aws_network_acl.myntra-db-nacl.id
  subnet_id      = aws_subnet.myntra-db-sn.id
}

# web security group
resource "aws_security_group" "myntra-web-nacl-sg" {
  name        = "myntra-web-traffic"
  description = "Allow SSH - HTTP inbound traffic"
  vpc_id      = aws_vpc.myntra-vpc.id

  ingress {
    description = "SSH from WWW"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from WWW"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myntra-web-sg"
  }
}

# Databse security group
resource "aws_security_group" "myntra-db-nacl-sg" {
  name        = "myntra-db-traffic"
  description = "Allow SSH - Postgres inbound traffic"
  vpc_id      = aws_vpc.myntra-vpc.id

  ingress {
    description = "SSH from WWW"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "Postgres from WWW"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "myntra-db-sg"
  }
}
}
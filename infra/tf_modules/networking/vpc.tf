# VPC Network Setup
resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"

  tags = {
    Name = "${var.project_name}-${var.environment}-vpc"
  }
}

/*----------------------------------------------------------------------------------------------------------------------
  Public Subnet
----------------------------------------------------------------------------------------------------------------------*/

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.0.0/24"
  availability_zone = "ap-southeast-2a"

  tags = {
    Name = "${var.project_name}-${var.environment}-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "192.168.1.0/24"
  availability_zone = "ap-southeast-2b"

  tags = {
    Name = "${var.project_name}-${var.environment}-private-subnet"
  }
}

# Subnet Ids
data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main_vpc.id]
  }
  depends_on = [aws_subnet.public_subnet]
}


# Route table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-route-table"
  }
}

# Route table association
resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.main.id
}

# create a security group for VPC link
resource "aws_security_group" "main" {
  name        = "VPC_Link_SG"
  description = "Allow hhtp"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
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
    Name = "${var.project_name}-${var.environment}-sg"
  }
}
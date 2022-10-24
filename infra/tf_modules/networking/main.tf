/*----------------------------------------------------------------------------------------------------------------------
  Internet Gateway
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "${var.project_name}-${var.environment}-igw"
  }
}

/*----------------------------------------------------------------------------------------------------------------------
  Netgateway
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_eip" "nat" {
  vpc = true

}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet.id
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name = "${var.project_name}-${var.environment}-nat-gw"
  }
}


# Route for Private Subnet with Nat gateway
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-private-route-for-db"
  }
}

resource "aws_route_table_association" "nat" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id
}

/*----------------------------------------------------------------------------------------------------------------------
  PC Link
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_apigatewayv2_vpc_link" "main" {
  name               = "${var.project_name}-${var.environment}"
  subnet_ids         = data.aws_subnets.main.ids
  security_group_ids = [aws_security_group.main.id]
}

# Fargate Namespace
/*----------------------------------------------------------------------------------------------------------------------
  Fargate Namespace
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_service_discovery_private_dns_namespace" "main" {
  name        = "${var.project_name}-${var.environment}"
  description = "Private DNS Namespace"
  vpc         = aws_vpc.main_vpc.id
}


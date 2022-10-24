output vpc_id {
  value = aws_vpc.main_vpc.id
  description = "VPC id"
}


output private_subnet_id {
  value = aws_subnet.private_subnet.id
  description = "Private Subnet id for Fargate Cluster"
}

output fargate_namespace_id {
  value = aws_service_discovery_private_dns_namespace.main.id
  description = "Namespace id"
}

output vpc_link_id {
  value = aws_apigatewayv2_vpc_link.main.id
  description = "VPC Link Id"
}

output vpc_link_sg {
  value = aws_security_group.main.id
  description = "Security Group for VPC Link"
}

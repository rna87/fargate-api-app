/*----------------------------------------------------------------------------------------------------------------------
  Cloudmap Service
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_service_discovery_service" "main" {
  name = "${var.project_name}-${var.environment}"

  dns_config {
    namespace_id = var.fargate_namespace_id

    dns_records {
      ttl  = 60
      type = "SRV"
    }

    routing_policy = "MULTIVALUE"
  }
}

/*----------------------------------------------------------------------------------------------------------------------
  API Gateway Integration
----------------------------------------------------------------------------------------------------------------------*/

resource "aws_apigatewayv2_api" "main" {
  name          = "${var.project_name}-${var.environment}"
  protocol_type = "HTTP"
  cors_configuration {
    allow_origins = ["*"]
    allow_methods = ["*"]
    allow_headers = ["*"]
  }
}

# API Gateway Integration
resource "aws_apigatewayv2_integration" "main" {
  api_id = aws_apigatewayv2_api.main.id
  integration_type = "HTTP_PROXY"
  connection_id = var.network_stack_vpclink_id
  connection_type = "VPC_LINK"
  integration_method = "ANY"
  integration_uri = aws_service_discovery_service.main.arn
  payload_format_version = "1.0"
}

resource "aws_apigatewayv2_route" "default_route" {
  api_id = aws_apigatewayv2_api.main.id
  route_key = "ANY /{proxy+}"
  target = "integrations/${aws_apigatewayv2_integration.main.id}"
}

# API Gateway Default Stage
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.main.id
  name   = "$default"
  auto_deploy = true

  lifecycle {
    create_before_destroy = true
  }
}
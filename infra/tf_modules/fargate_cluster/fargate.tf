/*----------------------------------------------------------------------------------------------------------------------
  ECS CLuster for Fargate
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_ecs_cluster" "main" {
  name = "${var.project_name}-${var.environment}-cluster"
  tags = var.tags
}

/*----------------------------------------------------------------------------------------------------------------------
  Fargate Service
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_ecs_service" "main" {

  name            = "${var.project_name}-${var.environment}"
  cluster         = aws_ecs_cluster.main.name
  task_definition = "${aws_ecs_task_definition.app.family}:${max(aws_ecs_task_definition.app.revision, data.aws_ecs_task_definition.app.revision)}"
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_service.id]
    subnets          = var.private_subnet_ids
    assign_public_ip = false
  }
  service_registries {
    registry_arn = aws_service_discovery_service.main.arn
    port = "8080"
  }
}

data "aws_ecs_task_definition" "app" {
  task_definition = aws_ecs_task_definition.app.family
  depends_on      = [aws_ecs_task_definition.app]
}

# Fargate Service Security Group- Allowing inbound from VPC Link security group
resource "aws_security_group" "ecs_service" {
  name        = "fargate-task-security-group-${var.environment}"
  description = "security group for fargate tasks"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 8080
    to_port         = 8080
    cidr_blocks = [var.vpc_cidr_block]
  }

  ingress {
    description = "tcp"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [var.vpc_ling_sg]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    description = "Allow all outbound traffic by default"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/*----------------------------------------------------------------------------------------------------------------------
  Task Definition
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_ecs_task_definition" "app" {
  family             = "${var.project_name}-${var.environment}"
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.task_definition_task_role.arn
  network_mode       = "awsvpc"
  requires_compatibilities = [
    "FARGATE"]
  cpu    = "512"
  memory = "1024"
  container_definitions = jsonencode([
    {
      name : var.containter_name,
      image : var.image_uri,
      repositoryCredentials : {
        "credentialsParameter": "${var.image_secret}",
      }, 
      networkMode : "awsvpc",
      logConfiguration : {
        logDriver : "awslogs",
        "options" : {
          "awslogs-group" : aws_cloudwatch_log_group.main.name,
          "awslogs-region" : "ap-southeast-2",
          "awslogs-stream-prefix" : "ecs"
        }
      },
      portMappings : [
        {
          containerPort : var.app_port
          protocol : "tcp",
          hostPort : var.app_port
        }
      ],
      environment : [
        {"name": "ENV", "value": "${var.environment}"},
        {"name": "PORT", "value": "${tostring(var.app_port)}"},
        {"name": "URL", "value": "${aws_apigatewayv2_stage.default.invoke_url}"},
        {"name": "LASTCOMMIT", "value": "fdsafsafsafdasfdsa"}
      ]
    }
  ])
  tags = var.tags
}
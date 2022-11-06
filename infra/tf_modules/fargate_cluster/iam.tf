/*----------------------------------------------------------------------------------------------------------------------
  Role for ECS task Definition
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_iam_role" "task_definition_task_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

/*----------------------------------------------------------------------------------------------------------------------
  Role for ECS Task Execution
----------------------------------------------------------------------------------------------------------------------*/
resource "aws_iam_role" "ecs_task_execution_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


/*----------------------------------------------------------------------------------------------------------------------
  IAM Policy for ECS Task to Publish Logs
----------------------------------------------------------------------------------------------------------------------*/
data "aws_iam_policy_document" "app_policy" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ssm:GetParameters",
      "secretsmanager:GetSecretValue"
    ]
    resources = [var.image_secret]
  }
}

# Assigning ECS Policy to Task Execution Role
resource "aws_iam_role_policy" "app_policy" {
  name   = "${var.project_name}-${var.environment}-ecs-policy"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.app_policy.json
}
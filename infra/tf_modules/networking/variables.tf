variable "aws_region" {}

variable "environment" {}

variable "project_name" {}

variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block range for vpc"
}
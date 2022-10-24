variable "aws_region" {}

variable "environment" {}

variable "project_name" {}

variable "containter_name" {
  type = string
  description = "backend ontainer name"
}

variable "image_uri" {
  type = string
  description = "The container image deployed in ecr"
}

variable "vpc_id" {
  type = string
  description = "VPC id created by the network layer"
}

variable "network_stack_vpclink_id" {
  type = string
  description = "VPC link created by the network layer"
}

variable "vpc_ling_sg" {
  type = string
  description = "VPC link security group created by the network layer"
}

variable "vpc_cidr_block" {
  type = string
  description = "CIDR Block"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "VPC private subnet ids"
}


variable "fargate_namespace_id" {
  type = string
  description = "cloudmap service created by network layer"
}

variable "app_port" {
  type = number
  description = "The container port number"
}

variable "tags" {
  type = map(string)
  description = "Tags to attach to the resources"
  default = {
    "name" = "value"
  }
}
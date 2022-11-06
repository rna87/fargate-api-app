terraform {
  cloud {
    organization = "RNA"

    workspaces {
      name = "production"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4"
    }
  }
}

provider "aws" {
  region = local.config["aws_region"]
}


data "local_file" "config" {
  filename = "./config.yaml"
}

locals {
  config      = yamldecode(data.local_file.config.content)
}


module "networking" {
  source = "../tf_modules/networking"
  aws_region = local.config["aws_region"]
  environment = local.config["environment"]
  project_name = local.config["project_name"]
  vpc_cidr_block = local.config["vpc_cidr_block"]
}

module "fargate_cluster" {
  source = "../tf_modules/fargate_cluster"
  aws_region = local.config["aws_region"]
  environment = local.config["environment"]
  project_name = local.config["project_name"]
  vpc_cidr_block = local.config["vpc_cidr_block"]
  fargate_namespace_id = module.networking.fargate_namespace_id
  containter_name = local.config["containter_name"]
  app_port = local.config["app_port"]
  image_uri = local.config["image_uri"]
  image_secret= local.config["image_secret"]
  last_sha= local.config["last_sha"]

  vpc_id = module.networking.vpc_id
  private_subnet_ids = [ module.networking.private_subnet_id ]
  network_stack_vpclink_id = module.networking.vpc_link_id
  vpc_ling_sg = module.networking.vpc_link_sg

}

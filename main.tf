terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "rocket-terraformstate"
    key            = "state/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

locals {
  prefix = "${var.project_name}-${var.env_type}"
}

module "vpc" {
  source     = "./module/vpc"
  vpc_tag    = var.vpc_tag
  subnet_tag = var.subnet_tag
  prefix     = local.prefix
}

module "ec2" {
  source                      = "./module/ec2"
  prefix                      = local.prefix
  associate_public_ip_address = var.associate_public_ip_address
  subnet_id                   = module.vpc.public_subnet_list
  private_subnet_id           = module.vpc.private_subnet_list
  security_group              = module.security_group.ec2_sg_id
  depends_on                  = [module.vpc, module.security_group]
}

module "security_group" {
  source               = "./module/security-group"
  prefix               = local.prefix
  vpc_id               = module.vpc.vpc_id
  ec2_sg_ingress_ports = var.ec2_sg_ingress_ports
  depends_on           = [module.vpc]
}








# Create a VPC
# resource "aws_vpc" "engage-vpc" {
#   cidr_block = "10.0.0.0/16"
#   tags = {
#     Name = var.vpc_tag
#   }
# }
#data "aws_availability_zones" "available" {}
#
#locals {
#  azs           = slice(data.aws_availability_zones.available.names, 0, 2)
#  resource_name = format("%s-%s-%s", var.platform, var.environment, "vpc")
#}
#
#module "vpc" {
#  source  = "terraform-aws-modules/vpc/aws"
#  version = "~> 5.1"
#
#  name = local.resource_name
#  cidr = var.vpc_cidr
#
#  azs                  = local.azs
#  public_subnets       = var.public_subnets
#  private_subnets      = var.private_subnets
#  enable_nat_gateway   = true
#  single_nat_gateway   = true
#  enable_dns_hostnames = true
#
#  tags = var.tags
#}
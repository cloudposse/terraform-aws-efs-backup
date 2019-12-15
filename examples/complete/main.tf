provider "aws" {
  region = var.region
}

module "vpc" {
  source     = "git::https://github.com/cloudposse/terraform-aws-vpc.git?ref=tags/0.8.1"
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  cidr_block = var.vpc_cidr_block
  tags       = var.tags
}

module "subnets" {
  source               = "git::https://github.com/cloudposse/terraform-aws-dynamic-subnets.git?ref=tags/0.16.1"
  availability_zones   = var.availability_zones
  namespace            = var.namespace
  stage                = var.stage
  name                 = var.name
  attributes           = var.attributes
  delimiter            = var.delimiter
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false
  tags                 = var.tags
}

resource "aws_efs_file_system" "default" {
  provisioned_throughput_in_mibps = "10"
  throughput_mode                 = "provisioned"
}

resource "aws_efs_mount_target" "default" {
  count           = length(module.subnets.private_subnet_ids)
  file_system_id  = aws_efs_file_system.default.id
  subnet_id       = element(module.subnets.private_subnet_ids, count.index)
  security_groups = [module.vpc.vpc_default_security_group_id]
}

resource "tls_private_key" "insecure" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "insecure_generated_key" {
  key_name   = "efs-insecure-test-key"
  public_key = tls_private_key.insecure.public_key_openssh
}

module "efs_backup" {
  source = "../.."

  name                  = var.name
  stage                 = var.stage
  namespace             = var.namespace
  vpc_id                = module.vpc.vpc_id
  efs_mount_target_id   = aws_efs_mount_target.default[0].id
  use_ip_address        = "false"
  ssh_key_pair          = aws_key_pair.insecure_generated_key.key_name
  subnet_id             = module.subnets.private_subnet_ids[0]
  modify_security_group = "true"
}

locals {
  resource_count = "${var.backup_enabled == "true" ? 1 : 0}"
}

data "aws_region" "default" {
  current = true
}

module "label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = "${var.attributes}"
  tags       = "${var.tags}"
  enabled    = "${var.backup_enabled == "true" ? "true" : "false"}"
}

data "aws_ami" "amazon_linux" {
  most_recent = "true"
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }
}

data "aws_ami" "amazon_linux_mongo" {
  most_recent = "true"

  filter {
    name   = "name"
    values = ["amazon_linux_mongo"]
  }
}

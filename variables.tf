variable "name" {
  default = "efs-backup"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = ""
}

variable "datapipeline_config" {
  type = "map"

  default = {
    instance_type = "t2.micro"
    email         = ""
    timezone      = "GMT"
    period        = "24 hours"
  }
}

variable "efs_ids" {
  type = "map"

  default = {}
}

variable "ssh_key_name" {
  default = ""
}

variable "s3_bucket_expiration_days" {
  default = "3"
}

variable "namespace" {
  default = ""
}

variable "stage" {
  default = ""
}

data "aws_availability_zones" "az" {}

data "aws_ami" "amazon_linux" {
  most_recent = true
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

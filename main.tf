terraform {
  required_version = "~> 0.9.1"
}

provider "aws" {
  region = "${var.region}"
}

module "tf_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

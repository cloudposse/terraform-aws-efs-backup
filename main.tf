terraform {
  required_version = "~> 0.9.1"
}

provider "aws" {
  region = "${var.region}"
}

module "tf_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

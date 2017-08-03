terraform {
  required_version = "~> 0.9.1"
}

provider "aws" {
  region = "${var.region}"
}

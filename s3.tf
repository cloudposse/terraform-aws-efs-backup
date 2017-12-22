module "logs_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("logs")))}"]
  tags       = "${var.tags}"
  enabled    = "${var.backup_enabled == "true" ? "true" : "false"}"
}

resource "aws_s3_bucket" "logs" {
  count         = "${local.resource_count}"
  bucket        = "${module.logs_label.id}"
  force_destroy = "true"
  tags          = "${module.logs_label.tags}"
}

module "backups_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("backups")))}"]
  tags       = "${var.tags}"
  enabled    = "${var.backup_enabled == "true" ? "true" : "false"}"
}

resource "aws_s3_bucket" "backups" {
  count  = "${local.resource_count}"
  bucket = "${module.backups_label.id}"
  tags   = "${module.backups_label.tags}"

  versioning {
    enabled = "true"
  }

  lifecycle_rule {
    enabled = "true"
    prefix  = "mongo"

    noncurrent_version_expiration {
      days = "${var.noncurrent_version_expiration_days}"
    }
  }
}

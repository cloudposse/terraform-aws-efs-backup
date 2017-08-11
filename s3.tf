module "logs_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-logs"
}

resource "aws_s3_bucket" "logs" {
  bucket        = "${module.logs_label.id}"
  force_destroy = true
  tags          = "${module.logs_label.tags}"
}

module "backups_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-backups"
}

resource "aws_s3_bucket" "backups" {
  bucket = "${module.backups_label.id}"
  tags   = "${module.backups_label.tags}"

  versioning {
    enabled = true
  }

  lifecycle_rule {
    enabled = true
    prefix  = "efs"

    noncurrent_version_expiration {
      days = "${var.s3_version_expiration}"
    }
  }
}

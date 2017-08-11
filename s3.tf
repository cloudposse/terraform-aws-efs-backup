module "log_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "logs"
}

resource "aws_s3_bucket" "logs" {
  bucket        = "${module.log_label.id}"
  force_destroy = true
  tags          = "${module.log_label.tags}"
}

module "backups_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "backups"
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
      days = "${var.s3_bucket_expiration_days}"
    }
  }
}

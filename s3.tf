module "s3_log_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.s3_bucket_efs_name}"
}

module "s3_efs_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

resource "random_id" "s3" {
  byte_length = 8

  keepers = {
    name = "${module.s3_log_label.id}"
  }
}

resource "aws_s3_bucket" "s3" {
  bucket        = "${random_id.s3.hex}"
  force_destroy = true
}

resource "aws_s3_bucket" "efs_backups" {
  bucket = "${module.s3_efs_label.id}"
}

resource "aws_s3_bucket" "s3" {
  bucket        = "${var.s3_log_bucket_name}"
  force_destroy = true
  tags          = "${module.tf_label.tags}"
}

resource "aws_s3_bucket" "efs_backups" {
  bucket = "${var.s3_bucket_name}"
  tags   = "${module.tf_label.tags}"

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

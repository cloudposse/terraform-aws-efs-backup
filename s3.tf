resource "aws_s3_bucket" "logs" {
  bucket        = "${module.tf_label.id}-logs"
  force_destroy = true
  tags          = "${module.tf_label.tags}"
}

resource "aws_s3_bucket" "backups" {
  bucket = "${module.tf_label.id}-backups"
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

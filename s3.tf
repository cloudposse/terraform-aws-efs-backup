module "log_bucket" {
  source      = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=tags/0.7.0"
  enabled     = true
  name        = var.name
  stage       = var.stage
  environment = var.environment
  namespace   = var.namespace
  delimiter   = var.delimiter
  attributes  = compact(concat(var.attributes, list("logs")))
  tags        = var.tags

  acl                          = private
  allow_encrypted_uploads_only = true
  force_destroy                = true
  sse_algorithm                = "AES256"
}

resource "aws_s3_bucket_public_access_block" "log_bucket" {
  bucket = module.log_bucket.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

module "backup_bucket" {
  source      = "git::https://github.com/cloudposse/terraform-aws-s3-bucket.git?ref=tags/0.7.0"
  enabled     = true
  name        = var.name
  stage       = var.stage
  environment = var.environment
  namespace   = var.namespace
  delimiter   = var.delimiter
  attributes  = compact(concat(var.attributes, list("backups")))
  tags        = var.tags

  acl                                = private
  allow_encrypted_uploads_only       = true
  force_destroy                      = false
  lifecycle_rule_enabled             = true
  noncurrent_version_expiration_days = var.noncurrent_version_expiration_days
  prefix                             = "efs"
  sse_algorithm                      = "AES256"
  versioning_enabled                 = true
}

resource "aws_s3_bucket_public_access_block" "backup_bucket" {
  bucket = module.backup_bucket.bucket_id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

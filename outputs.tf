output "aws_vpc" {
  value = "${data.aws_vpc.default.id}"
}

output "aws_subnet_ids" {
  value = "${data.aws_subnet_ids.all.ids}"
}

output "aws_s3_bucket S3" {
  value = "${aws_s3_bucket.s3.bucket_domain_name}"
}

output "aws_s3_bucket efs_backups_domain_name" {
  value = "${aws_s3_bucket.efs_backups.bucket_domain_name}"
}

output "aws_s3_bucket efs_backups_id" {
  value = "${aws_s3_bucket.efs_backups.id}"
}

output "datapipeline_ids" {
  value = "${aws_cloudformation_stack.datapipeline.*.outputs["DataPipelineId"]}"
}

output "SG for EFS instances" {
  value = "${aws_security_group.efs.id}"
}

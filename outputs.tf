output "vpc_id" {
  value = "${data.aws_vpc.default.id}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.logs.bucket_domain_name}"
}

output "backups_domain_name" {
  value = "${aws_s3_bucket.backups.bucket_domain_name}"
}

output "efs_backups_id" {
  value = "${aws_s3_bucket.backups.id}"
}

output "datapipeline_ids" {
  value = "${aws_cloudformation_stack.datapipeline.*.outputs["DataPipelineId"]}"
}

output "sg_for_efs_instances" {
  value = "${aws_security_group.efs.id}"
}

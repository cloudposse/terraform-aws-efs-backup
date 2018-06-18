output "logs_bucket_name" {
  value = "${join("", aws_s3_bucket.logs.bucket_domain_name)}"
}

output "backups_bucket_name" {
  value = "${join("", aws_s3_bucket.backups.bucket_domain_name)}"
}

output "datapipeline_ids" {
  value = "${join("", list(aws_cloudformation_stack.datapipeline.*.outputs["DataPipelineId"]))}"
}

output "security_group_id" {
  value = "${join("", aws_security_group.datapipeline.id)}"
}

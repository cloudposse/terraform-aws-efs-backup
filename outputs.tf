output "logs_bucket_name" {
  value       = "${aws_s3_bucket.logs.bucket_domain_name}"
  description = "Logs bucket name"
}

output "backups_bucket_name" {
  value       = "${aws_s3_bucket.backups.bucket_domain_name}"
  description = "Backups bucket name"
}

output "datapipeline_ids" {
  value       = "${aws_cloudformation_stack.datapipeline.outputs["DataPipelineId"]}"
  description = "Datapipeline ids"
}

output "security_group_id" {
  value       = "${aws_security_group.datapipeline.id}"
  description = "Security group id"
}

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
  value       = "${var.datapipeline_security_group == "" ? join("", aws_security_group.datapipeline.*.id) : var.datapipeline_security_group}"
  description = "Security group id"
}

output "sns_topic_arn" {
  value       = "${aws_cloudformation_stack.sns.outputs.arn}"
  description = "Backup notification SNS topic ARN"
}

# Get list of EFS ids
data "aws_efs_file_system" "by_id" {
  count          = "${length(var.efs_ids)}"
  file_system_id = "${element(var.efs_ids, count.index)}"
}

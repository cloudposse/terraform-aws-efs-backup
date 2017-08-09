# Get list of EFS ids
data "aws_efs_file_system" "default" {
  count          = "${length(efs_ids)}"
  file_system_id = "${element(var.efs_ids, count.index)}"
}

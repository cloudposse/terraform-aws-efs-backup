# Get list of EFS ids
data "aws_efs_file_system" "by_id" {
  count          = "${length(keys(var.efs_ids))}"
  file_system_id = "${element(keys(var.efs_ids), count.index)}"
}

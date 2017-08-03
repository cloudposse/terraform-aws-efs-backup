# Get list of EFS ids
data "aws_efs_file_system" "by_id" {
  count          = "${length(var.efs_ids)}"
  file_system_id = "${element(var.efs_ids, count.index)}"
}

# Create the mountpoint for DataPipeline EC2 instance
resource "aws_efs_mount_target" "efs_target" {
  count = "${length(var.efs_ids)}"

  file_system_id = "${element(var.efs_ids, count.index)}"
  subnet_id      = "${data.aws_subnet_ids.all.ids[0]}"
  security_groups = ["${aws_security_group.datapipeline.id}"]
  depends_on = ["aws_security_group.datapipeline"]
}

# Get Elastic File System Mount Target
data "aws_efs_mount_target" "default" {
  mount_target_id = "${var.efs_mount_target_id}"
}

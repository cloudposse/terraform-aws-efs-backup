# Get list of Elastic File System Mount Target (EFS)
data "aws_efs_mount_target" "default" {
  mount_target_id = "${var.efs_mtid}"
}

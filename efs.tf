# Get list of EFS ids
data "aws_efs_file_system" "default" {
  file_system_id = "${var.efs_id}"
}

variable "name" {}

variable "namespace" {}

variable "stage" {}

variable "region" {}

variable "vpc_id" {}

variable "use_ip_address" {
  default = false
}

variable "datapipeline_config" {
  type = "map"

  default = {
    instance_type = "t2.micro"
    email         = ""
    period        = "24 hours"
    timeout       = "60 Minutes"
  }
}

variable "efs_mount_target_id" {}

variable "modify_security_group" {
  default = false
}

# Set a name of ssh key that will be deployed on DataPipeline's instance. The key should be present in AWS.
variable "ssh_key_pair" {}

variable "noncurrent_version_expiration_days" {
  default = "35"
}

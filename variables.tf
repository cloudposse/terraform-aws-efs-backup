variable "name" {}

variable "namespace" {}

variable "stage" {}

variable "region" {}

variable "vpc_id" {}

# https://www.terraform.io/docs/configuration/variables.html
# simply using string values rather than booleans for variables is recommended
variable "use_ip_address" {
  default = "false"
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

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "name" {
  description = "The Name of the application or solution  (e.g. `bastion` or `portal`)"
}

variable "namespace" {
  description = "Namespace (e.g. `cp` or `cloudposse`)"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "region" {
  type        = "string"
  default     = ""
  description = "(Optional) AWS Region. If not specified, will be derived from 'aws_region' data source"
}

variable "vpc_id" {
  default     = ""
  description = "VPC ID"
}

# https://www.terraform.io/docs/configuration/variables.html
# simply using string values rather than booleans for variables is recommended
variable "use_ip_address" {
  default     = "false"
  description = "If set to `true`, will use IP address instead of DNS name to connect to the `EFS`"
}

variable "datapipeline_config" {
  description = "DataPipeline configuration options"
  type        = "map"

  default = {
    instance_type = "t2.micro"
    email         = ""
    period        = "24 hours"
    timeout       = "60 Minutes"
  }
}

variable "efs_mount_target_id" {
  type        = "string"
  description = "EFS Mount Target ID (e.g. `fsmt-279bfc62`)"
}

variable "modify_security_group" {
  default     = "false"
  description = " Should the module modify the `EFS` security group"
}

# Set a name of ssh key that will be deployed on DataPipeline's instance. The key should be present in AWS.
variable "ssh_key_pair" {
  type        = "string"
  description = "`SSH` key that will be deployed on DataPipeline's instance"
}

variable "noncurrent_version_expiration_days" {
  default     = "35"
  description = "S3 object versions expiration period (days)"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes (e.g. `efs-backup`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

variable "subnet_id" {
  type        = "string"
  default     = ""
  description = "Optionally specify the subnet to use"
}

variable "datapipeline_security_group" {
  type        = "string"
  default     = ""
  description = "Optionally specify a security group to use for the datapipeline instances"
}

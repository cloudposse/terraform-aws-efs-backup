variable "namespace" {
  type        = string
  description = "Namespace (e.g. `eg` or `cp`)"
  default     = ""
}

variable "stage" {
  type        = string
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = ""
}

variable "environment" {
  type        = string
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
  default     = ""
}

variable "name" {
  type        = string
  description = "Name of the application"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter between `namespace`, `stage`, `name` and `attributes`"
}

variable "attributes" {
  type        = list(string)
  description = "Additional attributes (_e.g._ \"1\")"
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (_e.g._ { BusinessUnit : ABC })"
  default     = {}
}

variable "region" {
  type        = string
  default     = ""
  description = "(Optional) AWS Region. If not specified, will be derived from 'aws_region' data source"
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "VPC ID"
}

# https://www.terraform.io/docs/configuration/variables.html
# simply using string values rather than booleans for variables is recommended
variable "use_ip_address" {
  type        = bool
  default     = false
  description = "If set to `true`, will use IP address instead of DNS name to connect to the `EFS`"
}

variable "datapipeline_config" {
  type        = map(string)
  description = "DataPipeline configuration options"

  default = {
    instance_type = "t2.micro"
    email         = ""
    period        = "24 hours"
    timeout       = "60 Minutes"
  }
}

variable "efs_mount_target_id" {
  type        = string
  description = "EFS Mount Target ID (e.g. `fsmt-279bfc62`)"
}

variable "modify_security_group" {
  type        = bool
  default     = false
  description = "Should the module modify the `EFS` security group"
}

# Set a name of ssh key that will be deployed on DataPipeline's instance. The key should be present in AWS.
variable "ssh_key_pair" {
  type        = string
  description = "`SSH` key that will be deployed on DataPipeline's instance"
}

variable "noncurrent_version_expiration_days" {
  type        = string
  default     = "35"
  description = "S3 object versions expiration period (days)"
}

variable "subnet_id" {
  type        = string
  default     = ""
  description = "Optionally specify the subnet to use"
}

variable "datapipeline_security_group" {
  type        = string
  default     = ""
  description = "Optionally specify a security group to use for the datapipeline instances"
}

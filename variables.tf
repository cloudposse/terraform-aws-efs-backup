variable "name" {
  type = "string"
}

variable "namespace" {
  type = "string"
}

variable "stage" {
  type = "string"
}

variable "region" {
  type        = "string"
  default     = ""
  description = "(Optional) AWS Region. If not specified, will be derived from 'aws_region' data source"
}

variable "vpc_id" {
  type = "string"
}

# https://www.terraform.io/docs/configuration/variables.html
# simply using string values rather than booleans for variables is recommended
variable "ip_address" {
  default = ""
}

variable "security_group_id" {
  default = ""
}

variable "dbuser" {
  default = "string"
}

variable "dbpassword" {
  default = "string"
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

variable "modify_security_group" {
  default = "false"
}

# Set a name of ssh key that will be deployed on DataPipeline's instance. The key should be present in AWS.
variable "ssh_key_pair" {
  type = "string"
}

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
  description = "Additional attributes (e.g. `mongo-backup`)"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit`,`XYZ`)"
}

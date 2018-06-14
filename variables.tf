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
  type        = "string"
  description = "Username for accessing MongoDB (e.g. `root`)"
}

variable "dbpassword" {
  type        = "string"
  description = "Password for accessing MongoDB (e.g. `password`)"
}

variable "dbname" {
  type        = "string"
  description = "MongoDB Database name (e.g. `testdb`)"
}

variable "dbssl" {
  type        = "string"
  default     = "false"
  description = "MongoDB ssl (e.g. `true/false`)"
}

variable "dbport" {
  type        = "string"
  default     = "27017"
  description = "MongoDB port (e.g. `27017`)"
}

variable "dbversion" {
  type        = "string"
  default     = "3.2"
  description = "MongoDB version (e.g. `3.2`)"
}

variable "dbcollection" {
  type        = "string"
  description = "MongoDB collection name (e.g. `testcollection`)"
}

variable "dbquery" {
  type        = "string"
  description = "MongoDB query  (e.g. `{$or:[{\"_type\":\"is:role\"},{\"_type\":\"is:template\"}]}`)"
}

variable "datapipeline_config" {
  type = "map"

  default = {
    instance_type = "t2.micro"
    email         = ""
    period        = "24 hours"
    startDateTime = "2017-12-01T00:00:00"
    timeout       = "60 Minutes"
  }
}

variable "backup_enabled" {
  default = "true"
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

variable "abort_incomplete_multipart_upload_days" {
  default = "7"
}

variable "expired_object_delete_marker" {
  default = "true"
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

variable "name" {
  default = ""
}

variable "namespace" {
  default = ""
}

variable "stage" {
  default = ""
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = ""
}

variable "datapipeline_config" {
  type = "map"

  default = {
    instance_type = "t2.micro"
    email         = ""
    timezone      = "GMT"
    period        = "24 hours"
  }
}

variable "efs_ids" {
  type = "list"

  default = []
}

# Set a name of ssh key that will be deployed on DataPipeline's instance. The key should be present in AWS.
variable "ssh_key_pair" {
  default = ""
}

variable "noncurrent_version_expiration_days" {
  default = "3"
}

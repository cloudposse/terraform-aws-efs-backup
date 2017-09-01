# tf_efs_backup

This repo contains a terraform module for automatic EFS backup

The workflow is simple:
* Periodically launch resource (EC2 instance) based on schedule
* Execute the shell command defined in the activity on the instance
* Execute sync data from Production EFS to S3 Bucket by aws-cli
* The execution log of the activity is stored in S3
* Publish to the SNS topic that defined the success or failure of the activity
* Automatic backup rotation using `S3 lifecycle rule`

## Usage

Include this repository as a module in your existing terraform code:

```
module "efs_backup" {
  source = "git::https://github.com/cloudposse/tf_efs_backup.git?ref=master"

  name                               = "${var.name}"
  stage                              = "${var.stage}"
  namespace                          = "${var.namespace}"
  region                             = "${var.region}"
  vpc_id                             = "${var.vpc_id}"
  efs_mount_target_id                = "${var.efs_mount_target_id}"
  use_ip_address                     = true
  noncurrent_version_expiration_days = "${var.noncurrent_version_expiration_days}"
  ssh_key_pair                       = "${var.ssh_key_pair}"
  datapipeline_config                = "${var.datapipeline_config}"
  modify_security_group              = true
}

output "efs_backup_security_group" {
  value = "${module.efs_backup.security_group_id}"
}
```


## Variables

|  Name                              |  Default       |  Description                                                                        | Required |
|:----------------------------------:|:--------------:|:-----------------------------------------------------------------------------------:|:--------:|
| namespace                          | ``             | Namespace (e.g. `cp` or `cloudposse`)                                               | Yes      |
| stage                              | ``             | Stage (e.g. `prod`, `dev`, `staging`)                                               | Yes      |
| name                               | ``             | Name  (e.g. `efs-backup`)                                                           | Yes      |
| region                             | `us-east-1`    | AWS Region where module should operate (e.g. `us-east-1`)                           | Yes      |
| vpc_id                             | ``             | AWS VPC ID where module should operate (e.g. `vpc-a22222ee`)                        | Yes      |
| efs_mount_target_id                | ``             | Elastic File System Mount Target ID (e.g. `fsmt-279bfc62`)                          | Yes      |
| use_ip_address                     | `false`        | If set to `true` will be used IP address instead DNS name of Elastic File System    | Yes      |
| modify_security_group              | `false`        | Should the module modify EFS security groups (if set to `false` backups will fail)  | Yes      |
| noncurrent_version_expiration_days | `3`            | S3 object versions expiration period (days)                                         | Yes      |
| ssh_key_pair                       | ``             | A ssh key that will be deployed on DataPipeline's instance                          | Yes      |
| datapipeline_config                | `${map("instance_type", "t2.micro", "email", "", "period", "24 hours")}"`| Essential Datapipeline configuration options | Yes |

### `datapipeline_config` variables

|  Name                              |  Default       |  Description                                                | Required |
|:----------------------------------:|:--------------:|:-----------------------------------------------------------:|:--------:|
| instance_type                      | `t2.micro`     | Instance type to use                                        | Yes      |
| email                              | ``             | Email to use in SNS                                         | Yes      |
| period                             | `24 hours`     | Frequency of pipeline execution (frequency of backups)      | Yes      |



## Configuring your EFS filesystems to be backed up:
* Add security group ID from output `efs_backup_security_group`
to a security group of EFS Filesystems


## References
* Thanks https://github.com/knakayama/datapipeline-efs-backup-demo for inspiration

# tf_efs_backup

# Terraform module for automatic EFS backup

This repo contains a terraform module that creates backup of EFS Filesystems

The workflow is simple:
* Periodically launch resource (EC 2 instance) based on schedule
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

  name                      = "${var.name}"
  stage                     = "${var.stage}"
  namespace                 = "${var.namespace}"
  region                    = "${var.region}"
  vpc_id                    = "${var.vpc_id}"
  efs_ids                   = "${var.efs_ids}"
  s3_version_expiration     = "${var.s3_version_expiration}"
  ssh_key_pair              = "${var.ssh_key_pair}"

  datapipeline_config = "${map(
    "instance_type", "t2.micro",
    "email", "",
    "timezone", "GMT",
    "period", "24 hours"
    )}"
}


output "efs_backup_security_group" {
  value = "${module.efs_backup.security_group_id}"
}
```


## Variables

|  Name                        |  Default       |  Description                                             | Required |
|:----------------------------:|:--------------:|:--------------------------------------------------------:|:--------:|
| namespace                    | ``             | Namespace (e.g. `cp` or `cloudposse`)                    | Yes      |
| stage                        | ``             | Stage (e.g. `prod`, `dev`, `staging`                     | Yes      |
| name                         | ``             | Name  (e.g. `efs-backup`)                                | Yes      |
| region                       | `us-east-1`    | AWS Region where module should operate (e.g. `us-east-1`)| Yes      |
| vpc_id                       | ``             | AWS VPC ID where module should operate (e.g. `vpc-a22222ee`)| Yes   |
| efs_ids                      | []             | List of EFS ID                                           | Yes      |
| s3_version_expiration        | `3`            | Delete S3 objects after a specified period of time (days)| Yes      |
| ssh_key_pair                 | ``             | A ssh key that will be deployed on DataPipeline's instance| Yes      |
| instance_type                | `t2.micro`     | Instance type to use                                     | No       |
| email                        | ``             | Email to use in SNS                                      | Yes      |
| period                       | `24 hours`     | Frequency of pipeline execution                          | No       |



## Configuring your EFS filesystems to be backed up:
* Add security group ID from output `efs_backup_security_group`
to a security group of EFS Filesystems



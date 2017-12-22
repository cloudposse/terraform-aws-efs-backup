# terraform-aws-mongo-backup

Terraform module designed to easily backup mongo filesystems to S3 using DataPipeline.

The workflow is simple:

* Periodically launch resource (EC2 instance) based on schedule
* Execute the shell command defined in the activity on the instance
* Sync data from Production mongo to S3 Bucket by using `aws-cli`
* The execution log of the activity is stored in `S3`
* Publish the success or failure of the activity to an `SNS` topic
* Automatically rotate the backups using `S3 lifecycle rule`


## Usage

Include this module in your existing terraform code:

```hcl
module "mongo_backup" {
  source = "git::https://github.com/cloudposse/terraform-aws-mongo-backup.git?ref=master"

  name                               = "${var.name}"
  stage                              = "${var.stage}"
  namespace                          = "${var.namespace}"
  vpc_id                             = "${var.vpc_id}"
  use_ip_address                     = "false"
  noncurrent_version_expiration_days = "${var.noncurrent_version_expiration_days}"
  ssh_key_pair                       = "${var.ssh_key_pair}"
  datapipeline_config                = "${var.datapipeline_config}"
  modify_security_group              = "true"
}

output "mongo_backup_security_group" {
  value = "${module.mongo_backup.security_group_id}"
}
```


## Variables

**Note:** If one of `dbname`, `dbcollection` or `dbquery` is not specified -
a full backup will be launched

| Name                               |      Default       | Description                                                                            | Required |
|:-----------------------------------|:------------------:|:---------------------------------------------------------------------------------------|:--------:|
| namespace                          |         ``         | Namespace (e.g. `cp` or `cloudposse`)                                                  |   Yes    |
| stage                              |         ``         | Stage (e.g. `prod`, `dev`, `staging`)                                                  |   Yes    |
| name                               |         ``         | Name  (e.g. `app` or `wordpress`)                                                      |   Yes    |
| region                             |    `us-east-1`     | (Optional) AWS Region. If not specified, will be derived from 'aws_region' data source |    No    |
| vpc_id                             |         ``         | AWS VPC ID where module should operate (e.g. `vpc-a22222ee`)                           |   Yes    |
| use_ip_address                     |      `false`       | If set to `true`, will use IP address instead of DNS name to connect to the `mongo`    |   Yes    |
| modify_security_group              |      `false`       | Should the module modify the `mongo` security group                                    |    No    |
| noncurrent_version_expiration_days |        `35`        | S3 object versions expiration period (days)                                            |   Yes    |
| ssh_key_pair                       |         ``         | `SSH` key that will be deployed on DataPipeline's instance                             |    No    |
| datapipeline_config                | `see variables.tf` | DataPipeline configuration options                                                     |   Yes    |
| attributes                         |        `[]`        | Additional attributes (e.g. `["mongo", "backup"]`)                                     |    No    |
| tags                               |        `{}`        | Additional tags (e.g. `map("BusinessUnit","XYZ")`                                      |    No    |
| delimiter                          |        `-`         | Delimiter to be used between `name`, `namespace`, `stage` and `attributes`             |    No    |
| dbuser                             |         ``         | Username for accessing MongoDB (e.g. `root`)                                           |   Yes    |
| dbpassword                         |         ``         | Password for accessing MongoDB (e.g. `password`)                                       |   Yes    |
| dbname                             |         ``         | MongoDB Database name (e.g. `testdb`)                                                  |    No    |
| dbcollection                       |         ``         | MongoDB collection name (e.g. `testcollection`)                                        |    No    |
| dbquery                            |         ``         | MongoDB query  (e.g. `"{$or:[{\"_type\":\"is:role\"},{\"_type\":\"is:template\"}]}"`)  |    No    |


### `datapipeline_config` variables

| Name          |        Default        | Description                                                                 | Required |
|:--------------|:---------------------:|:----------------------------------------------------------------------------|:--------:|
| instance_type |      `t2.micro`       | Instance type to use                                                        |   Yes    |
| email         |          ``           | Email to use in `SNS`. Needs to be provided, otherwise the module will fail |   Yes    |
| period        |      `24 hours`       | Frequency of pipeline execution (frequency of backups)                      |   Yes    |
| startDateTime | `2017-12-01T00:00:00` | Time and Date of Datapipeline first start                                   |   Yes    |
| timeout       |     `60 Minutes`      | Pipeline execution timeout                                                  |   Yes    |



## Integration with `mongo`

To enable connectivity between the `DataPipeline` instances and the `mongo`, use one of the following methods to configure Security Groups:

1. Explicitly add the `DataPipeline` SG (the output of this module `security_group_id`) to the list of the `ingress` rules of the `mongo` SG. For example:

```hcl
module "mongo_backup" {
  source     = "git::https://github.com/ITSvitCo/terraform-aws-mongo-backup.git?ref=master"
  name       = "${var.name}"
  stage      = "${var.stage}"
  namespace  = "${var.namespace}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("mongo", "backup")))}"]
  tags       = "${var.tags}"

  # Important to set it to `false` since we added the `DataPipeline` SG (output of the `mongo_backup` module) to the `security_groups` of the `mongo` module
  # See NOTE below for more information
  modify_security_group = "false"

  # ..............................
}
```

2. Set `modify_security_group` attribute to `true` so the module will modify the `mongo` SG to allow the `DataPipeline` to connect to the `mongo`

**NOTE:** Do not mix these two methods together.
`Terraform` does not support using a Security Group with in-line rules in conjunction with any Security Group Rule resources.
https://www.terraform.io/docs/providers/aws/r/security_group_rule.html
> NOTE on Security Groups and Security Group Rules: Terraform currently provides both a standalone Security Group Rule resource
(a single ingress or egress rule), and a Security Group resource with ingress and egress rules defined in-line.
At this time you cannot use a Security Group with in-line rules in conjunction with any Security Group Rule resources.
Doing so will cause a conflict of rule settings and will overwrite rules.


## References

* Thanks https://github.com/knakayama/datapipeline-mongo-backup-demo for inspiration


## License

Apache 2 License. See [`LICENSE`](LICENSE) for full details.

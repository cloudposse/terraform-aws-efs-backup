## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| attributes | Additional attributes (e.g. `efs-backup`) | list | `<list>` | no |
| datapipeline_config | DataPipeline configuration options | map | `<map>` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | string | `-` | no |
| efs_mount_target_id | EFS Mount Target ID (e.g. `fsmt-279bfc62`) | string | - | yes |
| modify_security_group | Should the module modify the `EFS` security group | string | `false` | no |
| name | The Name of the application or solution  (e.g. `bastion` or `portal`) | string | - | yes |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | - | yes |
| noncurrent_version_expiration_days | S3 object versions expiration period (days) | string | `35` | no |
| region | (Optional) AWS Region. If not specified, will be derived from 'aws_region' data source | string | `` | no |
| ssh_key_pair | `SSH` key that will be deployed on DataPipeline's instance | string | - | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | - | yes |
| subnet_id | Optionally specify the subnet to use | string | `` | no |
| tags | Additional tags (e.g. `map('BusinessUnit`,`XYZ`) | map | `<map>` | no |
| use_ip_address | If set to `true`, will use IP address instead of DNS name to connect to the `EFS` | string | `false` | no |
| vpc_id | VPC ID | string | `` | no |

## Outputs

| Name | Description |
|------|-------------|
| backups_bucket_name | Backups bucket name |
| datapipeline_ids | Datapipeline ids |
| logs_bucket_name | Logs bucket name |
| security_group_id | Security group id |


module "sns_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-sns"
}

resource "aws_cloudformation_stack" "sns" {
  name          = "${module.sns_label.id}"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }
}

module "datapipeline_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-datapipeline"
}

resource "aws_cloudformation_stack" "datapipeline" {
  name          = "${module.datapipeline_label.id}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    myInstanceType             = "${var.datapipeline_config["instance_type"]}"
    mySubnetId                 = "${data.aws_subnet_ids.default.ids[0]}"
    mySecurityGroupId          = "${aws_security_group.datapipeline.id}"
    myEFSId                    = "${data.aws_efs_mount_target.default.file_system_id}"
    myEFSIP                    = "${var.efs_ip}"
    myS3BackupsBucket          = "${aws_s3_bucket.backups.id}"
    myRegion                   = "${var.region}"
    myImageId                  = "${data.aws_ami.amazon_linux.id}"
    myTopicArn                 = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    myS3LogBucket              = "${aws_s3_bucket.logs.id}"
    myDataPipelineResourceRole = "${aws_iam_instance_profile.resource_role.name}"
    myDataPipelineRole         = "${aws_iam_role.role.name}"
    myKeyPair                  = "${var.ssh_key_pair}"
    myPeriod                   = "${var.datapipeline_config["period"]}"
    Tag                        = "${module.label.id}"
  }
}

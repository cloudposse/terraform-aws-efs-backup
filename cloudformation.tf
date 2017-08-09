resource "aws_cloudformation_stack" "sns" {
  name          = "${module.tf_label.id}"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }
}

resource "aws_cloudformation_stack" "datapipeline" {
  count         = "${length(keys(var.efs_ids))}"
  name          = "${module.tf_label.id}-${count.index}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    myInstanceType             = "${var.datapipeline_config["instance_type"]}"
    mySubnetId                 = "${data.aws_subnet_ids.default.ids[0]}"
    mySecurityGroupId          = "${aws_security_group.datapipeline.id}"
    myEFSId                    = "${data.aws_efs_file_system.default.*.id[count.index]}"
    myS3BackupsBucket          = "${aws_s3_bucket.backups.id}"
    myRegion                   = "${var.region}"
    myImageId                  = "${data.aws_ami.amazon_linux.id}"
    myTopicArn                 = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    myS3LogBucket              = "${aws_s3_bucket.logs.id}"
    myDataPipelineResourceRole = "${aws_iam_instance_profile.datapipeline_resource.name}"
    myDataPipelineRole         = "${aws_iam_role.datapipeline_role.name}"
    myKeyPair                  = "${var.ssh_key_pair}"
    myPeriod                   = "${var.datapipeline_config["period"]}"
    Tag                        = "${module.tf_label.id}-${count.index}"
  }
}

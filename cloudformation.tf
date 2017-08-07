resource "aws_cloudformation_stack" "sns" {
  name          = "${module.tf_label.id}"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }
}

resource "aws_cloudformation_stack" "datapipeline" {
  count         = "${length(keys(var.efs_id_mount_point))}"
  name          = "${module.tf_label.id}-${count.index}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    myInstanceType             = "${var.datapipeline_config["instance_type"]}"
    mySubnetId                 = "${data.aws_subnet_ids.all.ids[0]}"
    mySecurityGroupId          = "${aws_security_group.datapipeline.id}"
    myEFSId                    = "${data.aws_efs_file_system.by_id.*.id[count.index]}"
    myS3BackupsBucket          = "${aws_s3_bucket.efs_backups.id}"
    myRegion                   = "${var.region}"
    myImageId                  = "${data.aws_ami.amazon_linux.id}"
    myTopicArn                 = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    myS3LogBucket              = "${aws_s3_bucket.s3.id}"
    myDataPipelineResourceRole = "${aws_iam_instance_profile.datapipeline_resource.name}"
    myDataPipelineRole         = "${aws_iam_role.datapipeline_role.name}"
    myKeyPair                  = "${var.ssh_key_name}"
    myPeriod                   = "${var.datapipeline_config["period"]}"
    Tag                        = "${module.tf_label.id}-${count.index}"
  }
}

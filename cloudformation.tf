module "cf_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

resource "aws_cloudformation_stack" "sns" {
  name          = "${module.cf_label.id}_sns_stack"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }
}

resource "aws_cloudformation_stack" "datapipeline" {
  count         = "${length(var.efs_ids)}"
  name          = "${module.cf_label.id}_datapipeline_stack_${count.index}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    myInstanceType             = "${var.datapipeline_config["instance_type"]}"
    mySubnetId                 = "${data.aws_subnet_ids.all.ids[0]}"
    mySecurityGroupId          = "${aws_security_group.datapipeline.id}"
    myEFSId                    = "${data.aws_efs_file_system.by_id.*.id[count.index]}"
    myEFSSource                = "${data.aws_efs_file_system.by_id.*.id[count.index]}"
    myS3BackupsBucket          = "${aws_s3_bucket.efs_backups.bucket_domain_name}"
    myTimeZone                 = "${var.datapipeline_config["timezone"]}"
    myImageId                  = "${data.aws_ami.amazon_linux.id}"
    myTopicArn                 = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    myS3LogBucket              = "${aws_s3_bucket.s3.id}"
    myDataPipelineResourceRole = "${aws_iam_instance_profile.datapipeline_resource.name}"
    myDataPipelineRole         = "${aws_iam_role.datapipeline_role.name}"
    myKeyPair                  = "${var.ssh_key_name}"
    myPeriod                   = "${var.datapipeline_config["period"]}"
    Tag                        = "${var.name}-${count.index}"
  }
}

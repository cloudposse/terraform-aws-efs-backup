module "sns_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("sns")))}"]
  tags       = "${var.tags}"
}

resource "aws_cloudformation_stack" "sns" {
  name          = "${module.sns_label.id}"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }

  tags = "${module.sns_label.tags}"
}

module "datapipeline_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.15.0"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("datapipeline")))}"]
  tags       = "${var.tags}"
}

resource "aws_cloudformation_stack" "datapipeline" {
  name          = "${module.datapipeline_label.id}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    myInstanceType             = "${var.datapipeline_config["instance_type"]}"
    mySubnetId                 = "${var.subnet_id == "" ? data.aws_subnet_ids.default.ids[0] : var.subnet_id}"
    mySecurityGroupId          = "${var.datapipeline_security_group == "" ? join("", aws_security_group.datapipeline.*.id) : var.datapipeline_security_group}"
    myEFSHost                  = "${var.use_ip_address == "true" ? data.aws_efs_mount_target.default.ip_address : format("%s.efs.%s.amazonaws.com", data.aws_efs_mount_target.default.file_system_id, (signum(length(var.region)) == 1 ? var.region : data.aws_region.default.name))}"
    myS3BackupsBucket          = "${aws_s3_bucket.backups.id}"
    myRegion                   = "${signum(length(var.region)) == 1 ? var.region : data.aws_region.default.name}"
    myImageId                  = "${data.aws_ami.amazon_linux.id}"
    myTopicArn                 = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    myS3LogBucket              = "${aws_s3_bucket.logs.id}"
    myDataPipelineResourceRole = "${aws_iam_instance_profile.resource_role.name}"
    myDataPipelineRole         = "${aws_iam_role.role.name}"
    myKeyPair                  = "${var.ssh_key_pair}"
    myPeriod                   = "${var.datapipeline_config["period"]}"
    Tag                        = "${module.label.id}"
    myExecutionTimeout         = "${var.datapipeline_config["timeout"]}"
  }

  tags = "${module.datapipeline_label.tags}"
}

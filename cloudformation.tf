module "sns_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("sns")))}"]
  tags       = "${var.tags}"
  enabled    = "${var.backup_enabled == "true" ? "true" : "false"}"
}

resource "aws_cloudformation_stack" "sns" {
  count         = "${local.resource_count}"
  name          = "${module.sns_label.id}"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }

  tags = "${module.sns_label.tags}"
}

module "datapipeline_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.3.1"
  namespace  = "${var.namespace}"
  stage      = "${var.stage}"
  name       = "${var.name}"
  delimiter  = "${var.delimiter}"
  attributes = ["${compact(concat(var.attributes, list("datapipeline")))}"]
  tags       = "${var.tags}"
  enabled    = "${var.backup_enabled == "true" ? "true" : "false"}"
}

resource "aws_cloudformation_stack" "datapipeline" {
  count         = "${local.resource_count}"
  name          = "${module.datapipeline_label.id}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    myInstanceType             = "${var.datapipeline_config["instance_type"]}"
    mySubnetId                 = "${data.aws_subnet_ids.default.ids[0]}"
    mySecurityGroupId          = "${aws_security_group.datapipeline.id}"
    myMongoHost                = "${var.ip_address}"
    myDBuser                   = "${var.dbuser}"
    myDBpassword               = "${var.dbpassword}"
    myDBname                   = "${var.dbname}"
    myDBcollection             = "${var.dbcollection}"
    myDBquery                  = "${var.dbquery}"
    myDBssl                    = "${var.dbssl}"
    myDBport                   = "${var.dbport}"
    myDBversion                = "${var.dbversion}"
    myS3BackupsBucket          = "${aws_s3_bucket.backups.id}"
    myRegion                   = "${signum(length(var.region)) == 1 ? var.region : data.aws_region.default.name}"
    myImageId                  = "${var.dbname == "none" ? data.aws_ami.amazon_linux_mongo.id : data.aws_ami.amazon_linux.id}"
    myTopicArn                 = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    myS3LogBucket              = "${aws_s3_bucket.logs.id}"
    myDataPipelineResourceRole = "${aws_iam_instance_profile.resource_role.name}"
    myDataPipelineRole         = "${aws_iam_role.role.name}"
    myKeyPair                  = "${var.ssh_key_pair}"
    myStartDateTime            = "${var.datapipeline_config["startDateTime"]}"
    myPeriod                   = "${var.datapipeline_config["period"]}"
    Tag                        = "${module.label.id}"
    myExecutionTimeout         = "${var.datapipeline_config["timeout"]}"
  }

  tags = "${module.datapipeline_label.tags}"
}

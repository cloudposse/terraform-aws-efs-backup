module "cf_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

resource "aws_cloudformation_stack" "sns" {
  name          = "${module.cf_label.id}-sns-stack"
  template_body = "${file("${path.module}/templates/sns.yml")}"

  parameters {
    Email = "${var.datapipeline_config["email"]}"
  }
}

resource "aws_cloudformation_stack" "datapipeline" {
  count         = "${length(var.efs_ids)}"
  name          = "efs-backup-datapipeline-stack-${count.index}"
  template_body = "${file("${path.module}/templates/datapipeline.yml")}"

  parameters {
    instance_type              = "${var.datapipeline_config["instance_type"]}"
    subnet_id                  = "${data.aws_subnet_ids.all.ids[0]}"
    security_group_id          = "${aws_security_group.datapipeline.id}"
    efs_id                     = "${data.aws_efs_file_system.by_id.*.id[count.index]}"
    efs_source                 = "${data.aws_efs_file_system.by_id.*.id[count.index]}"
    s3_backups_bucket          = "${aws_s3_bucket.efs_backups.bucket_domain_name}"
    time_zone                  = "${var.datapipeline_config["timezone"]}"
    image_id                   = "${data.aws_ami.amazon_linux.id}"
    topic_arn                  = "${aws_cloudformation_stack.sns.outputs["TopicArn"]}"
    s3_log_bucket              = "${aws_s3_bucket.s3.id}"
    datapipeline_resource_role = "${aws_iam_instance_profile.datapipeline_resource.name}"
    datapipeline_role          = "${aws_iam_role.datapipeline_role.name}"
    key_pair                   = "${var.ssh_key_name}"
    period                     = "${var.datapipeline_config["period"]}"
    tag                        = "efs-backup-${count.index}"
  }
}

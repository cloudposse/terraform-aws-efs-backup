data "aws_iam_policy_document" "ec2" {
  statement {
    sid     = "EC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "ec2_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-ec2"
}

resource "aws_iam_role" "ec2" {
  name               = "${module.ec2_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

module "instance_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-instance"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${module.instance_label.id}"
  role = "${aws_iam_role.ec2.name}"
}

data "aws_iam_policy_document" "datapipeline_resource" {
  statement {
    sid     = "EC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "resource_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-resource"
}

resource "aws_iam_role" "datapipeline_resource" {
  name               = "${module.resource_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.datapipeline_resource.json}"
}

resource "aws_iam_policy_attachment" "datapipeline_resource" {
  name       = "${module.resource_label.id}"
  roles      = ["${aws_iam_role.datapipeline_resource.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforDataPipelineRole"
}

resource "aws_iam_instance_profile" "datapipeline_resource" {
  name = "${module.resource_label.id}"
  role = "${aws_iam_role.datapipeline_resource.name}"
}

data "aws_iam_policy_document" "datapipeline_role" {
  statement {
    sid     = "AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals = {
      type = "Service"

      identifiers = [
        "elasticmapreduce.amazonaws.com",
        "datapipeline.amazonaws.com",
      ]
    }
  }
}

module "role_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-role"
}

resource "aws_iam_role" "datapipeline_role" {
  name               = "${module.role_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.datapipeline_role.json}"
}

resource "aws_iam_policy_attachment" "datapipeline_role" {
  name       = "${module.role_label.id}"
  roles      = ["${aws_iam_role.datapipeline_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataPipelineRole"
}

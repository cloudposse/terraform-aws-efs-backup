//data "aws_iam_policy_document" "ec2" {
//  statement {
//    sid     = "EC2AssumeRole"
//    effect  = "Allow"
//    actions = ["sts:AssumeRole"]
//
//    principals = {
//      type        = "Service"
//      identifiers = ["ec2.amazonaws.com"]
//    }
//  }
//}

//module "ec2_label" {
//  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
//  namespace = "${var.namespace}"
//  stage     = "${var.stage}"
//  name      = "${var.name}-ec2"
//}

//resource "aws_iam_role" "ec2" {
//  name               = "${module.ec2_label.id}"
//  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
//}

//module "instance_label" {
//  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
//  namespace = "${var.namespace}"
//  stage     = "${var.stage}"
//  name      = "${var.name}-instance"
//}

//resource "aws_iam_instance_profile" "instance_profile" {
//  name = "${module.instance_label.id}"
//  role = "${aws_iam_role.ec2.name}"
//}

data "aws_iam_policy_document" "resource_role" {
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

module "resource_role_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-resource-role"
}

resource "aws_iam_role" "resource_role" {
  name               = "${module.resource_role_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.resource_role.json}"
}

resource "aws_iam_role_policy_attachment" "resource_role" {
  role      = "${aws_iam_role.resource_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforDataPipelineRole"
}

resource "aws_iam_instance_profile" "resource_role" {
  name = "${module.resource_role_label.id}"
  role = "${aws_iam_role.resource_role.name}"
}

data "aws_iam_policy_document" "role" {
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

resource "aws_iam_role" "role" {
  name               = "${module.role_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.role.json}"
}

resource "aws_iam_role_policy_attachment" "role" {
  role      = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataPipelineRole"
}

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
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace = "${var.namespace}"
  stage     = "${terraform.workspace}"
  name      = "${var.name}"
  delimiter = "${var.delimiter}"

  # attributes = ["${compact(concat(var.attributes, list("resource-role")))}"]
  attributes = ["${compact(concat(var.attributes, list("resource"), list("role")))}"]
  tags       = "${var.tags}"
}

resource "aws_iam_role" "resource_role" {
  name               = "${module.resource_role_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.resource_role.json}"
}

resource "aws_iam_role_policy_attachment" "resource_role" {
  role       = "${aws_iam_role.resource_role.name}"
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
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.2.1"
  namespace = "${var.namespace}"
  stage     = "${terraform.workspace}"
  name      = "${var.name}"
  delimiter = "${var.delimiter}"

  attributes = ["${compact(concat(var.attributes, list("role")))}"]

  # attributes = ["${compact(concat(var.attributes, list("resource"), list("role")))}"]
  tags = "${var.tags}"
}

resource "aws_iam_role" "role" {
  name               = "${module.role_label.id}"
  assume_role_policy = "${data.aws_iam_policy_document.role.json}"
}

resource "aws_iam_role_policy_attachment" "role" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataPipelineRole"
}

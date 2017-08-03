module "iam_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

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

resource "aws_iam_role" "ec2_role" {
  name               = "efs-backup-ec2-role"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name  = "efs-backup-instance-profile"
  role = "${aws_iam_role.ec2_role.name}"
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

resource "aws_iam_role" "datapipeline_resource" {
  name               = "efs-backup-datapipeline-resource-role"
  assume_role_policy = "${data.aws_iam_policy_document.datapipeline_resource.json}"
}

resource "aws_iam_policy_attachment" "datapipeline_resource" {
  name       = "DataPipelineDefaultResourceRole"
  roles      = ["${aws_iam_role.datapipeline_resource.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforDataPipelineRole"
}

resource "aws_iam_instance_profile" "datapipeline_resource" {
  name  = "efs-backup-datapipeline-resource"
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

resource "aws_iam_role" "datapipeline_role" {
  name               = "efs-backup-datapipeline-role"
  assume_role_policy = "${data.aws_iam_policy_document.datapipeline_role.json}"
}

resource "aws_iam_policy_attachment" "datapipeline_role" {
  name       = "AWSDataPipelineRole"
  roles      = ["${aws_iam_role.datapipeline_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataPipelineRole"
}

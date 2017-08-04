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

resource "aws_iam_role" "ec2" {
  name               = "${module.tf_label.id}-ec2"
  assume_role_policy = "${data.aws_iam_policy_document.ec2.json}"
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${module.tf_label.id}-instance"
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

resource "aws_iam_role" "datapipeline_resource" {
  name               = "${module.tf_label.id}-resource"
  assume_role_policy = "${data.aws_iam_policy_document.datapipeline_resource.json}"
}

resource "aws_iam_policy_attachment" "datapipeline_resource" {
  name       = "${module.tf_label.id}-resource"
  roles      = ["${aws_iam_role.datapipeline_resource.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforDataPipelineRole"
}

resource "aws_iam_instance_profile" "datapipeline_resource" {
  name = "${module.tf_label.id}-resource"
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
  name               = "${module.tf_label.id}-role"
  assume_role_policy = "${data.aws_iam_policy_document.datapipeline_role.json}"
}

resource "aws_iam_policy_attachment" "datapipeline_role" {
  name       = "${module.tf_label.id}-role"
  roles      = ["${aws_iam_role.datapipeline_role.name}"]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSDataPipelineRole"
}

resource "aws_security_group" "datapipeline" {
  tags        = "${module.label.tags}"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "${module.label.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "efs_label" {
  source    = "git::https://github.com/cloudposse/tf_label.git?ref=0.1.0"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}-efs"
}

resource "aws_security_group" "efs" {
  tags        = "${module.label.tags}"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "${module.efs_label.id}"

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"

    security_groups = [
      "${aws_security_group.datapipeline.id}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

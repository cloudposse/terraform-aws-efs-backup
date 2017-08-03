module "sg_label" {
  source    = "github.com/cloudposse/tf_label"
  namespace = "${var.namespace}"
  stage     = "${var.stage}"
  name      = "${var.name}"
}

resource "aws_security_group" "datapipeline" {
  tags        = "${module.sg_label.tags}"
  vpc_id      = "${data.aws_vpc.vpc.id}"
  description = "${module.sg_label.id}-datapipeline-sg"

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

resource "aws_security_group" "efs" {
  tags        = "${module.sg_label.tags}"
  vpc_id      = "${data.aws_vpc.vpc.id}"
  description = "${module.sg_label.id}-efs-sg"

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

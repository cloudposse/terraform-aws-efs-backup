resource "aws_security_group" "datapipeline" {
  tags        = "${module.tf_label.tags}"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "${module.tf_label.id}"

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
  tags        = "${module.tf_label.tags}"
  vpc_id      = "${data.aws_vpc.default.id}"
  description = "${module.tf_label.id}-efs"

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

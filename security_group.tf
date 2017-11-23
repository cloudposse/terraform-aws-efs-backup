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

resource "aws_security_group_rule" "datapipeline_mongo_ingress" {
  count                    = "${var.modify_security_group ? 1 : 0}"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = "${var.security_group_id}"
  to_port                  = 0
  type                     = "ingress"
  source_security_group_id = "${aws_security_group.datapipeline.id}"
}

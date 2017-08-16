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

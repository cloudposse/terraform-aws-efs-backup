# Get object aws_vpc by vpc_id
data "aws_vpc" "default" {
  id = "${var.vpc_id}"
}

# Get all subnets from the VPC
data "aws_subnet_ids" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
}

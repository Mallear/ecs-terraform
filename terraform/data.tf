data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "amazon_linux_ecs" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "aws_iam_role" "service_ecs" {
  name = "AWSServiceRoleForECS"
}

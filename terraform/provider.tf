provider "aws" {
  region = "eu-west-3"

  default_tags {
    tags = local.tags
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>4.0"
    }
  }

  required_version = ">= 1.1.0"
}

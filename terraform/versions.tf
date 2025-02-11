
terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  profile                 = "default"
  region                  = var.aws_region
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
  profile = "builder-profile"
}

terraform {
  backend "s3" {
    profile = "builder-profile"
    region  = "us-east-1"
    bucket  = "miaproject-terraform-state"
    key     = "myproject-test.tfstate"
    acl     = "private"
    encrypt = true
  }
}

module "myproject" {

    source = "../modules/"

    environment = "test"


    vpc = {
    }













}

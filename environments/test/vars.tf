terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    profile = "builder-profile"
    region  = "us-east-1"
    bucket  = "miaproject-terraform-state"
    key     = "myproject-test.tfstate"
    acl     = "private"
    encrypt = true
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-1"
  profile = "builder-profile"
}


module "myproject" {

  source = "../../modules/"

  environment = "test"
  network = {
    cidr = "10.0.0.0/24"
  }

  database = {
    "name"               = "undefined"
    "username"           = "undefined"
    "instance_class"     = "db.t3.small"
    "storage_size"       = "10"
    "multi_az"           = "false"
    "encrypted"          = "false"
    "number_of_replicas" = "1"
  }

  autoscaling = {

    "ami"              = "value"
    "instance_type"    = "t2.micro"
    "desired_capacity" = "1"
    "max_size"         = "1"
    "min_size"         = "1"
  }

}

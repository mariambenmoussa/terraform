variable "environment" {
  description = "Environment definition"
  type        = string
}

//// Defining Network setting ////

variable "network" {
  description = "network settings"
  type        = map(string)
  default = {
    "cidr" = "10.0.0.0/24"
  }
}

# 0 , 1, 2 is refering to the 3 availability zones in an AWS region (a, b, c)

variable "availability_zones" {
  description = "Availability Zones mapping"
  type        = map(string)
  default = {
    "0" = "us-east-1a"
    "1" = "us-east-1b"
    "2" = "us-east-1c"
  }
}

variable "subnets_public" {
  description = "Public Subnets in different AZs"
  type        = map(string)
  default = {
    "0" = "10.0.0.0/28"
    "1" = "10.0.0.16/28"
    "2" = "10.0.0.32/28"
  }
}

variable "subnets_private" {
  description = "Private Subnet in different AZs"
  type        = map(string)
  default = {
    "0" = "10.0.0.48/28"
    "1" = "10.0.0.64/28"
    "2" = "10.0.0.80/28"
  }
}

variable "database" {
  description = "default database settings " #to be overwritten by the settings defined on environment settings 
  type        = map(string)
  sensitive   = true
  default = {
    "name"               = "undefined"
    "username"           = "undefined"
    "instance_class"     = "db.t3.micro"
    "storage_size"       = "10"
    "multi_az"           = "false"
    "encrypted"          = "false"
    "number_of_replicas" = "1"
  }
}

variable "autoscaling" {
  type        = map(string)
  description = "Autoscaling group settings"
  default = {
    "ami"              = "value"
    "instance_type"    = "t2.micro"
    "desired_capacity" = "1"
    "max_size"         = "1"
    "min_size"         = "1"
  }
}
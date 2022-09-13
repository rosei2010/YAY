
variable "region-name" {
description = "name of region"
default = "eu-west-2"
type = string 
}



variable "vpc-cidr" {
description = "the cidr for vpc"
default = "10.0.0.0/16"
type = string 
}


variable "public-subnet-cidr" {
description = "the cidr for public subnet"
default = "10.0.1.0/24"
type = string 
}
# vpc main.tf
variable "vpc_cidr" {
  type    = string
  default = "10.128.0.0/16"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "my_ip" {
  type = string

}
#
# variable "public_subnet" {
#   type = list(any)
#   # default = [for i in range(2, 255, 2) : cidrsubnet("10.123.1.0/16", 8, i)]
#   # default = ["10.123.2.0/24", "10.123.4.0/24"]
# }
#
# variable "private_subnet" {
#   type = list(any)
#   # default = [for i in range(1, 255, 2) : cidrsubnet("10.123.1.0/16", 8, i)]
#   # ["10.123.1.0/24", "10.123.3.0/24"]
#
# }

variable "public_subnet_az" {
  type    = list(any)
  default = ["us-east-1e", "us-east-1d"]
}

variable "private_subnet_az" {
  type    = list(any)
  default = ["us-east-1e", "us-east-1d"]
}


variable "public_subnet_count" {
  type    = number
  default = 2
}

variable "private_subnet_count" {
  type    = number
  default = 2
}

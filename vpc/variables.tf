# vpc main.tf
variable "vpc_cidr" {
  type = string

}
variable "aws_region" {
  type = string

}

variable "public_subnet" {
  type = list(any)
}

variable "private_subnet" {
  type = list(any)

}

variable "public_subnet_az" {
  type = list(any)

}

variable "private_subnet_az" {
  type = list(any)

}


variable "public_subnet_count" {
  type = number

}

variable "private_subnet_count" {
  type = number

}

variable "my_ip" {
  type = string

}

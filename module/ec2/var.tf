variable "ami_id" {
  type    = string
  default = "ami-08e5424edfe926b43"
}
variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ec2_tag" {
  type = string
  default = "ec2"
}

variable "prefix" {
  type = string
}

variable "associate_public_ip_address" {
  type = string
}

variable "subnet_id" {
  type    = list
}
variable "private_subnet_id" {
  type    = list
}

variable "security_group" {
  type = string
}
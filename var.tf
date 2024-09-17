# common varible
variable "project_name" {
  type = string
}

variable "env_type" {
  type = string
}

variable "vpc_tag" {
  type    = string
  default = "rocket-vpc"
}

variable "subnet_tag" {
  type    = string
  default = ""
}

variable "ig_tag" {
  type    = string
  default = "ig"
}

variable "ec2_tag" {
  type    = string
  default = "rocket-ec2"
}

variable "associate_public_ip_address" {
  type    = bool
  default = true
}

variable "ec2_sg_ingress_ports" {
  type = list(number)
}

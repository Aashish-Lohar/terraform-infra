variable "vpc_tag" {
  type = string
  default = "my-vpc"
}

variable "subnet_tag" {
  type = string
  default = "my-subnet"
}

variable "prefix" {
  type = string
}

# variable "users" {
#   type = list(string)
#   default = [ "value" ]
# }
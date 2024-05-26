variable "prefix" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "ec2_sg_ingress_ports" {
  type = list(number)
}
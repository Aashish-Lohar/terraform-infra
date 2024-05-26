resource "aws_security_group" "ec2_sg" {
    name        = "${var.prefix}-sg"
    description = "Allow TLS inbound traffic and all outbound traffic"
    vpc_id      = var.vpc_id
    tags = {
        Name = "${var.prefix}-sg"
    }
    dynamic "ingress" {
      for_each = var.ec2_sg_ingress_ports
      iterator = ports
      content {
        description = "allow ports"
        from_port        = ports.value
        to_port          = ports.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
      }
    }

    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
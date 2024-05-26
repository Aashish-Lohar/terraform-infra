####### ssh key ##########
resource "aws_key_pair" "ec2_ssh_key" {
  key_name   = "${var.prefix}-ssh-key"
  public_key = file("${path.root}/id_rsa.pub")
  }

output "key" {
  value = "${aws_key_pair.ec2_ssh_key.key_name}"
}
####### ec2 public instance ##########
resource "aws_instance" "ec2_normal_host" {
  ami           = "ami-05e00961530ae1b55"
  instance_type = var.instance_type
  associate_public_ip_address = var.associate_public_ip_address
  key_name = aws_key_pair.ec2_ssh_key.key_name
  subnet_id = var.subnet_id[0].id
  vpc_security_group_ids = [ var.security_group ]
  tags = {
    Name = "${var.prefix}-${var.ec2_tag}"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("${path.root}/id_rsa")
    host        = self.public_ip
  }
  provisioner "file" {
    source      = "${path.root}/id_rsa"
    destination = "/home/ubuntu/${self.key_name}.pem"
  }

  provisioner "remote-exec" {
    inline = [
	  "sudo apt-get update -y",
    "sudo chmod +x /home/ubuntu/${self.key_name}.pem"
    ]
  }
  depends_on = [ aws_key_pair.ec2_ssh_key ]
}


####### ec2 private instance ##########
resource "aws_instance" "ec2_private_host" {
  ami           = "ami-05e00961530ae1b55"
  instance_type = var.instance_type
  associate_public_ip_address = false
  key_name = aws_key_pair.ec2_ssh_key.key_name
  subnet_id = var.private_subnet_id[0].id 
  vpc_security_group_ids = [ var.security_group ]
  tags = {
    Name = "${var.prefix}-private-${var.ec2_tag}"
  }

  depends_on = [ aws_key_pair.ec2_ssh_key ]
}

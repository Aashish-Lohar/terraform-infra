####### create vpc ##########
resource "aws_vpc" "engage-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-${var.vpc_tag}"
  }
}

data "aws_availability_zones" "az" {
  state = "available"
}

####### public subnet ##########
resource "aws_subnet" "engage-subnet" {
  count = 2
  vpc_id     = aws_vpc.engage-vpc.id
  cidr_block = cidrsubnet(aws_vpc.engage-vpc.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name = "${var.prefix}-${var.subnet_tag}-${count.index+1}"
  }
}

####### private subnet ##########

resource "aws_subnet" "engage-private-subnet" {
  count = 2
  vpc_id     = aws_vpc.engage-vpc.id
  cidr_block = cidrsubnet(aws_vpc.engage-vpc.cidr_block, 8, 2 + count.index)
  map_public_ip_on_launch = true
  availability_zone = data.aws_availability_zones.az.names[count.index]
  tags = {
    Name = "${var.prefix}-private-${var.subnet_tag}-${count.index+1}"
  }
}

####### Internet Gateway ##########
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.engage-vpc.id

  tags = {
    Name = "${var.prefix}-igw"
  }
}

####### Nat Gateway ##########
resource "aws_nat_gateway" "ngw-1" {
  allocation_id = data.aws_eip.by_tag1.id
  subnet_id     = aws_subnet.engage-subnet[0].id

  tags = {
    Name = "${var.prefix}-ngw-1"
  }
  # depends_on = [aws_internet_gateway.example]
}
resource "aws_nat_gateway" "ngw-2" {
  allocation_id = data.aws_eip.by_tag2.id
  subnet_id     = aws_subnet.engage-subnet[1].id

  tags = {
    Name = "${var.prefix}-ngw-2"
  }
  # depends_on = [aws_internet_gateway.example]
}

####### public route table ##########
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.engage-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.prefix}-rt"
  }
}

####### public route table association ##########
resource "aws_route_table_association" "public_subnet_route_table_association" {
  count = 2
  subnet_id = aws_subnet.engage-subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

####### private route table ##########
resource "aws_route_table" "private_route_table1" {
  vpc_id = aws_vpc.engage-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw-1.id
  }

  tags = {
    Name = "${var.prefix}-rt-1"
  }
}
resource "aws_route_table" "private_route_table2" {
  vpc_id = aws_vpc.engage-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.ngw-2.id
  }
  tags = {
    Name = "${var.prefix}-rt-2"
  }
}
####### private route table association ##########
resource "aws_route_table_association" "private_subnet_rt_association1" {
  subnet_id = aws_subnet.engage-private-subnet[0].id
  route_table_id = aws_route_table.private_route_table1.id
}
resource "aws_route_table_association" "private_subnet_rt_association2" {
  subnet_id = aws_subnet.engage-private-subnet[1].id
  route_table_id = aws_route_table.private_route_table2.id
}
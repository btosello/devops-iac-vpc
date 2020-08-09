provider "aws" {
  version = "~> 2.7"
  region  = "us-east-1"
}

resource "aws_vpc" "MyVPC" {
    cidr_block = var.cidr_vpc
    instance_tenancy = "default"
    enable_dns_support = true
    enable_dns_hostnames = true
  
    tags = {
        Name = "MyVPC"
    }
}

 ################# Subnets #############
resource "aws_subnet" "subnet_public" {
  vpc_id = aws_vpc.MyVPC.id
  cidr_block = var.cidr_subnet
  map_public_ip_on_launch = "true"
  availability_zone = var.availability_zone
  
  tags = {
    Name = "MyVPC-Public-Subnet"
  }
}

 ################# IGW #############
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.MyVPC.id
  tags = {
    Name = "MyVPC-IGW"
  }
}

 ################# Route Table #############
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.MyVPC.id
  
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw.id
  }
  
  tags = {
    Name = "MyVPC-Public-RT"
  }
}

resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}

 ################# Security Group #############
resource "aws_security_group" "myvpc-allow-ssh" {
  name = "myvpc-allow-ssh"
  vpc_id = aws_vpc.MyVPC.id
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "MyVPC-SG-SSH-ALLOW"
  }
}

 ################# EC2-Instance #############
resource "aws_instance" "testInstance" {
  ami           = var.instance_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet_public.id
  vpc_security_group_ids = ["${aws_security_group.myvpc-allow-ssh.id}"]
  key_name = var.key_pair_name
  tags = {
    Name = "My-EC2-Instance-1"
  }
}




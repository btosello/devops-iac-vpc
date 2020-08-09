variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.100.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for the subnet"
  default = "10.100.0.0/24"
}

variable "availability_zone" {
  description = "availability zone to create subnet"
  default = "us-east-1a"
}

variable "instance_ami" {
  default = "ami-0ac80df6eff0e70b5"
}

variable "key_pair_name" {
  default = "rnieva-keypair"
}

variable "instance_type" {
  default = "t2.micro"
}

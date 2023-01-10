variable "ami" {
  default = "amiid"
}
variable "aws_region" {
  default = "aws_region"
}
variable "vpc_cidr" {
  default = "cidr_value"
}
variable "public_subnet_cidr" {
  default = "cidr_value"
}
variable "user" {
  default = "user_of_instance"
}
variable "public_key" {
  default = "$PWD_publickey"
}
variable "private_key" {
  default = "$PWD_privatekey"
}
variable "aws_access_key" {
  default = "aws_access_key"
}
variable "aws_secret_key" {
  default = "aws_secret_key"
}
variable "instance_name" {
  default = "fsrv"
}
variable "instance_type" {
  default = "instance_type"
}
variable "availability_zone" {
  default = "availability_zone"
}
variable "vpc_name" {
  default = "fsrv_vpc"
}
variable "subnet_name" {
  default = "fsrv_subnet"
}
variable "internet_gateway_name" {
  default = "fsrv_gateway"
}
variable "public_route" {
  default = "fsrv_public_rt"
}
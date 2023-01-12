resource "aws_vpc" "Main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = fsrv-vpc
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = fsrv-public
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name = fsrv-igw
  }
}

resource "aws_route_table" "publicroute" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = fsrv-public-rt
  }
}

resource "aws_route_table_association" "pubsubassociation" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.publicroute.id
}

resource "aws_security_group" "security" {
  name        = "fsrv-master-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.Main.id

  ingress {
    description = "TLS from VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 9393
    to_port     = 9393
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "genkey" {
  key_name   = "fsrv-webapp"
  public_key = file(var.public_key)
}

resource "aws_instance" "pub_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.security.id]
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = "fsrv-webapp"
  tags = {
    Name = var.instance_name
  }
  connection {
    agent       = false
    type        = "ssh"
    host        = self.public_ip
    private_key = file(var.private_key)
    user        = var.user
  }
  provisioner "file" {
    source      = "./templates/startup-build.sh"
    destination = "/tmp/startup-build.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "bash /tmp/startup-build.sh"
    ]
  }
}

resource "aws_vpc" "Main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.Main.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = var.subnet_name
  }
}

resource "aws_internet_gateway" "tigw" {
  vpc_id = aws_vpc.Main.id

  tags = {
    Name = var.internet_gateway_name
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.Main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tigw.id
  }

  tags = {
    Name = var.public_route
  }
}

resource "aws_route_table_association" "pubsubassociation" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_security_group" "pubsg" {
  name        = "pubsg"
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

  tags = {
    Name = "PUBLIC SECURITY GROUP"
  }
}

resource "aws_key_pair" "genkey" {
  key_name   = "key-pem"
  public_key = file(var.public_key)
}

resource "aws_instance" "pub_instance" {
  ami                         = var.ami
  instance_type               = var.instance_type
  availability_zone           = var.availability_zone
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.pubsg.id]
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = "key-pem"
  tags = { Name = var.instance_name
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
    destination = "/tmp/init.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "bash /tmp/init.sh"
    ]
  }
}

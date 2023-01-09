resource "aws_vpc" "myvpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"

  tags = {
    Name = "FSRV-VPC"
  }
}

resource "aws_subnet" "pubsub" {
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = "us-east-1a"

  tags = {
    Name = "PUBLIC SUBNET"
  }
}

resource "aws_internet_gateway" "tigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "INTERNET GATEWAY"
  }
}

resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tigw.id
  }

  tags = {
    Name = "PUBLIC ROUTE TABLE"
  }
}

resource "aws_route_table_association" "pubsubassociation" {
  subnet_id      = aws_subnet.pubsub.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_security_group" "pubsg" {
  name        = "pubsg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

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
  instance_type               = "t2.micro"
  availability_zone           = "us-east-1a"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = [aws_security_group.pubsg.id]
  connection          {
    agent            = false
    type             = "ssh"
    host             = self.public_ip 
    private_key      = "${file(var.private_key)}"
    user             = "${var.user}"
  }
  provisioner "file" {
    source      = "~/terraform/awsfsrv/init.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash /tmp/init.sh"
    ]
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt update -y ; sudo apt install git -y",
  #     "sudo apt-get install wget -y",
  #     "wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz",
  #     "sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz",
  #     "export PATH=$PATH:/usr/local/go/bin",
  #     "source .bashrc",
  #     "git clone https://github.com/icyphox/fsrv.git",
  #     "cd fsrv && go build",
  #     "echo -e \"[Unit] \nDescription=This is for fsrv service file \nAfter=network.target \n\n[Service] \nUser=root \nGroup=root \nExecStart=/usr/bin/bash /home/ubuntu/fsrv/fsrv\" > /tmp/fsrv.service",
  #     "sudo mv /tmp/fsrv.service /etc/systemd/system/",
  #     "sudo systemctl daemon-reload",
  #     "sudo systemctl start fsrv.service"
  #   ]
  # }
  # user_data                   = "${file("init.sh")}"
  subnet_id                   = aws_subnet.pubsub.id
#   user_data                   = file("init.sh")
  key_name                    = "key-pem"
  tags = { Name = "FRSV-SERVER"
  }
}

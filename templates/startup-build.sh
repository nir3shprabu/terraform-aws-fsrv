#!/usr/bin/env bash
sudo apt update -y ; sudo apt install git -y
sudo apt-get install wget -y
sudo useradd --system fsrv -d /opt
cd /opt
sudo wget https://go.dev/dl/go1.19.4.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.19.4.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:/opt/fsrv/fsrv 
echo -e "export PATH=\$PATH:/usr/local/go/bin:/opt/fsrv/fsrv " >> ~/.bashrc
source  ~/.bashrc
sudo git clone https://github.com/icyphox/fsrv.git
cd fsrv && sudo /usr/local/go/bin/go build -buildvcs=false
sudo cat << EOF > /tmp/fsrv.service 
[Unit]
Description=
After=network.target

[Service]
User=fsrv
Group=fsrv
WorkingDirectory=/opt/fsrv
ExecStart=/opt/fsrv/fsrv
ExecStartPre=/usr/bin/go build

[Install]
WantedBy=multi-user.target
EOF

sudo chmod +x /tmp/fsrv.service
sudo mv /tmp/fsrv.service /etc/systemd/system/
sudo chown fsrv:fsrv /opt -R
sudo ls -ld /usr/local/go/bin/go
sudo ln -s /usr/local/go/bin/go /usr/bin/go
sudo systemctl daemon-reload
sudo systemctl enable fsrv.service
sudo systemctl start fsrv.service
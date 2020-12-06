#!/bin/bash

# Actions as root
#echo "[TASK MAIN] All action as root"
#sudo sudo -s

# Update hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
10.100.100.10 vm0.surecom ansible
10.100.100.11 vm1.surecom nginx
10.100.100.12 vm2.surecom app
EOF

# Install docker from Docker-ce repository
echo "[TASK 2] Install docker container engine"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant

# Enable docker service
echo "[TASK 3] Enable and start docker service"
sudo systemctl enable docker >/dev/null 2>&1
sudo systemctl start docker

# Enable ssh password authentication
echo "[TASK 4] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl reload sshd

# Update vagrant user's bashrc file
echo "export TERM=xterm" >> /etc/bashrc

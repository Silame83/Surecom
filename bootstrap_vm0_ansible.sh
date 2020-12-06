#!/bin/bash

# Actions as root
#echo "[TASK MAIN] All action as root"
#sudo sudo -s

# Install Ansible and configuration
echo "[TASK 1] Installing Ansible"
sudo apt-get install -y ansible sshpass
cat ~/.ssh/id_rsa.pub | sshpass -p vagrant ssh -o 'StrictHostKeyChecking no' vagrant@10.100.100.11 'cat >> .ssh/authorized_keys'
cat ~/.ssh/id_rsa.pub | sshpass -p vagrant ssh -o 'StrictHostKeyChecking no' vagrant@10.100.100.12 'cat >> .ssh/authorized_keys'

# Run SpringBoot App via Ansible
echo "[TASK 2] Deploy LB and App"
cd $HOME/ansible
ansible-playbook spring-boot-app.yml
ansible-playbook nginx.yml
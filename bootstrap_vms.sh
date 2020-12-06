#!/bin/bash

# Actions as root
echo "[TASK MAIN] All action as root"
sudo sudo -s

# Install python2 and components for preparing ansible action
echo "[TASK 1] Install Python 2.7 and components"
apt-get install -y python2
curl https://bootstrap.pypa.io/get-pip.py --output get-pip.py
python2 get-pip.py
apt-get -y install python3-pip && apt-get -y install sshpass




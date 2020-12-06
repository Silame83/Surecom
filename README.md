Project runs two containers on Vagrant platform such as: NGINX with access log parameter and Spring Boot Application

Features:

Launching consists of two steps:

The first step, Initializing all nodes with parameters by following command: vagrant up

The second step, After some changes in configuration files (adding content of SSH Key from Ansible node to nodes with containers) by command, as: vagrant provision
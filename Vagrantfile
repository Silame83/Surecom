# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['VAGRANT_NO_PARALLEL'] = 'yes'

Vagrant.configure(2) do |config|

  config.vm.provision "shell", path: "bootstrap.sh"

  # Ansible Server
  config.vm.define "VM0" do |ansible|
    ansible.vm.box = "ubuntu/focal64"
    ansible.vm.hostname = "vm0.surecom"
    ansible.vm.network "private_network", ip: "10.100.100.10"
    ansible.vm.provider "virtualbox" do |v|
      v.name = "vm0"
      v.memory = 2048
      v.cpus = 2
      # Prevent VirtualBox from interfering with host audio stack
      v.customize ["modifyvm", :id, "--audio", "none"]
    end
#     ansible.vm.provision "file", source: "~/Projects/Surecom/ansible", destination: "/tmp/ansible"
#     ansible.vm.provision "shell", inline: "mv /tmp/ansible $HOME"
#     ansible.vm.provision "shell", inline: "ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N \"\""
    ansible.vm.provision "shell", path: "bootstrap_vm0_ansible.sh"
  end

  NodeCount = 2

  # VM Nodes
  (1..NodeCount).each do |i|
    config.vm.define "VM#{i}" do |vms|
      vms.vm.box = "ubuntu/focal64"
      vms.vm.hostname = "vm#{i}.surecom"
      vms.vm.network "private_network", ip: "10.100.100.1#{i}"
      vms.vm.provider "virtualbox" do |v|
        v.name = "vm#{i}"
        v.memory = 2048
        v.cpus = 2
        # Prevent VirtualBox from interfering with host audio stack
        v.customize ["modifyvm", :id, "--audio", "none"]
      end
      vms.vm.provision "shell", path: "bootstrap_vms.sh"
#       vms.vm.provision "shell", inline: "ssh-keygen -t rsa -f ~/.ssh/id_rsa -q -N \"\""
#       vms.vm.provision "shell", inline: "cat ~/.ssh/id_rsa.pub | sshpass -p vagrant ssh -o 'StrictHostKeyChecking no' vagrant@10.100.100.10 'cat >> .ssh/authorized_keys'"
    end
  end

end

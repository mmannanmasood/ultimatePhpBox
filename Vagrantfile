# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"
  config.disksize.size = '150GB'
  # box modifications, including memory limits and box name. 
  config.vm.provider "virtualbox" do |vb|
     vb.name = "ultimatePhpBox16"
     vb.memory = 4048
	 vb.cpus = 2
  end
  ## IP to access box
  config.vm.network "private_network", ip: "192.168.33.16"
  config.vm.provision "shell" do |s|
    s.path = "vagrant/bootstrap.sh"
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

  # Enter Your Github API Token Below. 
  # If not entered, you must manually run composer to finish the installation.
  # See http://devdocs.magento.com/guides/v1.0/install-gde/trouble/tshoot_rate-limit.html


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.
  
  # box name.  Any box from vagrant share or a box from a custom URL. 
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

  #config.vm.synced_folder ".", "/vagrant", nfs:false, :mount_options => ["dmode=777","fmode=666"]
  ## Bootstrap script to provision box.  All installation methods can go here.
  config.vm.provision "shell" do |s|
    s.path = "vagrant/bootstrap.sh"
  end
end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant virtual environments for PostGIS users

Vagrant.configure(2) do |config|
  config.vm.box_check_update = true

  config.vm.provider "virtualbox" do |vb, override|
    override.vm.box = "ubuntu/zesty64"
    vb.memory = "2048"
    vb.cpus = 2
  end

  config.vm.provider "hyperv" do |hv, override|
    override.vm.box = "synax/ubuntu-17-10-server"
    hv.memory = "2048"
    hv.cpus = 2
  end

  config.vm.network :forwarded_port, host: 6543, guest: 5432
  config.vm.network "private_network", type: "dhcp"

  scripts = [ "bootstrap.sh" ]
  scripts.each { |script|
    config.vm.provision :shell, privileged: false, :path => "./" << script
  }

end

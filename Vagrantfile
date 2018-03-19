# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant virtual environments for PostGIS users

Vagrant.configure(2) do |config|
  config.vm.box_check_update = true

  config.vm.provider "virtualbox" do |vb, override|
    vb.memory = "2048"
    vb.cpus = 2
    override.vm.box = "ubuntu/zesty64"
    override.vm.network :forwarded_port, host: 6543, guest: 5432
    override.vm.network "private_network", type: "dhcp"
  end

  config.vm.provider "hyperv" do |hv, override|
    hv.memory = "2048"
    hv.cpus = 2
    override.vm.box = "synax/ubuntu-17-10-server"
    # Alternative:
    #override.vm.box = "bento/ubuntu-16.04"
    #override.vm.box_version = "201801.02.0"
    # Windows (Build 16237+) comes with "Default Switch" to allow VMs to NAT host internet (any!) connection
    # https://blogs.technet.microsoft.com/virtualization/2017/07/26/hyper-v-virtual-machine-gallery-and-networking-improvements/
    # Apparently, this is an undocumented workaround to specify Hyper-V network in Vagrantfile.
    override.vm.network "private_network", bridge: "Default Switch"
  end

  scripts = [ "bootstrap.sh" ]
  scripts.each { |script|
    config.vm.provision :shell, privileged: false, :path => "./" << script
  }

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrant virtual environments for PostGIS users

Vagrant.configure(2) do |config|
  config.vm.box_check_update = true

  config.vm.provider "virtualbox" do |vb, override|
    vb.name = "vagrant-postgis"
    vb.memory = "2048"
    vb.cpus = 2
    override.vm.box = "generic/ubuntu1904"
    override.vm.network :forwarded_port, host: 6543, guest: 5432
    override.vm.network "private_network", type: "dhcp"
  end

  config.vm.provider "hyperv" do |hv, override|
    hv.vmname = "vagrant-postgis"
    hv.cpus = 4
    hv.memory = "2048"
    hv.maxmemory = nil
    hv.enable_virtualization_extensions = true
    hv.linked_clone = true
    override.vm.box = "generic/ubuntu1904"
    ### Hyper-V Networking
    # Windows (Build 16237+) comes with "Default Switch" to allow NAT.
    # By default, Vagrant prompts to select available Hyper-V virtual switch.
    # As workaround, try one of the lines below as specify the switch in Vagrantfile.
    override.vm.network "private_network", bridge: "Default Switch"
    #override.vm.network "public_network", bridge: "External Switch"
    ### Hyper-V Shared folder
    # Vagrant will prompt for username/password of your account on the host to
    # use it for the SMB folders. For domain accounts,
    # - may need to specify username and domain e.g. user or user@domain
    # - ensure host is connected to the domain network
    #override.vm.synced_folder ".", "/vagrant"
    config.vm.synced_folder ".", "/vagrant", disabled: true
  end

  scripts = [ "bootstrap.sh" ]
  scripts.each { |script|
    config.vm.provision :shell, privileged: false, :path => "./" << script
  }

end

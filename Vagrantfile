# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  numNodes = 2
  ipAddrPrefix = "192.168.56.10"

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
  end

  config.vm.provision :puppet

  1.upto(numNodes) do |num|
    nodeName = ("node" + num.to_s).to_sym
    config.vm.define nodeName do |node|
      node.vm.box = "precise64"
      node.vm.network :private_network, ip: ipAddrPrefix + num.to_s
      node.vm.provider "virtualbox" do |v|
        v.name = "Couchbase Server Node " + num.to_s
      end
    end
  end
end
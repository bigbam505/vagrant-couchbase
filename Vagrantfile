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
    v.gui = false
    v.customize ["modifyvm", :id, "--memory", 756]
  end

  config.vm.define "mastercouch" do |node|
    node.vm.box = "precise64"
    node.vm.hostname = "mastercouch"
    node.vm.network :private_network, ip: "192.168.56.110"
    node.vm.provider "virtualbox" do |v|
      v.name = "Couchbase master Node"
    end

    node.vm.provision :chef_client do |chef|
      chef.node_name = "mastercouch"
      chef.chef_server_url = "https://api.opscode.com/organizations/bmontague"
      chef.validation_key_path = "~/Dropbox/code/chef-repo/.chef/bmontague-validator.pem"
      chef.validation_client_name = "bmontague-validator"
      chef.add_role("couchbase_master")
      chef.delete_node = true
      chef.delete_client = true
      chef.environment = "development"
    end
  end

=begin
  1.upto(numNodes) do |num|
    nodeName = ("node" + num.to_s).to_sym
    config.vm.define nodeName do |node|
      node.vm.box = "precise64"
      node.vm.hostname = nodeName
      node.vm.network :private_network, ip: ipAddrPrefix + num.to_s
      node.vm.provider "virtualbox" do |v|
        v.name = "Couchbase Server Node " + num.to_s
      end
    end
  end
=end
end

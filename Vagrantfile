# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/xenial64"
  config.vm.hostname = "ansible-vagrant"
  config.ssh.forward_agent = true

  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "tests/test.yml"
    ansible.become = true
    # NOTE: Uncomment the below line for verbose Ansible output
    # ansible.verbose = "v"
    ansible.raw_arguments = ["--extra-vars ran_from_vagrant='true'"]
  end
end

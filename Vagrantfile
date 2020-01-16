
Vagrant.configure("2") do |config|

  config.vm.box = "Ubuntu/xenial64"
  config.vm.network "private_network", ip: "192.168.10.101"
  config.vm.synced_folder "Python_app", "/home/ubuntu/app"
  #config.vm.provision "shell", path: "provision.sh", privileged: false
  config.vm.provision "chef_solo" do |chef|
      chef.arguments = "--chef-license accept"
      chef.add_recipe "python_cookbook::default"
    end


end

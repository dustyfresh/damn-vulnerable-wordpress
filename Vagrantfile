Vagrant.configure("2") do |config|

## VM configuration
	config.vm.box = 'ubuntu/trusty64'
	config.vm.box_url = ''
	config.vm.network 'public_network'
	
    config.vm.define :wordpress do |wordpress|
		wordpress.vm.provider :virtualbox do |v|
			v.name = "damnvulnerablewordpress.dev"
			v.customize ["modifyvm", :id, "--memory", "1024", "--cpus", 4]
		end
		wordpress.vm.network :public_network
		wordpress.vm.hostname = "damnvulnerablewordpress.dev"
		wordpress.vm.provision :shell, :path => "bootstrap.sh"
	end
end

# Survivable Social Network (SSN)

Installation Notes for the Survivable Social Network Project.  

## Social Network Engine (SNE) Development Environment Setup

### Dependencies
- VirtualBox (v4.2.6 or newer)

### Creating the vagrant base box 
The Vagrant box can be created in any directory.  The key files the make Vagrant work correctly are the Vagrantfile and bootstrap.sh.  You will find copies of these files in both the social-network-engine folder and the node-directory folder.  The instructions that follow explain how to create these files from scratch.  In this example, the social-network-engine project will be used

1. Install the vagrant gem

	```
	gem install vagrant
	```
	
2. Download the official Ubuntu 12.04 32-bit Base Box (see http://vagrantbox.es for the most up-to-date link) and install it

	```
	vagrant box add ssn_development http://cloud-images.ubuntu.com/precise/current/precise-server-cloudimg-vagrant-amd64-disk1.box
	```

3. Change to the social-network-engine folder. 

	```
	cd social-network-engine
	```

4. Initialize Vagrant to create a generic Vagrantfile in your directory.

	```
	vagrant init
	```

5. Modify the Vagrantfile to include the following lines

	```
	config.vm.box = "ssn_development" 
	config.vm.forward_port 3000, 3000 
	config.vm.provision :shell, :path => "bootstrap.sh" 
	config.vm.customize["modifyvm", :id, "--memory", 1024] 
	config.vm.customize["modifyvm", :id, "--cpus", 2]		
	```

6. Create bootstrap.sh and add the following lines.  The commands will be run when the Vagrant box is setup.

	```
	#!/usr/bin/env bash

	# Update the system
	apt-get update

	# Install required packages
	apt-get install -y git-core
	apt-get install -y git

	# Install RVM if required
	if [ ! -e /usr/local/rvm/bin/rvm ]
		then
			echo "Installing RVM..."
			curl -L https://get.rvm.io | bash -s stable
			source /etc/profile.d/rvm.sh
			rvm autolibs enable
			rvm install 1.9.3-p385
	fi

	# Load RVM into the shell
	source /etc/profile.d/rvm.sh

	# Switch to the correct ruby version
	rvm use 1.9.3-p385
	```

7. Start the vagrant VM and initialize an SSH session

	```
	vagrant up
	vagrant ssh
	```

### Using the Vagrant development box

1.  Install the Vagrant gem

	```
	gem install vagrant
	```
	
2. Clone the repo and navigate to the social-network-engine folder

	```
	git clone git@github.com:CMU-SSN/SSN.git
	cd social-network-engine
	```	

3. Start the Vagrant VM (this may take some time on the first boot) and initialize an SSH session

	```
	vagrant up
	vagrant ssh
	```

4. Change to the social-network-engine folder on the VM

	```
	cd /vagrant
	```
	
5. Run bundler and install all of the required gems

	```
	bundle install
	```

6. Start the rails server or run any other rails commands as normal

	```
	bundle exec rails server
	```

For more Vagrant commands, see http://www.vagrantup.com.

	
### Shutting down the Vagrant VM

1.  Stop the vagrant VM

	```
	vagrant halt
	```
	
### Deploying to the Production Server

1. Change your directory to social-network-engine

	```
	cd social-network-engine
	```

2. Use Capistrano to deploy to the server

	```
	cap deploy:update
	cap deploy:migrate
	cap deploy:restart
	```

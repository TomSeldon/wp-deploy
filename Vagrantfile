# -*- mode: ruby -*-
# vi: set ft=ruby :

dir = Dir.pwd
vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure("2") do |config|

  # Store the current version of Vagrant for use in conditionals when dealing
  # with possible backward compatible issues.
  vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  # Configurations from 1.0.x can be placed in Vagrant 1.1.x specs like the following.
  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 512]
  end

  # Forward Agent
  #
  # Enable agent forwarding on vagrant ssh commands. This allows you to use identities
  # established on the host machine inside the guest. See the manual for ssh-add
  config.ssh.forward_agent = true

  # Default Ubuntu Box
  #
  # This box is provided by Vagrant at vagrantup.com and is a nicely sized (290MB)
  # box containing the Ubuntu 12.0.4 Precise 32 bit release. Once this box is downloaded
  # to your host computer, it is cached for future use under the specified box name.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.hostname = "wpdeploy.dev"

  # Local Machine Hosts
  #
  # If the Vagrant plugin hostsupdater (https://github.com/cogitatio/vagrant-hostsupdater) is
  # installed, the following will automatically configure your local machine's hosts file to
  # be aware of the domains specified below. Watch the provisioning script as you may be
  # required to enter a password for Vagrant to access your hosts file.
  #
  # By default, we'll include the domains setup by VVV. A short term goal is to read these in
  # from a local config file so that they can be more dynamic to your setup.
  if defined? VagrantPlugins::HostsUpdater
    config.hostsupdater.aliases = [
      "wpdeploy.dev"
    ]
  end

  # Default Box IP Address
  #
  # This is the IP address that your host will communicate to the guest through. In the
  # case of the default `192.168.50.4` that we've provided, Virtualbox will setup another
  # network adapter on your host machine with the IP `192.168.50.1` as a gateway.
  #
  # If you are already on a network using the 192.168.50.x subnet, this should be changed.
  # If you are running more than one VM through Virtualbox, different subnets should be used
  # for those as well. This includes other Vagrant boxes.
  config.vm.network :private_network, ip: "192.168.50.4"

  # Drive mapping
  #
  # The following config.vm.share_folder settings will map directories in your Vagrant
  # virtual machine to directories on your local machine. Once these are mapped, any
  # changes made to the files in these directories will affect both the local and virtual
  # machine versions. Think of it as two different ways to access the same file. When the
  # virtual machine is destroyed with `vagrant destroy`, your files will remain in your local
  # environment.

  # /srv/database/
  #
  # If a database directory exists in the same directory as your Vagrantfile,
  # a mapped directory inside the VM will be created that contains these files.
  # This directory is used to maintain default database scripts as well as backed
  # up mysql dumps (SQL files) that are to be imported automatically on vagrant up
  config.vm.synced_folder "database/", "/srv/database"
  if vagrant_version >= "1.3.0"
    config.vm.synced_folder "database/data/", "/var/lib/mysql", :mount_options => [ "dmode=777", "fmode=777" ]
  else
    config.vm.synced_folder "database/data/", "/var/lib/mysql", :extra => [ "dmode=777", "fmode=777" ]
  end

  # /srv/config/
  #
  # If a server-conf directory exists in the same directory as your Vagrantfile,
  # a mapped directory inside the VM will be created that contains these files.
  # This directory is currently used to maintain various config files for php and
  # nginx as well as any pre-existing database files.
  config.vm.synced_folder "config/", "/srv/config"

  # /srv/config/nginx-config/sites/
  #
  # If a sites directory exists inside the above server-conf directory, it will be
  # added as a mapped directory inside the VM as well. This is used to maintain specific
  # site configuration files for nginx
  # config.vm.synced_folder "config/nginx-config/sites/", "/etc/nginx/custom-sites"

  # /srv/www/
  #
  # If a www directory exists in the same directory as your Vagrantfile, a mapped directory
  # inside the VM will be created that acts as the default location for nginx sites. Put all
  # of your project files here that you want to access through the web server
  if vagrant_version >= "1.3.0"
    config.vm.synced_folder "web/", "/srv/web/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]
  else
    config.vm.synced_folder "web/", "/srv/web/", :owner => "www-data", :extra => [ "dmode=775", "fmode=774" ]
  end

  # Remote provisioning
  #
  # This Vagrantfile is only setup with Digital Ocean as a third-party provider.
  # You must have the `vagrant-digitalocean` plugin installed to use this.
  # See: https://github.com/smdahlen/vagrant-digitalocean
  #
  # If you want to use a different provider, plugins are available for AWS, Rackspace and
  # probably others. Use Google :)
  #
  # You must specify your client ID and a valid API key.
  # If you use the same details across many projects then it might
  # be useful to define these details in your user level Vagrantfile so they act as defaults.
  # ~/.vagrant.d/Vagrantfile
  #
  # See load order notes: http://docs-v1.vagrantup.com/v1/docs/vagrantfile.html
  config.vm.provider :digital_ocean do |provider, override|
    override.ssh.private_key_path = '~/.ssh/id_rsa'
    override.vm.box = 'digital_ocean'
    override.vm.box_url = "https://github.com/smdahlen/vagrant-digitalocean/raw/master/box/digital_ocean.box"

    provider.client_id = 'YOUR CLIENT ID'
    provider.api_key = 'YOUR API KEY'
  end

  # Provisioning
  config.vm.provision :chef_solo do |chef|
    chef.json = {
      :mysql => {
        "dbhost"                => "localhost",
        "database"              => "wordpress",
        "dbuser"                => "wordpress",
        "bind_address"          => "127.0.0.1",
        "allow_remote_root"     => true,
        :server_root_password   => "wordpress",
        :server_repl_password   => "wordpress",
        :server_debian_password => "wordpress"
      }
    }

    chef.add_recipe "apt"
    chef.add_recipe "ohai"
    chef.add_recipe "wpdeploy-configure"
    #chef.add_recipe "tomcat-solr"
  end
end
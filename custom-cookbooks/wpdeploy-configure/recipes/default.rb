# Cookbook name:: wpdeploy-configure
# Recipe:: default
#
# This recipe is heavily derived from Michael Basto's 'configure' cookbook, part of WP Chef.
#
# execute 'DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade'

  [ "build-essential", "apache2", "mysql::server",
    "database", "phpunit", "composer", "vim", "apt", "wpdeploy-wordpress"].each do |r|
    include_recipe r
  end

  # Install Composer dependencies
  execute "composer_update" do
    cwd "/vagrant"
    command "echo 'Installing Composer dependencies...'"
    command "composer update"
  end

  directory "/home/vagrant/bin" do
    owner "vagrant"
    group "vagrant"
    mode 00755
    recursive true
  end

  remote_file "/home/vagrant/bin/vcprompt" do
    source "https://raw.github.com/djl/vcprompt/master/bin/vcprompt"
    ignore_failure true
    action :create_if_missing
    owner "vagrant"
    group "vagrant"
    mode 00755
  end

  cookbook_file "/home/vagrant/.profile" do
    source "bash_profile"
    owner "vagrant"
    group "vagrant"
    mode 00755
  end

  directory "/srv/web/" do
    owner "www-data"
    group "www-data"
    owner 00777
    recursive true
  end

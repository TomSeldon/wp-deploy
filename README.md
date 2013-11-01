WP Deploy
=========

This is designed to be a tool to quickly bootstrap new WordPress projects. It's influenced heavily from existing projects,
including *WP Stack*, *WP Chef* and *Varying Vagrant Vagrants*.

I found that none of these existing projects met my needs, so I created WP Deploy. This is basically an amalgamation of these
other projects, with a few of my own ideas thrown in too. I've tried to keep this project relatively bare so it would be useful
for others, but some aspects are still influenced by my personal workflow. Feel free to clone or fork this project, use it as is
or completely tear it apart to meet your own needs.

If you make a change you think would benefit the project, please make a pull request.

**Basic ingredients:**

* **Composer** to handle dependencies (No git submodules in sight!)
* **Vagrant** for testing locally.
* **Chef** for provisioning the Vagrant VM and remote servers.
* **Librarian** for pulling in Chef cookbook dependencies.
* **Capistrano** for deploying your code to staging and production servers.

Requirements
------------

It's assumed you already have the following tools installed. If you don't, head along to their respective websites for details
on how to get them installed. It's also assumed you already have at least a basic understanding of how these tools work, so if you don't, it's
time to do some reading. ;)

* Composer
* Vagrant (including any plugins for other providers, if necessary)
* Chef
* <del>Capistrano</del> *-- Coming soon --*

Dependency Management
---------------------

Credit to Scott Walkinshaw for details on setting up Composer to work with WordPress (http://roots.io/using-composer-with-wordpress/).

The included `composer.json` sets up a number of things to get you going as quickly as possible, such as including WordPress as a package
and specifying WP Packagist as a repository. It also overrides the install location of plugins and themes to take account of the `wp-content`
directory being within the `web` directory.

However, you'll likely want to edit the specific dependencies to match your project requirements.

I've included some plugins that I use on virtually every project, but feel free to add to and remove from this list as required.

Vagrant
-------

If you've used Vagrant before, you'll know it's as simple as `cd`'ing to the project directory and running `vagrant up`. This will boot up a VM, setup the server
to the specified config settings (see *Chef* settings below) and that's it, you'll have a fully functioning VM running your WordPress project.

The Vagrant file from this project borrows heavily from the setup used by *Varying Vagrant Vagrants (VVV)*, with some significant exceptions:

** Provisioning **
I decided to use Chef instead of Puppet. Also, unlike the setup provided by VVV, I only use one version of WordPress (handled by Composer), not three.

** Remote deployment **
I use Vagrant to develop locally, however periodically I like to test out the site on an actual VPS. If you don't intend to do this, you can skip over this section.

For deploying the site to a VPS, you can use a third-party Vagrant provider. I tend to use Digital Ocean, so this is the only provider setup in the Vagrant file. If
you use another provider, such as Rackspace or AWS, then checkout the *WP Chef* Vagrantfile for examples on how to add this in. If you're going to be deploying
to a remote service, then remember to set the relevant API details in the Vagrant file.

Then, when you're ready to setup up a remote VPS, it's a simple as:

`vagrant up --provider=digital_ocean`

Chef
----

Chef installs the basic web stack: PHP5, Apache and MySQL. This provisioning stage is run by Vagrant after the VM/VPS first boots up.
You can also use Chef to provision your staging and production servers.

<del>
Capistrano -- Coming soon
----------

When you're ready to deploy code to staging or production, the process is incredibly easy using Capistrano. There's already plenty of good documentation
out there on using Capistrano, so I won't repeat it here. Just remember to enter your server details into the config files.
</del>
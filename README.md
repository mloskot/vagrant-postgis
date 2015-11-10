# Vagrant PostGIS

[Vagrant](https://www.vagrantup.com/) configuration to provide users with
virtual environment for hassle-free fun with [PostGIS](http://postgis.net).

Looking for PostGIS development environment? Check Paul Ramsey's Vagrant setup
at https://github.com/pramsey/postgis-vagrant


## Features

* Ubuntu 15.10
* PostgreSQL 9.4 (official packages)
* PostgGIS 2.1.8 (official packages)
* Pre-configured with
  * Port forwarding from host `6543` to guest `5432`.
  * PostgreSQL server with admin and non-admin user.
  * Sample PostgreSQL user `pggis` (password: `pggis`) created.
  * Sample PostgreSQL database `pggis`  created, with PostGIS enabled.

## Requirements

* [VirtualBox](https://www.virtualbox.org/) installed.
* [Vagrant](https://www.vagrantup.com/downloads.html) installed.
* Coffee brewed.
* Music tuned.

## Installation

* `git clone` this repository or [download ZIP](https://github.com/mloskot/vagrant-postgis/archive/master.zip).
* `cd vagrant-postgis`
* Follow the [Usage](#usage) section.

## Usage
  
* `vagrant up` to create and boot the guest virtual machine.
First time run, this may take quite a while as the base box image is downloaded
and provisioned, packages installed.

* `vagrant ssh` to get direct access to the guest shell via SSH.
You'll be connected as the vagrant user.
You can get root access with `sudo` command.

* `vagrant halt` to shutdown the guest machine.

* `vagrant destroy` to wipe out the guest machine completely.
You can re-create it and start over with `vagrant up`.

* `psql -h localhost -p 6543 -d pggis -U pggis` to connect to database from host. Similarly, you can connect using [pgAdmin3](http://www.postgresql.org/ftp/pgadmin3/). 

# Vagrant PostGIS

[Vagrant](https://www.vagrantup.com/) configuration to provide users with
virtual environment for hassle-free fun with [PostGIS](http://postgis.net).

Looking for PostGIS on Windows VM? Check https://github.com/mloskot/vagrant-postgis-windows

Looking for PostGIS development environment? Check Paul Ramsey's Vagrant setup
at https://github.com/pramsey/postgis-vagrant


## Features

* Ubuntu 19/04 (Hyper-V and Virtualbox)
* PostgreSQL 11.5 (official packages)
* PostgGIS 2.5 (official packages)

    ```
    # select postgis_full_version();
    POSTGIS="2.5.1 r17027" [EXTENSION] PGSQL="110" GEOS="3.7.1-CAPI-1.11.1 27a5e771" PROJ="Rel. 5.2.0, September 15th, 2018" GDAL="GDAL 2.4.0, released 2018/12/14" LIBXML="2.9.4" LIBJSON="0.12.1" LIBPROTOBUF="1.3.1" RASTER
    ```
* Pre-configured with
  * Vagrant default user: `vagrant` with password `vagrant`
  * VirtualBox: host port `6543` forwarded to guest port `5432`.
  * Hyper-V: PostgreSQL listens on port `5432` and the host IP (see [Hyper-V Limitations](https://www.vagrantup.com/docs/hyperv/limitations.html))
  * PostgreSQL server with admin and non-admin user.
  * Sample PostgreSQL user `vagrant` (password: `vagrant`) created.
  * Sample PostgreSQL database `vagrant` created, with PostGIS enabled.

## Requirements

* [VirtualBox](https://www.virtualbox.org/) installed or Hyper-V enabled
* [Vagrant](https://www.vagrantup.com/downloads.html) installed.
* Coffee brewed.
* Music tuned.

## Installation

* `git clone` this repository or [download ZIP](https://github.com/mloskot/vagrant-postgis/archive/master.zip).
* `cd vagrant-postgis`
* Follow the [Usage](#usage) section.

## Usage
  
* `vagrant up --provider virtualbox|hyperv` to create and boot the guest virtual machine.
First time run, this may take quite a while as the base box image is downloaded
and provisioned, packages installed.

* `vagrant ssh` to get direct access to the guest shell via SSH.
You'll be connected as the vagrant user.
You can get root access with `sudo` command.

* `vagrant halt` to shutdown the guest machine.

* `vagrant destroy` to wipe out the guest machine completely.
You can re-create it and start over with `vagrant up`.

* `psql -h localhost -p 6543 -d vagrant -U vagrant` to connect to database from host.

## Troubleshooting

### Hyper-V

#### Failed to mount folders in Linux guest

```
C:\vagrant-postgis> vagrant up --provider hyperv
Bringing machine 'default' up with 'hyperv' provider...
==> default: Verifying Hyper-V is enabled...
==> default: Running provisioner: shell...
    ...
    default: Username: mateuszl
    default: Password (will be hidden):

Vagrant requires administator access to create SMB shares and
may request access to complete setup of configured shares.
==> default: Mounting SMB shared folders...
    default: D:/vagrant/vagrant-postgis => /vagrant
Failed to mount folders in Linux guest. This is usually because
the "vboxsf" file system is not available. Please verify that
the guest additions are properly installed in the guest and
can work properly. The command attempted was:

mount -t cifs -o sec=ntlmssp,credentials=/etc/smb_creds_vgt-2ff37f219ada7a863d687d5fd04ef385-6ad5fdbcbf2eaa93bd62f92333a2e6e5,uid=1000,gid=1000 //10.0.151.3/vgt-2ff37f219ada7a863d687d5fd04ef385-6ad5fdbcbf2eaa93bd62f92333a2e6e5 /vagrant

The error output from the last command was:

mount error(5): Input/output error
Refer to the mount.cifs(8) manual page (e.g. man mount.cifs)
```

Simply, `vagrant up` again and it should magically succeed:

```
C:\vagrant-postgis> vagrant up --provider hyperv
Bringing machine 'default' up with 'hyperv' provider...
==> default: Verifying Hyper-V is enabled...
==> default: Running provisioner: shell...
    ...
    default: Bootstrap: DONE
```
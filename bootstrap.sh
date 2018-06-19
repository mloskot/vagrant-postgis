#!/usr/bin/env bash
# Part of Vagrant virtual environments for PostGIS users

# Pre-installation
export PGGIS_USER=pggis
export PGGIS_PASS=pggis
echo "Bootstrap: enabling NOPASSWD in /etc/sudoers in case no /etc/sudoers.d/vagrant or broken"
sudo sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sudo sed -i -e 's/%sudo\s*ALL=(ALL:ALL) ALL/%sudo\tALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
echo "Bootstrap: setting common environment in /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGGIS_USER=${PGGIS_USER}' > /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGGIS_PASS=${PGGIS_PASS}' >> /etc/profile.d/vagrant-postgis.sh"
export DEBIAN_FRONTEND="noninteractive"
# Installation
sudo apt-get update -y -q
sudo apt-get -y -q install \
  postgis \
  postgresql \
  postgresql-contrib
# Post-installation
echo "PostgreSQL: updating /etc/postgresql/9.6/main/postgresql.conf"
sudo cp /etc/postgresql/9.6/main/postgresql.conf /etc/postgresql/9.6/main/postgresql.conf.original
sudo sed -i "s/#listen_address.*/listen_addresses = '*'/" /etc/postgresql/9.6/main/postgresql.conf
echo "Enabled listen_addresses = '*'"
echo "PostgreSQL: updating /etc/postgresql/9.6/main/pg_hba.conf"
sudo cp /etc/postgresql/9.6/main/pg_hba.conf /etc/postgresql/9.6/main/pg_hba.conf.original
sudo sed -i "s/peer$/\ttrust$/" /etc/postgresql/9.6/main/pg_hba.conf
sudo sh -c 'cat >> /etc/postgresql/9.6/main/pg_hba.conf <<EOF
# Accept all IPv4 connections - NOT FOR PRODUCTION
host    all         all         0.0.0.0/0             md5
EOF'
echo "Enabled acccepting all IPv4 connections"
echo "PostgreSQL: creating user ${PGGIS_USER}/${PGGIS_PASS}"
sudo -u postgres psql -c "CREATE ROLE ${PGGIS_USER} WITH LOGIN SUPERUSER CREATEDB ENCRYPTED PASSWORD '${PGGIS_USER}'"
echo "PostgreSQL: creating database ${PGGIS_USER} with PostGIS i"
#sudo -u postgres dropdb --if-exists ${PGGIS_USER}
sudo -u postgres createdb ${PGGIS_USER} --owner=${PGGIS_USER}
sudo -u postgres psql -d ${PGGIS_USER} -c "CREATE EXTENSION postgis;"
echo "PostgreSQL: restarting"
sudo service postgresql restart
echo "PostgreSQL: DONE"
echo "PostgreSQL: to connect to the database server from your host,"
echo "            use the host IP and port 6543"
echo "Guest IP address:"
/sbin/ifconfig | grep 'inet'
echo "Bootstrap: DONE"

#!/usr/bin/env bash
# Part of Vagrant virtual environments for PostGIS users

# Pre-installation
export PGGIS_USER=$USER
export PGGIS_PASS=${PGGIS_USER}
echo "Bootstrap: enabling NOPASSWD in /etc/sudoers in case no /etc/sudoers.d/vagrant or broken"
sudo sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sudo sed -i -e 's/%sudo\s*ALL=(ALL:ALL) ALL/%sudo\tALL=(ALL) NOPASSWD:ALL/g' /etc/sudoers
echo "Bootstrap: setting common environment in /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGGIS_USER=${PGGIS_USER}' > /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGGIS_PASS=${PGGIS_PASS}' >> /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGUSER=${PGGIS_USER}' >> /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGPASSWORD=${PGGIS_PASS}' >> /etc/profile.d/vagrant-postgis.sh"
sudo sh -c "echo 'PGDATABASE=${PGGIS_USER}' >> /etc/profile.d/vagrant-postgis.sh"
export DEBIAN_FRONTEND="noninteractive"
# Installation
sudo apt-get update -y -q
sudo apt-get autoremove -y -q
sudo apt-get -y -qq install \
  postgis \
  postgresql \
  postgresql-contrib
sudo apt-get autoremove -y -q
sudo apt-get autoclean -y -q
sudo apt-get clean -y -q
# Post-installation
echo "PostgreSQL: updating /etc/postgresql/11/main/postgresql.conf"
sudo cp /etc/postgresql/11/main/postgresql.conf /etc/postgresql/11/main/postgresql.conf.original
sudo sed -i "s/#listen_address.*/listen_addresses = '*'/" /etc/postgresql/11/main/postgresql.conf
echo "Enabled listen_addresses = '*'"
echo "PostgreSQL: updating /etc/postgresql/11/main/pg_hba.conf"
sudo cp /etc/postgresql/11/main/pg_hba.conf /etc/postgresql/11/main/pg_hba.conf.original
sudo sed -i "s/peer$/trust/" /etc/postgresql/11/main/pg_hba.conf
sudo sh -c 'cat >> /etc/postgresql/11/main/pg_hba.conf <<EOF
# Accept all IPv4 connections - NOT FOR PRODUCTION
host    all         all         0.0.0.0/0             md5
EOF'
echo "Enabled acccepting all IPv4 connections"
echo "PostgreSQL: creating user ${PGGIS_USER}/${PGGIS_PASS}"
sudo -u postgres psql -c "CREATE ROLE ${PGGIS_USER} WITH LOGIN SUPERUSER CREATEDB ENCRYPTED PASSWORD '${PGGIS_USER}'"
echo "PostgreSQL: creating database ${PGGIS_USER} with PostGIS extension"
#sudo -u postgres dropdb --if-exists ${PGGIS_USER}
sudo -u postgres createdb "${PGGIS_USER}" --owner="${PGGIS_USER}"
sudo -u postgres psql -d "${PGGIS_USER}" -c "CREATE EXTENSION postgis;"
echo "PostgreSQL: restarting"
sudo service postgresql restart
echo "PostgreSQL: DONE"
echo
echo "Bootstrap: PostgreSQL database '${PGGIS_USER}'"
echo "Bootstrap: PostgreSQL username '${PGGIS_USER}'"
echo "Bootstrap: PostgreSQL password '${PGGIS_PASS}'"
echo "Bootstrap: PostgreSQL accepts connections to the VM IP address"
echo "Bootstrap: VM IP address:"
/sbin/ifconfig | grep 'inet'
echo "Bootstrap: DONE"

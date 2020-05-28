#!/bin/bash

echo "Updating all packages..."
yum update -y

echo "Cleaning yum's cache..."
yum clean all

echo "Removing kernel's sources..."
rpm -e `rpm -qa | grep kernel-devel`

echo "Removing RPM packages...(maybe you will want save it for future uses)"
rm -rf /root/rpmbuild/

echo "Installing vagrant default key..."
mkdir -pm 700 /home/vagrant/.ssh
curl -sL https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub -o /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

echo "Removing temporary files..."
rm -rf /tmp/*
rm  -f /var/log/wtmp /var/log/btmp
rm -rf /var/cache/* /usr/share/doc/*
rm -rf /var/cache/yum
rm -rf /home/vagrant/*.iso

echo "Cleaning history..."
rm  -f ~/.bash_history
history -c

echo "Cleaning logs..."
rm -rf /run/log/journal/*

echo "Hack for saving empty space..."
dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
sync


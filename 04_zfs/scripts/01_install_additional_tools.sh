#!/bin/bash



echo "Installing addtion tools"

# Install zfs-kmod
yum install -y yum-utils wget
yum -y install http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
yum-config-manager --enable zfs-kmod
yum-config-manager --disable zfs
yum install -y zfs



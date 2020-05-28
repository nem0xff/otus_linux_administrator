#!/bin/bash

echo "Installing dependences..."
yum install ncurses-devel make gcc bc openssl-devel flex bison elfutils-libelf-devel rpm-build rsync -y

echo "Downloading kernel source..."
cd /usr/src/kernels/
curl -O https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.11.tar.xz && tar -xJf ./linux-5.6.11.tar.xz && cd ./linux-5.6.11

echo "Setup config for kernel commpile..."
curl -o .config $PACKER_HTTP_ADDR/default_centos7_config

echo "Make kernel"
make rpm-pkg -j 28

echo "Removing source..."
rm -rf /usr/src/kernels/*

echo "Installing new kernel and headers..."
rpm -iUh /root/rpmbuild/RPMS/x86_64/*

echo "Setting default kernel for boot..."
grub2-set-default 0

echo "Going to reboot..."
shutdown -r now

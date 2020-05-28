#!/bin/bash

echo "Installing VB Addition Tools..."

echo "Mounting ISO image..."
mount -o loop /home/vagrant/VBoxGuestAdditions.iso /mnt

echo "Running install script"
/mnt/VBoxLinuxAdditions.run

echo "Unmounting ISO image..."
umount /mnt
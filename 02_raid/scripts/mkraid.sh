#!/bin/bash

echo  "Installing addition tools..."
yum install mdadm gdisk -y

echo "Current state..."
lsblk
cat /proc/mdstat

echo "Creating raid on three devices..."
mdadm --create --verbose /dev/md/raid5 --level=5 --raid-devices=3 /dev/sdb /dev/sdc /dev/sdd

echo "Waiting while raid array will be create..."
mdadm --wait /dev/md/raid5

echo "Current state of raid array..."
cat /proc/mdstat

echo "Breaking array..."
mdadm /dev/md/raid5 --fail /dev/sdb
mdadm --detail /dev/md/raid5

echo "Adding disk for recovering..."
mdadm --add /dev/md/raid5 /dev/sde
mdadm --detail /dev/md/raid5

echo "Waiting while raid arrya will be recover..."
mdadm --wait /dev/md/raid5

echo "Removing fail disk..."
mdadm --remove /dev/md/raid5 /dev/sdb
mdadm --detail /dev/md/raid5

echo "Creating mdadm.conf"
#echo "DEVICE partitions" > /etc/mdadm.conf
#mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm.conf
mdadm --verbose --detail --scan > /etc/mdadm.conf


echo "Creating GTP and five partition..."
for i in {1..5} ; do sgdisk -n ${i}:0:+10M /dev/md/raid5 ; done
gdisk -l /dev/md/raid5


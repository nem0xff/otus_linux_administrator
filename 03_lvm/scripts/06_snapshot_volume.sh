#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#Creating twenty files in home folder and after create snapshot and remove half of amount of files.
touch /home/file{1..20}
lvcreate -L 100MB -s -n home_snap /dev/VolGroup00/LogVol_Home
rm -f /home/file{11..20}

#Now we can't umount home folder because it system folder and it will be busy when we will try umount this one.

#umount /home
#lvconvert --merge /dev/VolGroup00/home_snap
#mount /home

#Trying another way
mount -o nouuid /dev/VolGroup00/home_snap /mnt/
cp /mnt/file{11..20} /home/
umount /mnt
lvremove /dev/VolGroup00/home_snap -y 

echo "---List of files---"
ls /home

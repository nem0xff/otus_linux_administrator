#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#Get 1G disks for var
disks=`lsblk | grep -E "1G.+disk" | cut -c -3`

countDisks=`echo $disks | wc -w`

index=0
for disk in $disks
do
        diskArray[$index]=/dev/$disk
        index=$index+1
done

#We need two disks or more.
if [ "$countDisks" -gt 1 ]; then
    #Create volume for /var
    pvcreate ${diskArray[0]} ${diskArray[1]} 
    vgcreate vg_var ${diskArray[0]} ${diskArray[1]} 
    lvcreate -L 950M -m1 -n lv_var vg_var
    mkfs.ext4 /dev/vg_var/lv_var

    #Create volume for /home
    lvcreate -n LogVol_Home -L 2G /dev/VolGroup00
    mkfs.xfs /dev/VolGroup00/LogVol_Home

    #Create mount points
    mkdir /mnt/new_var
    mkdir /mnt/new_home

    #Mount new volumes to mount points
    mount /dev/vg_var/lv_var /mnt/new_var
    mount /dev/VolGroup00/LogVol_Home /mnt/new_home

    #Copy old data to new volumes
    cp -aR /var/* /mnt/new_var
    cp -aR /home/* /mnt/new_home

    #Umounting and removing mount points
    umount /mnt/*
    rm -rf /mnt/*

    #Clear old catalogs
    rm -rf /var/*
    rm -rf /home/*

    #Mount new volumes
    mount /dev/vg_var/lv_var /var
    mount /dev/VolGroup00/LogVol_Home /home

    #Adding new mount points to fstab
    echo "`blkid | grep Home | awk '{print $2}'` /home xfs defaults 0 0" >> /etc/fstab
    echo "`blkid | grep var: | awk '{print $2}'` /var ext4 defaults 0 0" >> /etc/fstab
else
    echo "---"
    echo "Warning: Amount disks is less than needed"
fi


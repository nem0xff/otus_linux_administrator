#!/usr/bin/env bash
# -*- coding: utf-8 -*-

#Get 10G disk
diskForTransfer=/dev/`lsblk | grep 10G | head -c 3`

lvremove /dev/temp_rootfs/temp_rootfs -y
vgremove temp_rootfs
pvremove $diskForTransfer

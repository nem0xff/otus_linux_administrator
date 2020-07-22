#!/bin/bash

#https://drive.google.com/open?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg

echo "Downloading pool"
curl -L "https://docs.google.com/uc?export=download&id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg" > /tmp/zfs_task1.tar.gz

echo "Extracting exported pool"
cd /tmp
tar -xvzf ./zfs_task1.tar.gz

echo "Importing pool"
zpool import -d /tmp/zpoolexport/ otus

echo "Get information about imported pool"
zpool status otus
zpool list otus

zfs list otus -o name,mountpoint,recordsize,compression,checksum




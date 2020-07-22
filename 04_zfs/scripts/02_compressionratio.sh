#!/bin/bash

echo "Creating ZFS pool"

modprobe zfs
zpool create zfstask /dev/sdb

echo "Available compression algorithm: lzjb, gzip, gzip-[1-9], zle, lz4"

echo "Creating fs1, Algorithm: gzip"
zfs create zfstask/fs1
zfs set compression=gzip zfstask/fs1

echo "Creating fs2, Algorithm: lzjb"
zfs create zfstask/fs2
zfs set compression=lzjb zfstask/fs2

echo "Creating fs3, Algorithm: zle"
zfs create zfstask/fs3
zfs set compression=zle zfstask/fs3

echo "Creating fs4, Algorithm: lz4"
zfs create zfstask/fs4
zfs set compression=lz4 zfstask/fs4

echo "Downloading file War_and_Peace.txt"
wget -O /tmp/War_and_Peace_1_2.txt http://vojnaimir.ru/files/book1.txt
wget -O /tmp/War_and_Peace_3_4.txt http://vojnaimir.ru/files/book2.txt

ls -lah /tmp | grep War_and_Peace

echo "Copying file to new filesystems"
cp /tmp/War_and_Peace_1_2.txt /zfstask/fs1
cp /tmp/War_and_Peace_3_4.txt /zfstask/fs1

cp /tmp/War_and_Peace_1_2.txt /zfstask/fs2
cp /tmp/War_and_Peace_3_4.txt /zfstask/fs2

cp /tmp/War_and_Peace_1_2.txt /zfstask/fs3
cp /tmp/War_and_Peace_3_4.txt /zfstask/fs3

cp /tmp/War_and_Peace_1_2.txt /zfstask/fs4
cp /tmp/War_and_Peace_3_4.txt /zfstask/fs4

sync

echo "Show information about zfs filesystems"
zfs list -o name,mountpoint,used,compression,compressratio


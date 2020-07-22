#!/bin/bash

#https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing

echo "Downloading copy of fs"
curl -L "https://docs.google.com/uc?export=download&id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG" > /tmp/otus_task2.file

echo "Recieving fs"
zfs recv otus/task3 < /tmp/otus_task2.file

echo "Finding file and showing content of file"
find /otus/task3/ -name "secret*" -exec cat {} \;


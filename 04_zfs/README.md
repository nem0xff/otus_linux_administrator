Практические навыки работы с ZFS
--------------------------------

Цель: Отрабатываем навыки работы с созданием томов export/import и установкой параметров. Определить алгоритм с наилучшим сжатием. Определить настройки pool’a Найти сообщение от преподавателей Результат: список команд которыми получен результат с их выводами
1. Определить алгоритм с наилучшим сжатием

Зачем:
Отрабатываем навыки работы с созданием томов и установкой параметров. Находим наилучшее сжатие.


Шаги:
- определить какие алгоритмы сжатия поддерживает zfs (gzip gzip-N, zle lzjb, lz4)
- создать 4 файловых системы на каждой применить свой алгоритм сжатия
Для сжатия использовать либо текстовый файл либо группу файлов:
- скачать файл “Война и мир” и расположить на файловой системе
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8
либо скачать файл ядра распаковать и расположить на файловой системе

Результат:
- список команд которыми получен результат с их выводами
- вывод команды из которой видно какой из алгоритмов лучше


2. Определить настройки pool’a

Зачем:
Для переноса дисков между системами используется функция export/import. Отрабатываем навыки работы с файловой системой ZFS

Шаги:
- Загрузить архив с файлами локально.
https://drive.google.com/open?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg
Распаковать.
- С помощью команды zfs import собрать pool ZFS.
- Командами zfs определить настройки
- размер хранилища
- тип pool
- значение recordsize
- какое сжатие используется
- какая контрольная сумма используется
Результат:
- список команд которыми восстановили pool . Желательно с Output команд.
- файл с описанием настроек settings

3. Найти сообщение от преподавателей

Зачем:
для бэкапа используются технологии snapshot. Snapshot можно передавать между хостами и восстанавливать с помощью send/receive. Отрабатываем навыки восстановления snapshot и переноса файла.

Шаги:
- Скопировать файл из удаленной директории. https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing
Файл был получен командой
zfs send otus/storage@task2 > otus_task2.file
- Восстановить файл локально. zfs receive
- Найти зашифрованное сообщение в файле secret_message

Результат:
- список шагов которыми восстанавливали
- зашифрованное сообщение


Задание 1
---------

В первом provision скрипте `01_install_additional_tools.sh` производится установка ZFS.
Само задание выполняется в скрипте `02_compressionratio.sh`
```
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
```
Итоговый вывод скрипта:

```
    zfs: Show information about zfs filesystems
    zfs: NAME         MOUNTPOINT     USED  COMPRESS  RATIO
    zfs: zfstask      /zfstask      11.7M       off  2.55x
    zfs: zfstask/fs1  /zfstask/fs1   606K      gzip  12.85x
    zfs: zfstask/fs2  /zfstask/fs2  1.65M      lzjb  4.52x
    zfs: zfstask/fs3  /zfstask/fs3  7.29M       zle  1.01x
    zfs: zfstask/fs4  /zfstask/fs4  2.07M       lz4  3.60x
```

В итоге можно сделать вывод что сжатие gzip более эффективно при сжатии текста.

Задание №2
----------

Задание выполняется в скрипте `03_import.sh`:

```
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
```
Итоговый вывод:

```
    zfs: Get information about imported pool
    zfs:   pool: otus
    zfs:  state: ONLINE
    zfs:   scan: none requested
    zfs: config:
    zfs:
    zfs:        NAME                        STATE     READ WRITE CKSUM
    zfs:        otus                        ONLINE       0     0     0
    zfs:          mirror-0                  ONLINE       0     0     0
    zfs:            /tmp/zpoolexport/filea  ONLINE       0     0     0
    zfs:            /tmp/zpoolexport/fileb  ONLINE       0     0     0
    zfs:
    zfs: errors: No known data errors
    zfs: NAME   SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
    zfs: otus   480M  5.13M   475M        -         -     1%     1%  1.00x    ONLINE  -
    zfs: NAME  MOUNTPOINT  RECSIZE  COMPRESS   CHECKSUM
    zfs: otus  /otus          128K       zle     sha256
```

Размер: 480M

Тип: mirror

Recordsize: 128k

Алгоритм сжатия: zle

Задание №3
----------

Задание выполняется в скрипте `04_message.sh`:

```
echo "Downloading copy of fs"
curl -L "https://docs.google.com/uc?export=download&id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG" > /tmp/otus_task2.file

echo "Recieving fs"
zfs recv otus/task3 < /tmp/otus_task2.file

echo "Finding file and showing content of file"
find /otus/task3/ -name "secret*" -exec cat {} \;
```

Итоговый вывод:

```
    zfs: Downloading copy of fs
    zfs: Recieving fs
    zfs: Finding file and showing content of file
    zfs: https://github.com/sindresorhus/awesome
```

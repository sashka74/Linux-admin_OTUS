# ZFS

## 1.Определить алгоритм с наилучшим сжатием 

- определить какие алгоритмы сжатия поддерживает zfs (gzip gzip-N, zle lzjb, lz4) 
- создать 4 файловых системы на каждой применить свой алгоритм сжатия 

Для сжатия использовать либо текстовый файл либо группу файлов:
скачать файл “Война и мир” и расположить на файловой системе
wget -O War_and_Peace.txt http://www.gutenberg.org/ebooks/2600.txt.utf-8
либо скачать файл ядра распаковать и расположить на файловой системе 

## Выполнение

__Добавляем официальный репозиторий OpenZFS, согласно версии ОС,в нашем случае centos8__

`#yum install http://download.zfsonlinux.org/epel/zfs-release.el8_0.noarch.rpm`

__Чтобы использовать репозиторий на основе kABI редактируем файл *zfs.repo*__ 
```
# /etc/yum.repos.d/zfs.repo
[zfs]
enabled=1
```
_~~enabled=1~~_\
_enabled=0_
```
[zfs-kmod]
enabled=0
```
_~~enabled=0~~_\
_enabled=1_

__Устанавливаем zfs__
```
#yum install zfs 
```
__Перезагружаем систему__
```
#reboot
```
__Включаем модуль ядра zfs__
```
#modprobe zfs
``` 
__Создаем pool "storage" тип-mirror из двух дисков__
```
#zpool create storage mirror /dev/sdb /dev/sdc
```
__Проверяем созданный pool__
```
#zpool list


NAME    |  SIZE | ALLOC | FREE  | CKPOINT | EXPANDSZ | FRAG | CAP | DEDUP | HEALTH | ALTROOT\
--------|-------|-------|-------|---------|----------|------|-----|-------|--------|---------
storage | 4.50G |  93K  | 4.50G |    -    |    -     |  0%  |  0% | 1.00x | ONLINE |   -
```
__Создаем файловые системы__
```
#zfs create storage/number1
#zfs create storage/number2
#zfs create storage/number3
#zfs create storage/number4
```
__Проверяем файловые системы, которые мы создали__
```
#zfs list

NAME            | USED | AVAIL |  REFER  | MOUNTPOINT
----------------|------|-------|---------|-----------------
storage         | 196K | 4.36G |   28K   |  /storage
storage/number1 |  24K | 4.36G |   24K   |  /storage/number1
storage/number2 |  24K | 4.36G |   24K   |  /storage/number2
storage/number3 |  24K | 4.36G |   24K   |  /storage/number3
storage/number4 |  24K | 4.36G |   24K   |  /storage/number4
```
__Прменяем ~~одинаковое~~ разное сжатие к файловым системам number1-4__
```
#zfs set compression=lzjb storage/number1
#zfs set compression=gzip-9 storage/number2
#zfs set compression=zle storage/number3
#zfs set compression=lz4 storage/number4
```
__Проверяем применилось ли сжатие к файловым системам__
```
#zfs get compression

NAME            | PROPERTY     | VALUE    | SOURCE
--------------- |--------------|----------|---------
storage         |  compression | off      | default
storage/number1 |  compression | lzjb     | local
storage/number2 |  compression | gzip-9   | local
storage/number3 |  compression | zle      | local
storage/number4 |  compression | lz4      | local
```
__Скачиваем архив ядра и распаковываем на файловые системы number1-4__
```
#wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.6.13.tar.xz

#tar -xf linux-5.6.13.tar.xz -C /storage/number1
#tar -xf linux-5.6.13.tar.xz -C /storage/number2
#tar -xf linux-5.6.13.tar.xz -C /storage/number3
#tar -xf linux-5.6.13.tar.xz -C /storage/number4
```
__Проверяем степень сжатия на файловых системах__
```
#zfs get compression,compressratio

NAME            | PROPERTY      |  VALUE  |  SOURCE
----------------|---------------|---------|----------
storage         | compression   | off     |  default
storage         | compressratio | 2.07x   |  -
storage/number1 | compression   | lzjb    |  local
storage/number1 | compressratio | 2.41x   |  -
storage/number2 | compression   | gzip-9  |  local
storage/number2 | compressratio | 4.33x   |  -
storage/number3 | compression   | zle     |  local
storage/number3 | compressratio | 1.08x   |  -
storage/number4 | compression   | lz4     |  local
storage/number4 | compressratio | 2.79x   |  -
```
__Вывод: *Наибольшей степени сжатия данных`(4.33x)` удалось добиться применив gzip-9*.__

## 2.Определить настройки pool’a

- Загрузить архив с файлами локально и распаковать.\
https://drive.google.com/open?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg 
- С помощью команды zfs import собрать pool ZFS.
#### Командами zfs определить настройки:
- размер хранилища
- тип pool
- значение recordsize
- какое сжатие используется
- какая контрольная сумма используется 

## Выполнение
__Скачиваем архив с файлами и распаковываем его__
```
#wget --load-cookies /tmp/cookies.txt "https://drive.google.com/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://drive.google.com/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=FILEID" -O zfs_task1.tar.gz && rm -rf /tmp/cookies.txt

#tar -zxf zfs_task1.tar.gz
```
__Смотрим что мы получили в результате распаковки скаченного архива__
```
#ls

linux-5.6.13.tar.xz           zfs_task1.tar.gz
zfs-release.el8_0.noarch.rpm  zpoolexport
```
__Проверяем pool находящийся в папке "zpoolexport" и узнаем его тип__
```
#zpool import -d zpoolexport/

pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                                 ONLINE
	  mirror-0                           ONLINE
	    /home/vagrant/zpoolexport/filea  ONLINE
	    /home/vagrant/zpoolexport/fileb  ONLINE
```
__Импортируем pool "otus", проверяем появился ли он в списке pool-ов и узнаем его размер__
```
#zpool import otus -d zpoolexport
#zpool list

NAME    |  SIZE  | ALLOC |  FREE | CKPOINT | EXPANDSZ | FRAG | CAP  | DEDUP | HEALTH  ALTROOT
--------|--------|-------|-------|---------|----------|------|------|-------|---------|-------
otus    |   480M | 2.18M |  478M |    -    |     -    |  0%  |   0% | 1.00x | ONLINE  |  -
storage |  4.50G | 1.89G | 2.61G |    -    |     -    |  0%  |  41% | 1.00x | ONLINE  |  -
```
__Узнаем значение recordsize__
```
#zfs get recordsize 

NAME            |  PROPERTY  |  VALUE |   SOURCE
----------------|------------|--------|--------------------
otus            | recordsize | 128K   |  local
otus/hometask2  | recordsize | 128K   |  inherited from otus
storage         | recordsize | 128K   |  default
storage/number1 | recordsize | 128K   |  default
storage/number2 | recordsize | 128K   |  default
storage/number3 | recordsize | 128K   |  default
storage/number4 | recordsize | 128K   |  default
```
__Проверяем какое используется сжатие и контрольная сумма__
```
#zfs get compression,compressratio

NAME            | PROPERTY      | VALUE   |  SOURCE
----------------|---------------|---------|---------------------
otus            | compression   | zle     |  local
otus            | compressratio | 1.00x   |  -
otus/hometask2  | compression   | zle     |  inherited from otus
otus/hometask2  | compressratio | 1.00x   |  -
storage         | compression   | off     |  default
storage         | compressratio | 2.07x   |  -
storage/number1 | compression   | lzjb    |  local
storage/number1 | compressratio | 2.41x   |  -
storage/number2 | compression   | gzip-9  |  local
storage/number2 | compressratio | 4.33x   |  -
storage/number3 | compression   | zle     |  local
storage/number3 | compressratio | 1.08x   |  -
storage/number4 | compression   | lz4     |  local
storage/number4 | compressratio | 2.79x   |  -
```
```
#zfs get checksum

NAME            | PROPERTY | VALUE   |   SOURCE
----------------|----------|---------|----------------------
otus            | checksum | sha256  |   local
otus/hometask2  | checksum | sha256  |   inherited from otus
storage         | checksum |   on    |   default
storage/number1 | checksum |   on    |   default
storage/number2 | checksum |   on    |   default
storage/number3 | checksum |   on    |   default
storage/number4 | checksum |   on    |   default
```
__Вывод:__ 

1. pool otus:
	1. type=mirror-0 
	2. size=480M 
	3. checksum=sha256 
	4. compression=zle 
	5. recordsize=128K
	
## 3.Найти сообщение от преподавателей

- Скопировать файл из удаленной директории.\
https://drive.google.com/file/d/1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG/view?usp=sharing 
- Восстановить его локально. zfs receive\
Найти зашифрованное сообщение в файле secret_message

Файл был получен командой
zfs send otus/storage@task2 > otus_task2.file

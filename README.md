# 01. Kernel
### Utilites & man pages
- man 2 fstat
- mmap
- mprotect

- [Ядро и функции](https://pustovoi.ru/2010/1033)
---
# 02. Disk, RAID
- [Grub 2 supports Linux mdraid volumes natively.](https://unix.stackexchange.com/questions/17481/grub2-raid-boot)
- part-type важен только для MBR разделов. В GPT всегда primary
- [inodes](https://pustovoi.ru/2019/3053)
- http://xgu.ru/wiki/mdadm
---

# 03. LVM

- [LVM Cache](http://man7.org/linux/man-pages/man7/lvmcache.7.html)
- [sysfs](http://man7.org/linux/man-pages/man5/sysfs.5.html#NOTES)
- [inodes](https://pustovoi.ru/2019/3053)
- [LVM Snapshot & Virtualization](https://www.ibm.com/developerworks/ru/library/l-lvm2/)
- [RedHat LVM Administrator Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/logical_volume_manager_administration/index) [RU](https://access.redhat.com/documentation/ru-ru/red_hat_enterprise_linux/5/html/cluster_suite_overview/s1-clvm-overview-cso)
- [как используется дисковое пространство в Linux](https://habr.com/ru/company/flant/blog/354802/)
---

# 04. ZFS

- [zfs Solaris](https://docs.oracle.com/cd/E19253-01/820-0836/)
- [install zfs](https://github.com/openzfs/zfs/wiki/RHEL-and-CentOS)
- RAIDZ
- compression
- dedup
- ARC / L2ARC
- ZIL / SLOG

# 05. NFS,FUSE

- [Red Hat Linux 7.3: Официальное справочное руководство по Red Hat Linux](https://www-uxsup.csx.cam.ac.uk/pub/doc/redhat/redhat7.3/rhl-rg-en-7.3/ch-nfs.html)
- [ФАЙЛ КОНФИГУРАЦИИ / ETC / EXPORTS](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/s1-nfs-server-config-exports#s1-nfs-server-config-exportfs)
- [Linux NFS, FAQ](http://nfs.sourceforge.net/)
- [Oracle® Linux 7Руководство администратора](https://docs.oracle.com/en/operating-systems/oracle-linux/7/admin/ol7-cfgsvr-nfs.html)

# 06. Boot, BIOS, GRUB

/proc/cmdline - строка запуска ядра, конфигурация

### Utilites & man pages
bootparam, mkinitrd

- [initrd](https://en.wikipedia.org/wiki/Initial_ramdisk)

# 07. Systemd
/sbin/init
fork, setsid
В основе systemd лежит cgroups
Systemd-nspawn

### Utilites & man pages
- telinit
- systemd-analyze time, systemd-analyze blame
- man systemd-system.conf
- ulimit
- [setrlimit](http://man7.org/linux/man-pages/man2/setrlimit.2.html)
- [mount](https://www.freedesktop.org/software/systemd/man/systemd.mount.html)
- [timer](https://www.freedesktop.org/software/systemd/man/systemd.timer.html)
- machinectl
- [systemd docs](http://0pointer.de/blog/projects/systemd-docs.html)
- [systemd для системного администратора](https://mega.nz/#F!OdFEnYAK!dpUB6_qA_iKD1yTUa9S1_g?KIsjzQaK)
- [Using systemd features to secure services](https://www.redhat.com/sysadmin/systemd-secure-services)

---
# 09. Package managemen
- RPM
- сборка собственного rpm
- mock
- dnf
- snap
### Utilites & man pages
- [RPM Packaging Guide](https://rpm-packaging-guide.github.io/)
- [RPM PACKAGING GUIDE Red Hat](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html-single/rpm_packaging_guide/index)
- [Сборка RPM - быстрый старт](http://wiki.rosalab.ru/ru/index.php/%D0%A1%D0%B1%D0%BE%D1%80%D0%BA%D0%B0_RPM_-_%D0%B1%D1%8B%D1%81%D1%82%D1%80%D1%8B%D0%B9_%D1%81%D1%82%D0%B0%D1%80%D1%82)
- [Руководство пользователя и разработчика RPM](http://www.opennet.ru/docs/RUS/rpm_guide/)

# 10. Processes
### MAX PROCESS ID

```
cat /proc/sys/kernel/pid_max
echo 32768 > /proc/sys/kernel/pid_max
Max value 4194304
```

### PS

```
ps -A    #Все активные процессы  
ps -A -u username #Все активные процессы конекретного пользователя  
ps -eF #Полный формат вывода  
ps -U root -u root #Все процессы работающие от рута  
ps -fG group_name #Все процессы запущенные от группы  
ps -fp PID #процессы по PID (можно указать пачкой)  
ps -ft tty1 #Процесс запущенный в определенной интерфейсе  
ps -e --forest   #Показать древо процессов  
ps -fL -C httpd  #Вывести все треды конкретного процесса  
ps -eo pid,ppid,user,cmd  #Форматируем вывод  
ps -p 1154 -o pid,ppid,fgroup,ni,lstart,etime  #Форматируем вывод и выводим по PID  
ps -C httpd  #Показываем родителя и дочернии процессы   
```

### PSTREE

```
pstree -a # Вывод с учетом аргументов командной строки  
pstree -c # Разворачиваем дерево еще сильнее
pstree -g # Вывод GID
pstree -n # Сортировка по PID
pstree username # pstree для определенного пользователя
pstree -s PID # pstree для пида, видим только его дерево
```

### LSOF

```
lsof -u username # Все открытые файлы для конкретного пользователя
lsof -i 4 # Все соединение для протокола ipv4
lsof -i TCP:port # Сортировка по протоколу и порту
lsof -p [PID] # Открытые файлы процесса по пиду
lsof -t [file-name] # каким процессом открыт файл
lsof -t /usr/lib/libcom_err.so.2.1   ^^^
lsof +D  /usr/lib/locale  # Посмотреть кто занимает директорию
lsof -i  # Все интернет соединения
lsof -i udp/tcp # Открытые файлы определенного протокола
```

### STRACE

```
strace program_name # Запуск программы с трасировкой
strace program_name -h # Трассировка системных вызовов
strace -p PID # Трассировка процесса по пиду
strace -c -p PID # Суммарная информация по процессу, нужно по наблюдать
strace -i who -h  # Отображение указателя команд во время каждого системного вызова
strace -t who -h  # Вывод времени когда было обращение
strace -T df -h # Вывод времени которое было затрачено на вызовы
strace -e trace=who df -h # Трассировка только определенных системных вызовов
strace -o debug.log who # Вывод всей информации в файл
strace -d who -h # Вывод информации о дебаге самого strace
```

### LTRACE

```
Пингануть яндекс, спрятать в фон и цепляться к нему или к апачу
ltrace -p <PID> # Дебаг уже запущенного процесса
ltrace -p <PID> -f # Дебаг включая дочернии процессы

```

### Kill all zombies

```
(sleep 1 & exec /bin/sleep 5000) &
# Запускаем основной и дочерний процесс, так как основной занят, он не может закрыть дочерний, начинаем использовать gdb
ps -C sleep # смотри кто у нас зомби
gdb
attach PID # Цепляемся к основнуму процессу
call waitpid(PID_zombie,0,0) #Посылаем основному процессу вызов wait
detach
quit
```
# 11. Ansible

- [Динамическое инвентори в Ansible](https://medium.com/@Nklya/%D0%B4%D0%B8%D0%BD%D0%B0%D0%BC%D0%B8%D1%87%D0%B5%D1%81%D0%BA%D0%BE%D0%B5-%D0%B8%D0%BD%D0%B2%D0%B5%D0%BD%D1%82%D0%BE%D1%80%D0%B8-%D0%B2-ansible-9ee880d540d6)
- [User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html)
- [Jinja](https://jinja.palletsprojects.com/en/2.10.x/)

# 12. PAM

- [Основы и настройка PAM](https://www.ibm.com/developerworks/ru/library/l-pam/index.html)
- [The Linux-PAM Guides](http://www.linux-pam.org/Linux-PAM-html/)
- [Как работает PAM](https://www.opennet.ru/base/net/pam_linux.txt.html)
- [pam_script](https://linux.die.net/man/5/pam_script)
- [CAP_SYS_ADMIN](https://lwn.net/Articles/486306/)

### Базовые утилиты для работы с пользователями и правами
```bash
useradd
passwd
usermod
userdel
groupadd
groupdel
groupmod
groups
id
newgrp
gpasswd
chgrp
chown
chmod
```
# 12. SELinux

### Utilites & man pages
sesearch, seinfo, findcon, audit2allow, audit2why, chcon, restorecon, autorelabel, getsebool, setsebool

- SELinux/Tutorials/How does a process get into a certain context

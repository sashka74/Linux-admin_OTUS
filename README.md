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

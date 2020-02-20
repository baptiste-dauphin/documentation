<!-- MarkdownTOC levels="1,2" autolink="true" -->

- [System](#system)
  - [User](#user)
  - [Group](#group)
  - [Apt](#apt)
  - [Performance](#performance)
  - [htop](#htop)
  - [Update-alternatives](#update-alternatives)
  - [Graphic](#graphic)
  - [Shell](#shell)
  - [Process](#process)
  - [File system](#file-system)
  - [Init.d](#initd)
  - [Systemd](#systemd)
  - [Syslog-ng](#syslog-ng)
  - [Journal](#journal)
  - [Iptables](#iptables)
- [Network](#network)
  - [netplan](#netplan)
  - [Netstat](#netstat)
  - [ss](#ss)
  - [TCP Dump](#tcp-dump)
  - [systemd-networkd](#systemd-networkd)
  - [ENI](#eni)
  - [vlan](#vlan)
  - [NAT](#nat)
  - [VPN](#vpn)
  - [Netcat](#netcat)
  - [Internet Exchange Point](#internet-exchange-point)
- [Security](#security)
  - [Gpg](#gpg)
  - [Vault](#vault)
  - [Ssh](#ssh)
  - [OpenSSL](#openssl)
  - [Fail2Ban](#fail2ban)
- [Software](#software)
  - [NTP](#ntp)
  - [Git](#git)
  - [Tmux](#tmux)
  - [Email system](#email-system)
  - [OpenLDAP](#openldap)
  - [Active Directory](#active-directory)
  - [SaltStack](#saltstack)
  - [Apache](#apache)
  - [Nginx](#nginx)
  - [Bind9](#bind9)
  - [Zabbix](#zabbix)
  - [Elastic Search](#elastic-search)
  - [Php-FPM](#php-fpm)
  - [HAProxy](#haproxy)
  - [Java](#java)
  - [Python](#python)
  - [RabbitMQ](#rabbitmq)
  - [Ansible](#ansible)
  - [Node js](#node-js)
  - [Yarn](#yarn)
  - [Varnish](#varnish)
  - [Log Rotate](#log-rotate)
- [Databases](#databases)
  - [MySQL](#mysql)
  - [MySQL - tool](#mysql---tool)
  - [Percona XtraDB Cluster](#percona-xtradb-cluster)
  - [Redis](#redis)
  - [InfluxDB](#influxdb)
- [Hardware](#hardware)
  - [Memory](#memory)
  - [Storage](#storage)
  - [LVM](#lvm)
  - [Listing](#listing)
  - [Monitor](#monitor)
- [Virtualization](#virtualization)
  - [Docker](#docker)
  - [Docker Swarm](#docker-swarm)
- [Kubernetes](#kubernetes)
  - [Context](#context)
  - [Deployment](#deployment)
  - [Pod](#pod)
  - [Service](#service)
  - [ConfigMap](#configmap)
  - [Secrets](#secrets)
  - [RBAC](#rbac)
  - [Ingress](#ingress)
  - [Config extraction](#config-extraction)
  - [Common cmd](#common-cmd)
  - [Helm](#helm)
- [CentOS](#centos)
  - [Iptables](#iptables-1)
  - [OS Version](#os-version)
  - [Yum](#yum)
- [ArchLinux](#archlinux)
  - [File system](#file-system-1)
  - [Grub](#grub)
  - [package manager](#package-manager)
  - [Wi-Fi](#wi-fi)
- [Miscellaneous](#miscellaneous)
  - [Raspberry](#raspberry)
  - [Sublime-text](#sublime-text)
  - [Regex](#regex)
  - [Markdown](#markdown)
  - [Pimp my terminal](#pimp-my-terminal)
  - [xdg-settings / update-alternatives](#xdg-settings--update-alternatives)
- [Definitions](#definitions)

<!-- /MarkdownTOC -->

# System
## User
### Add
```bash
useradd -m -s /bin/bash b.dauphin
-m create home dir
-s shell path
```
### Change password
```bash
echo 'root:toto' | chpasswd
```
or get prompt for changing your current user
passwd
```bash
# prompt...
```
### impersonate
switch to a user (default root)
```bash
su -
su - b.dauphin
```

### sudo
#### Edit
In ordre to edit sudoer file, use the proper tool `visudo`. Because even for `root` the file is `readonly`
```bash
visudo -f /var/tmp/sudoers.new
visudo -f /etc/sudoers
```

#### Checkconfig
```bash
visudo -c  
/etc/sudoers: parsed OK
/etc/sudoers.d/dev: parsed OK

visudo -f /etc/sudoers.d/qwbind-dev -c
/etc/sudoers.d/qwbind-dev: parsed OK
```

## Group
### Add
Add user baptiste to sudoer
```bash
usermod -aG sudo baptiste
usermod -aG wireshark b.dauphin
```

## Apt
### Show available package(s)
```bash
apt update
apt-cache search sendmail
apt-cache search --names-only 'icedtea?'
```

#### Show dependencies for a given package(s)
```bash
apt depends sendmail
```

### Clean cache space in /var/cache/apt/archives/
```bash
apt-get clean
```

## Performance
```bash
htop
nload
```
### Memory information
```bash
free -g
```
#### Sort by memory

To sort by memory usage we can use either __%MEM__ or __RSS__ columns.  
- `RSS` __Resident Set Size__ is a total memory usage in kilobytes
- `%RAM` shows the same information in terms of percent usage of total memory amount __available__.

```bash
ps aux --sort=+rss
ps aux --sort=%mem
```

Empty swap
```bash
swapoff -a && swapon -a
```
## htop
How to read memory usage in htop?
```bash
htop
```
- Hide `user` threads `shift + H`
- Hide `kernel` threads `shift + K`
- close the process tree view `F5`
- then you can sort out the process of your interest by PID and read the RES column
- sort by __MEM%__ by pressing `shift + M`, or `F3` to search in cmd line)




### Get memory physical size

##### Kilobyte
```bash
grep MemTotal /proc/meminfo | awk '{print $2}'
```

##### MegaByte
```bash
grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^1" | bc
```

##### GigaByte
```bash
grep MemTotal /proc/meminfo | awk '{print $2}' | xargs -I {} echo "scale=4; {}/1024^2" | bc
```

### Get number processing units (CPU / cores)
available to the current process (may be less than all online)
```bash
nproc
```

all online
```bash
nproc --all
```
old fashion version
```bash
grep -c ^processor /proc/cpuinfo
```

## Update-alternatives
Default system software (Debian)
```bash
 update-alternatives - maintain symbolic links determining default commands 
 ```

List existing selections and list the one you wanna see
```bash
update-alternatives --get-selections

update-alternatives --list x-www-browser
```

Modify existing selection interactively
```bash
sudo update-alternatives --config x-terminal-emulator
```

Create a new selection
```bash
update-alternatives --install /usr/bin/x-window-manager x-window-manager /usr/bin/i3 20
```

Change default terminal or browser
will prompt you an interactive console to chose among recognized software
```bash
sudo update-alternatives --config x-terminal-emulator

sudo update-alternatives --config x-www-browser
```

## Graphic
* Graphic server (often X11, Xorg, or just X, it's the same software)
* Display Manager (SDDM, lightDM, gnome)
* Windows Manager (i3-wm, gnome)

### Display Manager

#### SDDM - lightweight
Traduit de l'anglais-Simple Desktop Display Manager est un gestionnaire d’affichage pour les systèmes de fenêtrage X11 et Wayland. SDDM a été écrit à partir de zéro en C ++ 11 et supporte la thématisation via QML
```bash
service sddm status
service sddm restart    : restart sddm (to load new monitor)
```

#### Gnome - Nice display for personal laptop

### Windows Manager
#### i3
```bash
update-alternatives --install /usr/bin/x-window-manager x-window-manager /usr/bin/i3 20
```

##### Automatically starting applications on i3 startup

https://i3wm.org/docs/userguide.html#_automatically_starting_applications_on_i3_startup


## Shell
### Stream
#### Redirection
The `>` operator redirects the output usually to a file but it can be to a device. You can also use `>>` to append.
If you don't specify a number then the standard output stream is assumed but you can also redirect errors

* `>`file redirects stdout to file
* `1>` file redirects stdout to file
* `2>` file redirects stderr to file
* `&>`file redirects stdout and stderr to file

/dev/null is the null device it takes any input you want and throws it away. It can be used to suppress any output. 

is there a difference between `> /dev/null 2>&1` and `&> /dev/null` ?
> &> is new in Bash 4, the former is just the traditional way, I am just so used to it (easy to remember)

#### output modification
remove some characters __(__ and __)__ if found
```bash
.. | tr -d '()'
```

### Tar
```bash
tar --help
```

| Command     | meaning                                       |
|:------------|:----------------------------------------------|
| -c          | create   (name your file .tar)                |
| -(c)z       | archive type gzip    (name your file .tar.gz) |
| -(c)j       | archive type bzip2                            |
| -x          | extract                                       |
| -f          | file                                          |
| -v          | verbose                                       |
| -C          | Set dir name to extract files                 |
| --directory | same                                          |

### gunzip
Default, extract file to STOUT  
`-c : write on standard output, keep original files unchanged`
```bash
gunzip -c file.gz > file
```

### grep

### less
Start at the end of a file
+ will run an initial command when the file is opened
G jumps to the end

```bash
less +G app.log
```




### Sed
__Stream editor__

| Cmd | meaning |
-|-
sed -n | silent mode (default behaviour)
sed -n | silent mode. By default print nothing. Use with /p to print interesting cmd
sed -i | agit non pas sur l'input stream mais sur le fichier specifié
sed -f script_file | Take instruction from script

__Example__  
Replace `patern 1` by `patern 2` 
```bash
sed -i 's/patern 1/patern 2/g' /etc/ssh/sshd_config
```
replace `Not after` by *nothing* from the input stream
```bash
... | sed -n 's/ *Not After : *//p'
```
cmd | meaning
-|-
sed '342d' -i ~/.ssh/known_hosts | remove 342th line of file
sed '342,342d' -i ~/.ssh/known_hosts | remove 342th to 342th line, equivalent to precedent cmd
sed -i '1,42d' -i test.sql | remove first 42 lines of test.sql


### Find
common usage
```bash
find . -maxdepth 1 -type l -ls
find /opt -type f -mmin -5 -exec ls -ltr {} +
find /var/log/nginx -type f -name "*access*" -mmin +5 -exec ls -ltr {} +
find . -type f -mmin -5 -print0 | xargs -0 /bin/ls -ltr
```

cmd | meaning
-|-
find -mtime n | last __DATA MODIFICATION__ time (day)
find -atime n | last __ACCESS__ time (day)
find -ctime n | last __STATUS MODIFICATION__ time (day)


"Modify" is the timestamp of the last time the file's content has been mofified. This is often called "mtime".

"Change" is the timestamp of the last time the file's inode has been changed, like by changing permissions, ownership, file name, number of hard links. It's often called "ctime".


list in the current directory, all files last modifed __more__ (+10) than 10 days ago, historical order
list in the current directory, all files last modifed __less__ (-10) than 10 days ago, historical order
```bash
find . -type f -mtime +10 -exec ls -ltr {} +
find . -type f -mtime -10 -exec ls -ltr {} +
```
list files with last modified date of LESS than 5 minutes
```bash
find . -type f -mmin -5 -exec ls -ltr {} +
```

### xargs
xargs reads items from the standard input, delimited by blanks (which can be protected with double or single quotes or a backslash) or newlines, and executes the command (default is /bin/echo) one or more times with any initial-arguments followed by items read from standard input.  Blank  lines  on the standard input are ignored.  

You can defined the name of the received arg (from stdin). In the following example the chosen name is `%`.  

The following example : takes all the .log files and mv them into a directory named 'working_sheet_of_the_day'
```bash
ls *.log | xargs -I % mv % ./working_sheet_of_the_day
```
### Tar
compress
```bash
tar zfcv myfiles.tar.gz /dir1 /dir2 /dir3
```

extract in a given directory
```bash
tar zxvf somefilename.tar.gz or .tgz
tar jxvf somefilename.tar.bz2
tar xf file.tar -C /path/to/directory
```

### Bash
### Every day use
[A pretty good tutorial](https://github.com/jlevy/the-art-of-command-line#everyday-use)

#### Common commands

| Command                     | meaning                                                                                   |
|:----------------------------|:------------------------------------------------------------------------------------------|
| file                        | get meta info about that file                                                             |
| tail -n 15 -f               | print content of file begining by end, for n lines, with keep following new files entries |
| head -n 15                  | print content of a file begining by begining                                              |
| who                         | info about connected users                                                                |
| w                           | same with more info                                                                       |
| wall                        | print on all TTY (for all connected user)                                                 |
| sudo updatedb               | update the local database of the files present in the filesystem                          |
| locate file_name            | Search into this databases                                                                |
| echo app.$(date +%Y_%m_%d)  | print a string based on subshell return                                                   |
| touch app.$(date +%Y_%m_%d) | create empty file named on string based on subshell return                                |
| mkdir app.$(date +%Y_%m_%d) | create directory named on string based on subshell return                                 |
| sh                          | run a 'sh' shell, very old shell                                                          |
| bash                        | run a 'bash' shell, classic shell of debian 7,8,9                                         |
| zsh                         | run a 'zsh' shell, new shell                                                              |
| for i in google.com free.fr wikipedia.de ; do dig $i +short ; done | 

#### Operator
| Operator              | Description                                                          |
|:----------------------|:---------------------------------------------------------------------|
| ! EXPRESSION          | The EXPRESSION is false.                                             |
| -n STRING             | The length of STRING is greater than zero.                           |
| -z STRING             | The lengh of STRING is zero (ie it is empty).                        |
| STRING1 = STRING2     | STRING1 is equal to STRING2                                          |
| STRING1 != STRING2    | STRING1 is not equal to STRING2                                      |
| INTEGER1 -eq INTEGER2 | INTEGER1 is numerically equal to INTEGER2                            |
| INTEGER1 -gt INTEGER2 | INTEGER1 is numerically greater than INTEGER2                        |
| INTEGER1 -lt INTEGER2 | INTEGER1 is numerically less than INTEGER2                           |
| -d FILE               | FILE exists and is a directory.                                      |
| -e FILE               | FILE exists.                                                         |
| -f FILE               | True if file exists AND is a regular file.                           |
| -r FILE               | FILE exists and the read permission is granted.                      |
| -s FILE               | FILE exists and its size is greater than zero (ie. it is not empty). |
| -w FILE               | FILE exists and the write permission is granted.                     |
| -x FILE               | FILE exists and the execute permission is granted.                   |
| -eq 0                 | COMMAND result equal to 0                                            |
| $?                    | last exit code                                                       |
| $#                    | Number of parameters                                                 |
| $@                    | expands to all the parameters                                        |

##### example
```bash
if [ -f /tmp/test.txt ];
  then 
    echo "true";
  else
    echo "false";
fi
```

```bash
$ true && echo howdy!
howdy!

$ false || echo howdy!
howdy!
```

```bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR="$(dirname "$0")"
```

##### For
```bash
for i in `seq 1 6`
do
mysql -h 127.0.0.1 -u user -p password -e "show variables like 'server_id'; select user()"
done
```

#### Bash knowledge
##### Why is $(...) preferred over `...` (backticks)?
`...` is the legacy syntax required by only the very oldest of non-POSIX-compatible bourne-shells. There are several reasons to always prefer the $(...) syntax: 
###### Backslashes (\) inside backticks are handled in a non-obvious manner: 
```
$ echo "`echo \\a`" "$(echo \\a)"
a \a
$ echo "`echo \\\\a`" "$(echo \\\\a)"
\a \\a
# Note that this is true for *single quotes* too!
$ foo=`echo '\\'`; bar=$(echo '\\'); echo "foo is $foo, bar is $bar" 
foo is \, bar is \\
```
###### Nested quoting inside $() is far more convenient.
```
echo "x is $(sed ... <<<"$y")"
```
In this example, the quotes around $y are treated as a pair, because they are inside $(). This is confusing at first glance, because most C programmers would expect the quote before x and the quote before $y to be treated as a pair; but that isn't correct in shells. On the other hand, 
```
echo "x is `sed ... <<<\"$y\"`"
```

###### It makes nesting command substitutions easier. Compare: 
```
x=$(grep "$(dirname "$path")" file)
x=`grep "\`dirname \"$path\"\`" file`
```

### Environment variable
Be very careful to the context of their definition

> set variable to __current shell__
```bash
export http_proxy=http://10.10.10.10:9999
echo $http_proxy
```
should print the value

> set variables only for the __current line execution__
```bash
http_proxy=http://10.10.10.10:9999 wget -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub
echo $http_proxy
```
will return nothing because it doesn't exist anymore  

> Export multiple env var
```bash
export {http,https,ftp}_proxy="http://10.10.10.10:9999"
```
> Useful common usage
```bash
export http_proxy=http://10.10.10.10:9999/
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
```
> __Remove variable__
```bash
unset http_proxy
unset http_proxy unset https_proxy unset HTTP_PROXY unset HTTPS_PROXY unset
```

## Process
### get processes info
debian style
```bash
ps -ef
ps -o pid,user,%mem,command ax
```

RedHat style
```bash
ps aux
```

### Kill etc
```bash
kill default TERM
kill -l list all signals
kill -l 15 get name of signal
kill -s TERM PID 
kill -TERM PID 
kill -15 PID
```

### Shortcut
| shortcut | meaning |
|:---------|:--------|
| ctrl + \ | SIGQUIT |
| ctrl + C | SIGINT  |


### signals list

|Number | Name (short name) | Description Used for|
|-|-|-|
|0 SIGNULL (NULL)  | Null  | Check access to pid |
|1 SIGHUP (HUP)  | Hangup  Terminate |  can be trapped |
|2 SIGINT (INT)  | Interrupt Terminate |  can be trapped |
|3 SIGQUIT (QUIT)  | Quit  Terminate with core dump |  can be trapped |
|9 SIGKILL (KILL)  | Kill  Forced termination |  cannot be trapped |
|15  SIGTERM (TERM)  | Terminate Terminate |  can be trapped |
|24  SIGSTOP (STOP)  | Stop  Pause the process |  cannot be trapped. This is default if signal not provided to kill command. |
|25  SIGTSTP (STP)  | Stop/pause the process |  can be trapped |
|26  SIGCONT (CONT)  | Continue  | Run a stopped process |


```bash
xeyes &
jobs -l
kill -s STOP 3405
jobs -l
kill -s CONT 3405
jobs -l
kill -s TERM 3405
```


list every running process
```bash
ps -ef | grep ssh-agent | awk '{print $2}'
ps -ef | grep ssh-agent | awk '$0=$2'
```

Print only the process IDs of syslogd:
```bash
ps -C syslogd -o pid=
```

Print only the name of PID 42:
```bash
ps -q 42 -o comm=
```

To see every process running as root (real & effective ID) in user format:
```bash
ps -U root -u root u
```

Get PID (process Identifier) of a running process
```bash
pidof iceweasel
pgrep ssh-agent
```

### process substitution
```bash
diff <(cat /etc/passwd) <(cut -f2 /etc/passwd)
```
<(...) is called process substitution.
It converts the output of a command into a file-like object that diff can read from.
While process substitution is not POSIX, it is supported by bash, ksh, and zsh.

### Inter-process communication
User's IPC shared memory, semaphores, and message queues 

```
Type of IPC object. Possible values are:
q -- message queue
m -- shared memory
s -- semaphore
```
```bash
USERNAME=$1

TYPE=$2

ipcs -$TYPE | grep $USERNAME | awk ' { print $2 } ' | xargs -I {} ipcrm -$TYPE {}
ipcs -s | grep zabbix | awk ' { print $2 } ' | xargs -I {} ipcrm -s {}
```

## File system
Unix File types

| Description                         | symbol              |
|:------------------------------------|:--------------------|
| Regular file                        | -                   |
| Directory                           | d                   |
| Special files                       | (5 sub types in it) |
| block file                          | b                   |
| Character device file               | c                   |
| Named pipe file or just a pipe file | p                   |
| Symbolic link file                  | l                   |
| Socket file                         | s                   |

### Show size
```bash
df -h
du -sh --exclude=relative/path/to/uploads --exclude other/path/to/exclude
du -hsx --exclude=/{proc,sys,dev} /*
lsblk
```
### Mount
list physical disk
and then, mount them of your filesystem
```bash
lsblk
fdisk -l
sudo mount /dev/sdb1 /mnt/usb
```

### List read only filesystem
```bash
awk '$4~/(^|,)ro($|,)/' /proc/mounts
```

### Unmount
```bash
umount /mnt
```

you do so, you will get the “umount: /mnt: device is busy.” error as shown below.
```bash
umount /mnt
umount: /mnt: device is busy.
        (In some cases useful info about processes that use
         the device is found by lsof(8) or fuser(1))
```

Use fuser command to find out __which process is accessing the device__ along with the user name.
```bash
fuser -mu /mnt/
/mnt/:                2677c(sathiya)
```

* fuser – command used to identify processes using the files / directories
* -m – specify the directory or block device along with this, which will list all the processes using it.
* 
-u – shows the owner of the process 

You got two choice here.
1. Ask the owner of the process to properly terminate it or
2. You can kill the process with super user privileges and unmount the device.

#### Forcefully umount a busy device

When you cannot wait to properly umount a busy device, use umount -f as shown below.
```bash
umount -f /mnt
```

If it still doesn’t work, lazy unmount should do the trick. Use umount -l as shown below.
```bash
umount -l /mnt
```

### How to 'root a system' after lost root password
When lost remote access to machine.  
Reboot the system  
press `e` to edit grub  
After editing grub, add this at the end of __linux__ line  
` init=/bin/bash`  
> grub config extract
```bash
menuentry 'Debian GNU/Linux, with Linux 4.9.0-8-amd64  {
  load_video
  insmod gzio
  if [ x$grub_platform = xxen ]; then insmod xzio; insmod lzopio; fi
  insmod part_gpt
  insmod ext2
  ...
  ...
  ...
  echo  'Loading Linux 4.9.0-8-amd64 ...'
  linux /vmlinuz-4.9.0-8-amd64 root=/dev/mapper/debian--baptiste--vg-root ro  quiet
  echo  'Loading initial ramdisk ...'
  initrd  /initrd.img-4.9.0-8-amd64
}
```
Change this line
```bash
linux /vmlinuz-4.9.0-8-amd64 root=/dev/mapper/debian--baptiste--vg-root ro quiet
```
into this
```bash
linux /vmlinuz-4.9.0-8-amd64 root=/dev/mapper/debian--baptiste--vg-root rw quiet init=/bin/bash
```


F10 to boot with the current config  
Make writable the root filesystem (useless if you switched 'ro' into 'rw')  
```bash
mount -n -o remount,rw /
```

Make your modifications
```bash
passwd user_you_want_to_modify
# or
vim /etc/iptables/rules.v4
```

to exit the prompt and reboot the computer.
```bash
exec /sbin/init
```


### Check filesystem
```bash
fsck.ext4 /dev/mapper/vg_data-lv_data
e2fsck 1.43.4 (31-Jan-2017)
/dev/mapper/VgData-LvData contient un système de fichiers comportant des erreurs, vérification forcée. 
Passe 1 : vérification des i-noeuds, des blocs et des tailles
Passe 2 : vérification de la structure des répertoires
Passe 3 : vérification de la connectivité des répertoires
Passe 4 : vérification des compteurs de référence
Passe 5 : vérification de l information du sommaire de groupe
```

### symbolic link
#### update an existing
```bash
ln -sfTv /opt/app_$TAG /opt/app_current
```

### Open Files
List open file, filter by deleted  
Very useful when you have incoherence between result of `df -h` and `du -sh /*`  
It may happens that you remove a file, but another process file descriptor is still using it. So, view from the filesystem, space is not released/free
```bash
lsof -nP | grep '(deleted)'
```

## Init.d
Old System control replaced by Systemd since debian 8
aka __SystemV__, aka old fashioned way, prefered by some people due to full control provided by a on __directly modifiable__ bash script located under `/etc/init.d/`
usage
```bash
service rsyslog status
```
> change process management

```bash
vim /etc/init.d/rsyslog
```

## Systemd
Introduced since debian 8  
Based on internal and templated management. The only way to interact with systemd is by modifying __instructions__ (but not directly code) on `service file`.  
The can be located under different directories.  

> Where are Systemd Unit Files Found?

The files that define how systemd will handle a unit can be found in many different locations, each of which have different priorities and implications.

The system’s copy of unit files are generally kept in the /lib/systemd/system directory. When software installs unit files on the system, this is the location where they are placed by default.

Unit files stored here are able to be started and stopped on-demand during a session. This will be the generic, vanilla unit file, often written by the upstream project’s maintainers that should work on any system that deploys systemd in its standard implementation. You should not edit files in this directory. Instead you should override the file, if necessary, using another unit file location which will supersede the file in this location.

If you wish to modify the way that a unit functions, the best location to do so is within the /etc/systemd/system directory. Unit files found in this directory location take precedence over any of the other locations on the filesystem. If you need to modify the system’s copy of a unit file, putting a replacement in this directory is the safest and most flexible way to do this.

If you wish to override only specific directives from the system’s unit file, you can actually provide unit file snippets within a subdirectory. These will append or modify the directives of the system’s copy, allowing you to specify only the options you want to change.

The correct way to do this is to create a directory named after the unit file with .d appended on the end. So for a unit called example.service, a subdirectory called example.service.d could be created. Within this directory a file ending with .conf can be used to override or extend the attributes of the system’s unit file.

There is also a location for run-time unit definitions at /run/systemd/system. Unit files found in this directory have a priority landing between those in /etc/systemd/system and /lib/systemd/system. Files in this location are given less weight than the former location, but more weight than the latter.

The systemd process itself uses this location for dynamically created unit files created at runtime. This directory can be used to change the system’s unit behavior for the duration of the session. All changes made in this directory will be lost when the server is rebooted.

Resume

Location | override/supersede priority (higher takes precedence) | Meaning
-|-|-
/run/systemd/system | 1 | Run-time only, lost after systemd reboot
/etc/systemd/system directory | 2 | SysAdmin maintained
/lib/systemd/system directory | 3 | Packages vendor maintained (apt, rpm, pacman, ...)


#### Usage
```bash
# show all installed unit files
systemctl list-unit-files --type=service

# loaded
systemctl list-units --type=service --state=loaded
# active
systemctl list-units --type=service --state=active
# running
systemctl list-units --type=service --state=running

# show a specific property (service var value)
systemctl show --property=Environment docker
# print all content
systemctl show docker --no-pager | grep proxy
```

## Syslog-ng
syslog-ng is a syslog implementation which can take log messages from sources and forward them to destinations, based on powerful filter directives.  
Note: With `systemd's journal` (journalctl), syslog-ng is `not needed` by most users.

If you wish to use both the journald and syslog-ng files, ensure the following settings are in effect. For systemd-journald, in the `/etc/systemd/journald.conf` file, `Storage=` either set to auto or unset (which defaults to auto) and `ForwardToSyslog=` set to no or unset (defaults to no). For `/etc/syslog-ng/syslog-ng.conf`, you need the following `source` stanza:

```
source src {
  # syslog-ng
  internal();
  # systemd-journald
  system();
};
```

[A very good overview, official doc](https://github.com/syslog-ng/syslog-ng#syslog-ng)
[Still a very good ArchLinux tutorial](https://wiki.archlinux.org/index.php/Syslog-ng)

### syslog-ng and systemd journal
Starting with syslog-ng version 3.6.1 the default `system()` source on Linux systems using systemd uses `journald` as its standard `system()` source.

Typically

- `systemd-journald`
  - stores message from __unit__ that it manages `sshd.service`
  - unit.{service,slice,socket,scope,path,timer,mount,device,swap}

- `syslog-ng`
  - read __INPUT__ message from `systemd-journald`
  - write __OUTPUT__ various files under `/var/log/*`

Examples from default config:
```
log { source(s_src); filter(f_auth); destination(d_auth); };
log { source(s_src); filter(f_cron); destination(d_cron); };
log { source(s_src); filter(f_daemon); destination(d_daemon); };
log { source(s_src); filter(f_kern); destination(d_kern); };
```


## Journal
### Definition
journalctl is a command for viewing logs collected by systemd. The systemd-journald service is responsible for systemd’s log collection, and it retrieves messages from the kernel, systemd services, and other sources.

These logs are gathered in a central location, which makes them easy to review. The log records in the journal are structured and indexed, and as a result journalctl is able to present your log information in a variety of useful formats.

##### Run the journalctl command without any arguments to view all the logs in your journal:
```
journalctl
journalctl -r
```
Each line starts with the date (in the server’s local time), followed by the server’s hostname, the process name, and the message for the log

##### [journalctl]
```bash
journalctl --priority=0..3 --since "12 hours ago"
```


> -u --unit=UNIT
> - --user-unit=UNIT
> --no-pager
> --list-boots
> -b --boot[=ID]
> -e --pager-end
> -f --follow
> -p --priority=RANGE
```
0: emerg
1: alert
2: crit
3: err
4: warning
5: notice
6: info
7: debug
```


#### Paging through Your Logs

##### journalctl pipes its output to the __less__ command
| Key command                    | Action                                                                                                                         |
|:-------------------------------|:-------------------------------------------------------------------------------------------------------------------------------|
| down arrow key, enter, e, or j | Move down one line.                                                                                                            |
| up arrow key, y, or k          | Move up one line.                                                                                                              |
| space bar                      | Move down one page.                                                                                                            |
| b                              | Move up one page.                                                                                                              |
| right arrow key                | Scroll horizontally to the right.                                                                                              |
| left arrow key                 | Scroll horizontally to the left.                                                                                               |
| g                              | Go to the first line.                                                                                                          |
| G                              | Go to the last line.                                                                                                           |
| 10g                            | Go to the 10th line. Enter a different number to go to other lines.                                                            |
| 50p or 50%                     | Go to the line half-way through the output. Enter a different number to go to other percentage positions.                      |
| /search term                   | Search forward from the current position for the search term string.                                                           |
| ?search term                   | Search backward from the current position for the search term string.                                                          |
| n                              | When searching, go to the next occurrence.                                                                                     |
| N                              | When searching, go to the previous occurrence.                                                                                 |
| m<c>                           | Set a mark, which saves your current position. Enter a single character in place of <c> to label the mark with that character. |
| '<c>                           | Return to a mark, where <c> is the single character label for the mark. Note that ' is the single-quote.                       |
| q                              | Quit less                                                                                                                      |

##### View journalctl without PagingPermalink
```
journalctl --no-pager
```
It’s not recommended that you do this without first filtering down the number of logs shown.

##### Show Logs within a Time RangePermalink
```
journalctl --since "2018-08-30 14:10:10"
journalctl --until "2018-09-02 12:05:50"
```

##### Show Logs for a Specific BootPermalink
```
journalctl --list-boots
journalctl -b -2
journalctl -b
```
```
journalctl -u ssh
```
##### View Kernel MessagesPermalink
```
journalctl -k
```

##### Change the Log Output FormatPermalink
| Format Name | Description                                                                |
|:------------|:---------------------------------------------------------------------------|
| short       | The default option, displays logs in the traditional syslog format.        |
| verbose     | Displays all information in the log record structure.                      |
| json        | Displays logs in JSON format, with one log per line.                       |
| json-pretty | Displays logs in JSON format across multiple lines for better readability. |
| cat         | Displays only the message from each log without any other metadata.        |

```
journalctl -o json-pretty
```

### Persist Your LogsPermalink
systemd-journald can be configured to persist your systemd logs on disk, and it also provides controls to manage the total size of your archived logs. These settings are defined in /etc/systemd/journald.conf
To start persisting your logs, uncomment the Storage line in /etc/systemd/journald.conf and set its value to persistent. Your archived logs will be held in /var/log/journal. If this directory does not already exist in your file system, systemd-journald will create it.

#### After updating your journald.conf, load the change:
```
systemctl restart systemd-journald
```

#### Control the Size of Your Logs’ Disk UsagePermalink
The following settings in journald.conf control how large your logs’ size can grow to when persisted on disk:

| Setting           | Description                                                                                                         |
|:------------------|:--------------------------------------------------------------------------------------------------------------------|
| SystemMaxUse      | The total maximum disk space that can be used for your logs.                                                        |
| SystemKeepFree    | The minimum amount of disk space that should be kept free for uses outside of systemd-journald’s logging functions. |
| SystemMaxFileSize | The maximum size of an individual journal file.                                                                     |
| SystemMaxFiles    | The maximum number of journal files that can be kept on disk.                                                       |

systemd-journald will respect both SystemMaxUse and SystemKeepFree, and it will set your journals’ disk usage to meet whichever setting results in a smaller size.

#### To view your default limits, run:
```
journalctl -u systemd-journald

journalctl --disk-usage
journalctl --verify

```

#### Manually Clean Up Archived LogsPermalink
journalctl offers functions for immediately removing archived journals on disk. Run journalctl with the --vacuum-size option to remove archived journal files until the total size of your journals is less than the specified amount. For example, the following command will reduce the size of your journals to 2GiB:
```
journalctl --vacuum-size=2G
```

Run journalctl with the --vacuum-time option to remove archived journal files with dates older than the specified relative time. For example, the following command will remove journals older than one year:
```
journalctl --vacuum-time=1years
```

#### Logger
To write into the journal
```bash
logger -n syslog.baptiste-dauphin.com --rfc3164 --tcp -P 514 -t 'php95.8-fpm' -p local7.error 'php-fpm error test'
logger -n syslog.baptiste-dauphin.com --rfc3164 --udp -P 514 -t 'sshd'        -p local7.info 'sshd error : test '
logger -n syslog.baptiste-dauphin.com --rfc3164 --udp -P 514 -t 'sshd'        -p auth.info 'sshd error : test'

for ((i=0; i < 10; ++i)); do logger -n syslog.baptiste-dauphin.com --rfc3164 --tcp -P 514 -t 'php95.8-fpm' -p local7.error 'php-fpm error test' ; done

salt -C 'G@app:api and G@env:production and G@client:mattrunks' \
cmd.run "for ((i=0; i < 10; ++i)); do logger -n syslog.baptiste-dauphin.com --rfc3164 --tcp -P 514 -t 'php95.8-fpm' -p local7.error 'php-fpm error test' ; done" \
shell=/bin/bash

logger '@cim: {"name1":"value1", "name2":"value2"}'
```


## Iptables
[Some good explanations](https://connect.ed-diamond.com/GNU-Linux-Magazine/GLMFHS-041/Introduction-a-Netfilter-et-iptables)
[ArchLinux iptables good explanations](https://wiki.archlinux.org/index.php/iptables)

#### Show saved rules
```bash
iptables-save
```

#### Save rules
```bash
iptables-save > /etc/iptables/rules.v4 
```
#### Print rules
```bash
iptables -L
iptables -nvL
iptables -nvL INPUT
iptables -nvL OUTPUT
iptables -nvL PREROUTING
```

#### once a rule is apply, it''s immediatly applied !!!
##### The Default linux iptables chain policy is ACCEPT for all INPUT, FORWARD and OUTPUT policies. You can easily change this default policy to DROP with below listed commands.
```bash
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

iptables --policy INPUT DROP
iptables -P chain target [options]     --policy  -P chain target
--append  -A chain   Append to chain
--check   -C chain   Check for the existence of a rule
--delete  -D chain   Delete matching rule from chain
iptables --list     Print rules in human    readable format
iptables --list-rules          Print rules in iptables readable format
iptables -v -L -n
```

#### Range multiport
```bash
iptables -A OUTPUT -d 10.10.10.10/32 -p tcp -m state --state NEW -m tcp --match multiport --dports 4506:10000 -j ACCEPT
```

#### NOTRACK
```bash
iptables -t raw -I PREROUTING -j NOTRACK
iptables -t raw -I OUTPUT -j NOTRACK
```

### LOG
#### on log les paquets drop
```bash
iptables -A INPUT -j LOG --log-prefix "INPUT:DROP:" --log-level 6
iptables -A INPUT -j DROP
iptables -P INPUT DROP

iptables -A OUTPUT -j LOG --log-prefix "OUTPUT:DROP:" --log-level 6
iptables -A OUTPUT -j DROP
iptables -P OUTPUT DROP
```

### add new rules when NOTRACK is set
#### INPUT new rule
you have to temporarily REMOVE log and drop last lines, otherwise, your new line
#### will never be taken !
```bash
iptables -D INPUT -j LOG --log-prefix "INPUT:DROP:" --log-level 6
iptables -D INPUT -j DROP
```

#### add your new rule
```bash
iptables -A INPUT -p udp -m udp --sport 123 -j ACCEPT
```

#### put back logging and dropping
```bash
iptables -A INPUT -j LOG --log-prefix "INPUT:DROP:" --log-level 6
iptables -A INPUT -j DROP
```

### Conntrack
debian 8 and under, get info about connection tracking. Current and max
```bash
cat /proc/sys/net/netfilter/nf_conntrack_count
cat /proc/sys/net/netfilter/nf_conntrack_max
```

debian 9, with a wrapper, easier to use !
```bash
conntrack -L [table] [options] [-z] 
conntrack -G [table] parameters 
conntrack -D [table] parameters 
conntrack -I [table] parameters 
conntrack -U [table] parameters 
conntrack -E [table] [options] 
conntrack -F [table] 
conntrack -C [table] 
conntrack -S
```

# Network
#### Common packages
for those binaries : ifconfig, netstat, rarp, route, ip, dig
```bash
apt install net-tools iproute2 dnsutils
```
#### Command commands
| Command                                                                | meaning                    |
|:-----------------------------------------------------------------------|:---------------------------|
| ip a                                                                   | get IP of the system       |
| ip r                                                                   | get routes of the system   |
| ip route change default via 99.99.99.99 dev ens8 proto dhcp metric 100 | modify default route       |
| ip addr add 88.88.88.88/32 dev ens4                                    | add (failover) IP to a NIC |


## netplan
new ubuntu network manager
```bash
cat /{lib,etc,run}/netplan/*.yaml
```
### Show network connections, listening process
## Netstat
(old way)

| command         | specification                               |
|:----------------|:--------------------------------------------|
| netstat -t      | list tcp connections                        |
| netstat -lt     | list listening tcp socket                   |
| netstat -lu     | list listening udp socket                   |
| netstat -ltu    | list listening udp + tcp socket             |
| netstat -lx     | list listening unix socket                  |
| netstat -ltup   | same as above, with info on process         |
| netstat -ltupn  | p(PID), l(LISTEN), t(tcp), n(Convert names) |
| netstat -ltpa   | all = ESTABLISHED (default) LISTEN          |
| netstat -lapute | classic useful usage                        |
| netstat -salope | same                                        |
| netstat -tupac  | same                                        |

## ss
(new quicker way)

| command    | specification                        |
|:-----------|:-------------------------------------|
| ss -tulipe | more info on listening process       |
| ss tlpn    | print listen tcp socket with process |

```bash
ss -ltpn sport eq 2377
ss -t '( sport = :ssh )'
ss -ltn sport gt 500
ss -ltn sport le 500
```

## TCP Dump
Real time, just see what’s going on, by looking at all interfaces.
```bash
tcpdump -i any -w capturefile.pcap
tcpdump port 80 -w capture_file
tcpdump 'tcp[32:4] = 0x47455420'
tcpdump -n dst host ip
tcpdump -vv -i any port 514
tcpdump -i any -XXXvvv src net 10.0.0.0/8 and dst port 1234 or dst port 4321 | ccze -A
tcpdump -i any port not ssh and port not domain and port not zabbix-agent | ccze -A
```
https://danielmiessler.com/study/tcpdump/

#### UDP dump
```bash
tcpdump -i lo udp port 123 -vv -X
tcpdump -vv -x -X -s 1500 -i any 'port 25' | ccze -A
https://danielmiessler.com/study/tcpdump/#source-destination
tcpflow -c port 443
```

#### List ports a process PID is listening on
```bash
lsof -Pan -p $PID -i
# ss version
ss -l -p -n | grep ",1234,"
```




## systemd-networkd
debian 9 new network management style
```
vim /etc/systemd/network/50-default.network
systemctl status systemd-networkd
systemctl restart systemd-networkd
```

## ENI
old fashioned network management style
## vlan
vlan tagging and route add 
```bash
auto enp61s0f1.3200
iface enp61s0f1.3200 inet static
  address 10.10.10.20/22
  vlan-raw-device enp61s0f1
  post-up ip route add 10.0.0.0/8 via 10.10.10.254

# with package "ifupdown"
auto eth0
    iface eth0 inet static
        address 192.0.2.7/30
        gateway 192.0.2.254
```



## NAT
Activate NAT (Network Address Translation)
```
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
```

## VPN
With OpenVPN  
Run OpenVpn client in background, immune to hangups, with output to a non-tty
```bash
cd /home/baptiste/.openvpn && \
nohup sudo openvpn /home/baptiste/.openvpn/b_dauphin@vpn.domain.com.ovpn
```

## Netcat
Netcat (network catch)
TCP/IP swiss army knife
### Listen
```bash
nc -l 127.0.0.1 -p 80
nc -lvup 514

# listen all ip on tcp port 443
nc -lvtp 443
```
### Check port opening
only for TCP (obviously), UDP is not connected protocol
```bash
nc -znv 10.10.10.10 3306
```

### manually write tcp packet
```
echo '<187>Apr 29 15:26:16 qwarch plop[12458]: baptiste' | nc -u 10.10.10.10 1514
```

## Internet Exchange Point
[FranceIX](https://www.franceix.net/en/technical/france-ix-route-servers/)


# Security
## Gpg
### gpg-agent
Display your public AND private keys from the gpg-agent keyring
```bash
gpg --list-keys
gpg --list-secret-keys
```

[How to generate gpg public/private key pair](https://gitlab.com/help/user/project/repository/gpg_signed_commits/index.md)

## Vault
```bash
vault login -method=ldap username=$USER
```

Will set up a token under `~/.vault-token`

## Ssh
by default `ssh` reads `stdin`. When ssh is run in the background or in a script we need to redirect /dev/null into stdin.  
Here is what we can do.
```bash
ssh    shadows.cs.hut.fi "uname -a" < /dev/null

ssh -n shadows.cs.hut.fi "uname -a"
```

### Test multiple ssh connexion use case
Will generate an output file containing 1 IP / line

```bash
for minion in minion1 minion2 database_dev random_id debian minion3 \
; do ipam $minion | tail -n 1 | awk '{print $1}' \
>> minions.list \
; done
```

Run parallelized `exit` after a test of a ssh connection
```bash
while read minion_ip; do
    (ssh -n $minion_ip exit \
    && echo Success \
    || echo CONNECTION_ERROR) &
done <minions.list

```

> Test sshd config before reloading (avoid fail on restart/reload and cutting our own hand)  
sshd = ssh daemon

```bash
sshd -t
```

Test connection to multiple servers
```bash
for outscale_instance in 10.10.10.1 10.10.10.2 10.10.10.3 10.10.10.4 \
; do ssh $outscale_instance -q exit \
&& echo "$outscale_instance :" connection succeed \
|| echo "$outscale_instance :" connection failed \
; done
10.10.10.1 : connection succeed
10.10.10.2 : connection succeed
10.10.10.3 : connection failed
10.10.10.4 : connection succeed
```

quickly copy your ssh public key to a remote server
```bash
cat ~/.ssh/id_ed25519.pub | ssh pi@192.168.1.41 "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >>  ~/.ssh/authorized_keys"
```

### rsync using ssh
`-a` : archive mode
`-u` : update mode, not full copy
```bash
rsync -au --progress -e "ssh -i path/to/private_key" user@10.10.10.10:~/remote_path /output/path
```


## OpenSSL
### Definitions
| Keywork     | meaning |
|:------------|:--------|
| SSL         |         |
| TLS         |         |
| Private key |         |
| Public key  |         |
| RSA         |         |
| ECDSA       |         |

#### Get info of a certificate from __network__
```bash
openssl s_client -connect www.qwant.com:443 -servername www.qwant.com   < /dev/null | openssl x509 -text
openssl s_client -connect qwant.com:443 -servername qwant.com           < /dev/null | openssl x509 -noout -fingerprint
openssl s_client -connect qwantjunior.fr:443 -servername qwantjunior.fr < /dev/null | openssl x509 -text -noout -dates
```

Useful use case
```bash
openssl x509 --text --noout --in ./dev.bdauphin.io.pem -subject -issuer
```

#### Get info about a certificate from __file__
(.pem)
```bash
openssl x509 --text --noout --in /etc/ssl/private/sub.domain.tld.pem

# debian 7, openssl style
openssl x509 -text -in  /etc/ssl/private/sub.domain.tld.pem
```

#### Test full chain
OpenSSL verify with `-CAfile`
```bash
openssl verify ./dev.bdauphin.io.pem
CN = dev.bdauphin.io.pem
error 20 at 0 depth lookup: unable to get local issuer certificate
error ./dev.bdauphin.io: verification failed

openssl verify -CAfile ./bdauphin.io_intermediate_certificate.pem ./dev.bdauphin.io.pem
./dev.bdauphin.io: OK
```

#### Common usage
Test certificate validation + right adresses
```bash
for certif in * ; do openssl verify -CAfile ../baptiste-dauphin.io_intermediate_certificate.pem $certif ; done
dev.baptiste-dauphin.io.pem: OK
plive.baptiste-dauphin.io.pem: OK
www.baptiste-dauphin.io.pem: OK

for certif in * ; do openssl x509 -in $certif -noout -text | egrep '(Subject|DNS):' ; done
        Subject: CN = dev.baptiste-dauphin.com
                DNS:dev.baptiste-dauphin.com, DNS:dav-dev.baptiste-dauphin.com, DNS:provisionning-dev.baptiste-dauphin.com, DNS:share-dev.baptiste-dauphin.com
        Subject: CN = plive.baptiste-dauphin.com
                DNS:plive.baptiste-dauphin.com, DNS:dav-plive.baptiste-dauphin.com, DNS:provisionning-plive.baptiste-dauphin.com, DNS:share-plive.baptiste-dauphin.com
        Subject: CN = www.baptiste-dauphin.com
                DNS:www.baptiste-dauphin.com, DNS:dav.baptiste-dauphin.com, DNS:provisionning.baptiste-dauphin.com, DNS:share.baptiste-dauphin.com
```

##### openssl s_client all arguments
| args                                             | comments                                                                                                                                                                                                                                                               |
|:-------------------------------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| -host host                                       | use -connect instead                                                                                                                                                                                                                                                   |
| -port port                                       | use -connect instead                                                                                                                                                                                                                                                   |
| -connect host:port                               | who to connect to (default is localhost:4433)                                                                                                                                                                                                                          |
| -verify_hostname host                            | check peer certificate matches "host"                                                                                                                                                                                                                                  |
| -verify_email email                              | check peer certificate matches "email"                                                                                                                                                                                                                                 |
| -verify_ip ipaddr                                | check peer certificate matches "ipaddr"                                                                                                                                                                                                                                |
| -verify arg                                      | turn on peer certificate verification                                                                                                                                                                                                                                  |
| -verify_return_error                             | return verification errors                                                                                                                                                                                                                                             |
| -cert arg                                        | certificate file to use, PEM format assumed                                                                                                                                                                                                                            |
| -certform arg                                    | certificate format (PEM or DER) PEM default                                                                                                                                                                                                                            |
| -key arg                                         | Private key file to use, in cert file if not specified but cert file is.                                                                                                                                                                                               |
| -keyform arg                                     | key format (PEM or DER) PEM default                                                                                                                                                                                                                                    |
| -pass arg                                        | private key file pass phrase source                                                                                                                                                                                                                                    |
| -CApath arg                                      | PEM format directory of CA's                                                                                                                                                                                                                                           |
| -CAfile arg                                      | PEM format file of CA's                                                                                                                                                                                                                                                |
| -trusted_first                                   | Use trusted CA's first when building the trust chain                                                                                                                                                                                                                   |
| -no_alt_chains                                   | only ever use the first certificate chain found                                                                                                                                                                                                                        |
| -reconnect                                       | Drop and re-make the connection with the same Session-ID                                                                                                                                                                                                               |
| -pause                                           | sleep(1) after each read(2) and write(2) system call                                                                                                                                                                                                                   |
| -prexit                                          | print session information even on connection failure                                                                                                                                                                                                                   |
| -showcerts                                       | show all certificates in the chain                                                                                                                                                                                                                                     |
| -debug                                           | extra output                                                                                                                                                                                                                                                           |
| -msg                                             | Show protocol messages                                                                                                                                                                                                                                                 |
| -nbio_test                                       | more ssl protocol testing                                                                                                                                                                                                                                              |
| -state                                           | print the 'ssl' states                                                                                                                                                                                                                                                 |
| -nbio                                            | Run with non-blocking IO                                                                                                                                                                                                                                               |
| -crlf                                            | convert LF from terminal into CRLF                                                                                                                                                                                                                                     |
| -quiet                                           | no s_client output                                                                                                                                                                                                                                                     |
| -ign_eof                                         | ignore input eof (default when -quiet)                                                                                                                                                                                                                                 |
| -no_ign_eof                                      | don't ignore input eof                                                                                                                                                                                                                                                 |
| -psk_identity arg                                | PSK identity                                                                                                                                                                                                                                                           |
| -psk arg                                         | PSK in hex (without 0x)                                                                                                                                                                                                                                                |
| -ssl3                                            | just use SSLv3                                                                                                                                                                                                                                                         |
| -tls1_2                                          | just use TLSv1.2                                                                                                                                                                                                                                                       |
| -tls1_1                                          | just use TLSv1.1                                                                                                                                                                                                                                                       |
| -tls1                                            | just use TLSv1                                                                                                                                                                                                                                                         |
| -dtls1                                           | just use DTLSv1                                                                                                                                                                                                                                                        |
| -fallback_scsv                                   | send TLS_FALLBACK_SCSV                                                                                                                                                                                                                                                 |
| -mtu                                             | set the link layer MTU                                                                                                                                                                                                                                                 |
| -no_tls1_2/-no_tls1_1/-no_tls1/-no_ssl3/-no_ssl2 | turn off that protocol                                                                                                                                                                                                                                                 |
| -bugs                                            | Switch on all SSL implementation bug workarounds                                                                                                                                                                                                                       |
| -cipher                                          | preferred cipher to use, use the 'openssl ciphers' command to see what is available                                                                                                                                                                                    |
| -starttls prot                                   | use the STARTTLS command before starting TLS for those protocols that support it, where 'prot' defines which one to assume. Currently, only "smtp", "pop3", "imap", "ftp", "xmpp", "xmpp-server", "irc", "postgres", "lmtp", "nntp", "sieve" and "ldap" are supported. |
| -xmpphost host                                   | Host to use with "-starttls xmpp[-server]"                                                                                                                                                                                                                             |
| -name host                                       | Hostname to use for "-starttls lmtp" or "-starttls smtp"                                                                                                                                                                                                               |
| -krb5svc arg                                     | Kerberos service name                                                                                                                                                                                                                                                  |
| -engine id                                       | Initialise and use the specified engine -rand file:file:...                                                                                                                                                                                                            |
| -sess_out arg                                    | file to write SSL session to                                                                                                                                                                                                                                           |
| -sess_in arg                                     | file to read SSL session from                                                                                                                                                                                                                                          |
| -servername host                                 | Set TLS extension servername in ClientHello                                                                                                                                                                                                                            |
| -tlsextdebug                                     | hex dump of all TLS extensions received                                                                                                                                                                                                                                |
| -status                                          | request certificate status from server                                                                                                                                                                                                                                 |
| -no_ticket                                       | disable use of RFC4507bis session tickets                                                                                                                                                                                                                              |
| -serverinfo types                                | send empty ClientHello extensions (comma-separated numbers)                                                                                                                                                                                                            |
| -curves arg                                      | Elliptic curves to advertise (colon-separated list)                                                                                                                                                                                                                    |
| -sigalgs arg                                     | Signature algorithms to support (colon-separated list)                                                                                                                                                                                                                 |
| -client_sigalgs arg                              | Signature algorithms to support for client certificate authentication (colon-separated list)                                                                                                                                                                           |
| -nextprotoneg arg                                | enable NPN extension, considering named protocols supported (comma-separated list)                                                                                                                                                                                     |
| -alpn arg                                        | enable ALPN extension, considering named protocols supported (comma-separated list)                                                                                                                                                                                    |
| -legacy_renegotiation                            | enable use of legacy renegotiation (dangerous)                                                                                                                                                                                                                         |
| -use_srtp profiles                               | Offer SRTP key management with a colon-separated profile list                                                                                                                                                                                                          |
| -keymatexport label                              | Export keying material using label                                                                                                                                                                                                                                     |
| -keymatexportlen len                             | Export len bytes of keying material (default 20)                                                                                                                                                                                                                       |


#### get system CA
```bash
ls -l /usr/local/share/ca-certificates
ls -l /etc/ssl/certs/
```
#### refresh system CA after changing files in the folder
```bash
sudo update-ca-certificates
```

### Generate Certificate Signing Request (csr) + the associate private key
Will generates both private key and csr token
#### RSA style (old way)
```bash
openssl req -nodes -newkey rsa:4096 -sha256 -keyout $(SUB.MYDOMAIN.TLD).key -out $(SUB.MYDOMAIN.TLD).csr -subj "/C=FR/ST=France/L=PARIS/O=My Company/CN=$(SUB.MYDOMAIN.TLD)"
```

#### Elliptic Curve (ECDSA) (much more secure, new way)
```bash
# generate private key
openssl ecparam -out $(SUB.MYDOMAIN.TLD).key -name sect571r1 -genkey
# generate csr
openssl req -new -sha256 -key $(SUB.MYDOMAIN.TLD).key -nodes -out $(SUB.MYDOMAIN.TLD).csr -subj "/C=FR/ST=France/L=PARIS/O=My Company/CN=$(SUB.MYDOMAIN.TLD)"
```

You can verify the content of your csr token here :
[DigiCert Tool](https://ssltools.digicert.com/checker/views/csrCheck.jsp)

## Fail2Ban
### Useful commands

print jails
```bash
fail2ban-client status
```

get banned ip and other info about a specific jail
```bash
fail2ban-client status ssh
```

set banip triggers email send
```bash
fail2ban-client set ssh banip 10.10.10.10
```

unbanip
```bash
fail2ban-client set ssh unbanip 10.10.10.10
```

check a specific fail2ban chain
```bash
iptables -nvL f2b-sshd
fail2ban-client get dbpurgeage
fail2ban-client get dbfile
```

__fail2ban will send mail using the MTA (mail transfer agent)__

```bash
grep "mta =" /etc/fail2ban/jail.conf
mta = sendmail
```

### File locations
global __default__ config
* /etc/fail2ban/jail.conf

will be override with this parameters
__Centralized Control__ file
This is here we enable jails

* /etc/fail2ban/jail.local



# Software

## NTP
stands for Network Time Protocol
![GitHub Logo](./src/ntp_stratum.png)

### Client
Debian, Ubuntu, Fedora, CentOS, and most operating system vendors, __don't package NTP into client and server packages separately__. When you install NTP, you've made your computer __both a server, and a client simultaneously.__

### NTP Pool Project
As a client, rather than pointing your servers to static IP addresses, you may want to consider using the NTP pool project. Various people all over the world have donated their stratum 1 and stratum 2 servers to the pool, Microsoft, XMission, and even myself have offered their servers to the project. As such, clients can point their NTP configuration to the pool, which will round robin and load balance which server you will be connecting to.

There are a number of different domains that you can use for the round robin. For example, if you live in the United States, you could use:

* 0.us.pool.ntp.org
* 1.us.pool.ntp.org
* 2.us.pool.ntp.org
* 3.us.pool.ntp.org

There are round robin domains for each continent, minus Antarctica, and for many countries in each of those continents. There are also round robin servers for projects, such as Ubuntu and Debian:

* 0.debian.pool.ntp.org
* 1.debian.pool.ntp.org
* 2.debian.pool.ntp.org
* 3.debian.pool.ntp.org


On my public NTP stratum 2 server, I run the following command to see its status:

```bash
ntpq -pn
    remote            refid      st t when poll reach   delay   offset  jitter

------------------------------------------------------------------------------
*198.60.22.240   .GPS.            1 u  912 1024  377    0.488   -0.016   0.098
+199.104.120.73  .GPS.            1 u   88 1024  377    0.966    0.014   1.379
-155.98.64.225   .GPS.            1 u   74 1024  377    2.782    0.296   0.158
-137.190.2.4     .GPS.            1 u 1020 1024  377    5.248    0.194   0.371
-131.188.3.221   .DCFp.           1 u  952 1024  377  147.806   -3.160   0.198
-217.34.142.19   .LFa.            1 u  885 1024  377  161.499   -8.044   5.839
-184.22.153.11   .WWVB.           1 u  167 1024  377   65.175   -8.151   0.131
+216.218.192.202 .CDMA.           1 u   66 1024  377   39.293    0.003   0.121
-64.147.116.229  .ACTS.           1 u   62 1024  377   16.606    4.206   0.216
```

We need to understand each of the columns, so we understand what this is saying:

| Column | Meaning                                                                                                                                                                                                                                 |
|:-------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| remote | The remote server you wish to synchronize your clock with                                                                                                                                                                               |
| refid  | The upstream stratum to the remote server. For stratum 1 servers, this will be the stratum 0 source.                                                                                                                                    |
| st     | The stratum level, 0 through 16.                                                                                                                                                                                                        |
| t      | The type of connection. Can be "u" for unicast or manycast, "b" for broadcast or multicast, "l" for local reference clock, "s" for symmetric peer, "A" for a manycast server, "B" for a broadcast server, or "M" for a multicast server |
| when   | The last time when the server was queried for the time. Default is seconds, or "m" will be displayed for minutes, "h" for hours and "d" for days.                                                                                       |
| poll   | How often the server is queried for the time, with a minimum of 16 seconds to a maximum of 36 hours. It's also displayed as a value from a power of two. Typically, it's between 64 seconds and 1024 seconds.                           |
| reach  | This is an 8-bit left shift octal value that shows the success and failure rate of communicating with the remote server. Success means the bit is set, failure means the bit is not set. 377 is the highest value.                      |
| delay  | This value is displayed in milliseconds, and shows the round trip time (RTT) of your computer communicating with the remote server.                                                                                                     |
| offset | This value is displayed in milliseconds, using root mean squares, and shows how far off your clock is from the reported time the server gave you. It can be positive or negative.                                                       |
| jitter | This number is an absolute value in milliseconds, showing the root mean squared deviation of your offsets.                                                                                                                              |


Next to the remote server, you'll notice a single character. This character is referred to as the "tally code", and indicates whether or not NTP is or will be using that remote server in order to synchronize your clock. Here are the possible values:

| __remote single character__ | Meaning                                                                                                                                                                                                                                             |
|:----------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| __whitespace__              | Discarded as not valid. Could be that you cannot communicate with the remote machine (it's not online), this time source is a ".LOCL." refid time source, it's a high stratum server, or the remote server is using this computer as an NTP server. |
| __x__                       | Discarded by the intersection algorithm.                                                                                                                                                                                                            |
| __.__                       | Discarded by table overflow (not used).                                                                                                                                                                                                             |
| __-__                       | Discarded by the cluster algorithm.                                                                                                                                                                                                                 |
| __+__                       | Included in the combine algorithm. This is a good candidate if the current server we are synchronizing with is discarded for any reason.                                                                                                            |
| __#__                       | Good remote server to be used as an alternative backup. This is only shown if you have more than 10 remote servers.                                                                                                                                 |
| __*__                       | The current system peer. The computer is using this remote server as its time source to synchronize the clock                                                                                                                                       |
| __o__                       | Pulse per second (PPS) peer. This is generally used with GPS time sources, although any time source delivering a PPS will do. This tally code and the previous tally code "*" will not be displayed simultaneously.                                 |


[Sources](https://pthree.org/2013/11/05/real-life-ntp/)

#### NTP Management

```bash
apt-get install ntp
ntpq -p
vim /etc/ntp.conf
sudo service ntp restart
ntpq -p


ntpstat

unsynchronised
time server re-starting
polling server every 64 s


ntpstat

synchronised to NTP server (10.10.10.10) at stratum 4 
       time correct to within 323 ms
       polling server every 64 s



ntpq -c peers

remote refid st t when poll reach delay offset jitter
======================================================================
hamilton-nat.nu .INIT. 16 u - 64 0 0.000 0.000 0.001
ns2.telecom.lt .INIT. 16 u - 64 0 0.000 0.000 0.001
fidji.daupheus. .INIT. 16 u - 64 0 0.000 0.000 0.001
```

#### Drift
```bash

```

## Git
![GitHub Logo](./src/git_cheat.png)

### Global info
```bash
git remote -v
git branch -v
```

#### Edit remote URL
```bash
git remote set-url origin git@git.baptiste-dauphin.com:GROUP/SUB_GROUP/project_name
```

### Git Tag
create tag at your current commit
```bash
git tag temp_tag_2
```

By default tags are not __pushed__, nor __pulled__ 
```bash
git push origin tag_1 tag_2
```

list tag
```bash
git tag -l
```

delete tag
```bash
git tag -d temp_tag_2
```

Get the current tag
```bash
git describe --tags --exact-match HEAD
```

### Git Checkout (branch / tag / commit)
```bash
git checkout dev
git checkout master
git checkout branch
git checkout v_0.9
git checkout ac92da0124997377a3ee30f3159cdee838bd5b0b
```

### Git branch
Get the current branch name
```bash
git branch | grep \* | cut -d ' ' -f2
```

### Git Diff
Specific file
```bash
git diff -- human/lvm.md
```

Global diff between your __unstagged changes__ (workspace) and the index
```bash
git diff
```

Global diff between your __stagged changes__ (index) and local repository
```bash
git diff --staged
```



### Git Stash
To list the stashed modifications

```bash
git stash list
```

To show files changed in the last stash

```bash
git stash show
```

So, to view the content of the most recent stash, run

```bash
git stash show -p
```

To view the content of an arbitrary stash, run something like

```bash
git stash show -p stash@{1}
```


### Git Merge conflict
In case of conflict when pulling, by default git will conserve both version of file(s)
```bash
git pull origin master

git status

You have unmerged paths.
  (fix conflicts and run "git commit")
  (use "git merge --abort" to abort the merge)
...
...
Unmerged paths:
  (use "git add <file>..." to mark resolution)

  both modified:   path/to/file
```

#### Undo/move your work
with __Git reset__ and __Git stash__
go at the previous commit. 
will uncommit your last changes
```bash
git reset --soft HEAD^
```
hide temporary your work in a dirty magic directory and verify the content of it
```bash
git stash
git stash show
```
Try to FF merge without any conflict
```bash
git pull
```

put back your work by spawning back your modifications
```bash
git stash pop
```
And then commit again
```bash
git commit "copy-paste history commit message :)"
```

#### Override a given side by another
You can tell him that you want your modifications take precedance 
So, in that case of __merge conflict__
cancel your conflict by cancel the current merge,
```bash
git merge --abort
```

Then, pull again telling git to keep YOUR local changes
```bash
git pull -X ours origin master
```

Or if you want to keep only the REMOTE work
```bash
git pull -X theirs origin master
```

#### Log
##### Find commit by author or since a specific date
```bash
git log --author="b.dauphin" \
    --since="2 week ago"
```

##### Find n last commit
```bash
git log --author="b.dauphin" \
    -3
```
##### only print specific info from commits
###### author
```bash
git log --since="2 week ago" \
    --pretty=format:"%an"
```
##### hash, author name, date, message
```bash
git log --author="b.dauphin"  \
    --since="2 week ago" \
    --pretty=format:"%h - %an, %ar : %s"
```

##### Show modification of specific commits
```bash
git show 01624bc338d4a89c09ba2915ff25ce08174b8e93 3d9228fa99eab6c208590df91eb2af05daad8b40
```

##### See changes to a specific file using git
```bash
git log --follow -p -- file
git --no-pager log --follow -p -- file
```

### Git Revert
The git revert command can be considered an 'undo' type command, however, it is not a traditional undo operation. __INSTEAD OF REMOVING the commit from the project history__, it figures out how to __invert the changes introduced by the commit and appends a new commit with the resulting INVERSE CONTENT__. This prevents Git from losing history, which is important for the integrity of your revision history and for reliable collaboration.

Reverting should be used when you want to apply the inverse of a commit from your project history. This can be useful, for example, if you’re tracking down a bug and find that it was introduced by a single commit. Instead of manually going in, fixing it, and committing a new snapshot, you can use git revert to automatically do all of this for you.

![GitHub Logo](./src/git_revert.svg)

```bash
git revert <commit hash>
git revert c6c94d459b4e1ed81d523d53ef81b6a4744eac12
```
> find a specific commit
```bash
git log --pretty=format:"%h - %an, %ar : %s"
```



### Git Reset
The __git reset__ command is a complex and versatile tool for undoing changes. It has three primary forms of invocation. These forms correspond to command line arguments __--soft__, __--mixed__, __--hard__. The three arguments each correspond to Git's three internal state management mechanism's, The Commit Tree (HEAD), The Staging Index, and The Working Directory.

Git reset & three trees of Git

To properly understand git reset usage, we must first understand Git's internal state management systems. Sometimes these mechanisms are called Git's "three trees".

![GitHub Logo](./src/git_reset.svg)

#### Undo a commit and redo
```bash
git commit ...
git reset --soft HEAD^
edit
git commit -a -c ORIG_HEAD
```

### Submodules
__First time__, clone a repo including its submodules
```bash
git clone --recurse-submodules -j8 git@github.com:FataPlex/documentation.git
```

Update an __existing__ local repositories after adding submodules or updating them
```bash
git pull --recurse-submodules 
git submodule update --init --recursive
```

#### Remove a submodule you need to:
* Delete the relevant section from the __.gitmodules__ file
* Stage the .gitmodules changes __git add .gitmodules__
* Delete the relevant section from __.git/config__
* Run __git rm --cached path_to_submodule__  (no trailing slash)
* Run __rm -rf .git/modules/path_to_submodule__ (no trailing slash).
* Commit __git commit -m "Removed submodule"__
* Delete the now untracked submodule files __rm -rf path_to_submodule__



## Tmux

Depuis le shell, avant de rentrer dans une session tmux
```bash
tmux ls
tmux new
tmux new -s session
tmux attach
tmux attach -t session_name
tmux kill-server : kill all sessions
:setw synchronize-panes on
:setw synchronize-panes off
:set-window-option xterm-keys on
```

### [.tmux.conf]
```bash
set-window-option -g xterm-keys on
```


### Inside tmux

__Ctrl + B__ : (to press __each time before another command__)

| Command                       | meaning                                                                                               |
|:------------------------------|:------------------------------------------------------------------------------------------------------|
| Flèches                       | = se déplacer dans le splitage des fenêtres                                                           |
| N                             | "Next window"                                                                                         |
| P                             | "Previous window"                                                                                     |
| z                             | : zoom in/out in the current span                                                                     |
| d                             | : detach from the current and let it running on the background (to be reattached to later)            |
| x                             | : kill                                                                                                |
| %                             | vertical split                                                                                        |
| "                             | horizontal split                                                                                      |
| o                             | : swap panes                                                                                          |
| q                             | : show pane numbers                                                                                   |
| x                             | : kill pane                                                                                           |
| +                             | : break pane into window (e.g. to select text by mouse to copy)                                       |
| -                             | : restore pane from window                                                                            |
| ⍽                             | : space - toggle between layouts                                                                      |
| q                             | (Show pane numbers, when the numbers show up type the key to goto that pane)                          |
| {                             | (Move the current pane left)                                                                          |
| }                             | (Move the current pane right)                                                                         |
| z                             | toggle pane zoom                                                                                      |
| ":set synchronise-panes on" : | synchronise_all_panes in the current session (to execute parallel tasks like multiple iperfs client)" |

## Email system

There are three main functions that make up an e-mail system.
* First there is the Mail User Agent (MUA) which is the program a user actually uses to compose and read mails.
* Then there is the Mail Transfer Agent (MTA) that takes care of transferring messages from one computer to another.
* And last there is the Mail Delivery Agent (MDA) that takes care of delivering incoming mail to the user's inbox. 

Function | Name | Tool which do this
-|-|-
Compose and read | MUA (User Agent) | mutt, thunderbird
Transferring | MTA (Transfer Agent) | msmtp,  __exim4__, thunderbird
Delivering incoming mail to user's inbox | MDA (Devliery agent) | __exim4__, thunderbird

### MTA
It exists two types of MTA (Mail Transfert Agent)

- __Mail server__ : like postfix, or sendmail-server 
- __SMTP client__, which only forward to a __SMTP relay__ : like ssmtp (deprecated since 2013), use __mstmp__ instead, 

#### Check what is your email sender, by looking at the sym link of `sendmail`
```bash
which sendmail
/usr/sbin/sendmail

ls -l /usr/sbin/sendmail
lrwxrwxrwx 1 root root 5 Jul 15  2014 /usr/sbin/sendmail -> ssmtp
```

In this case, ssmtp in my mail sender

#### MSTMP
msmtp est un client SMTP très simple et facile à configurer pour l'envoi de courriels.
Son mode de fonctionnement par défaut consiste à transférer les courriels au serveur SMTP que vous aurez indiqué dans sa configuration. Ce dernier se chargera de distribuer les courriels à leurs destinataires.
Il est entièrement compatible avec sendmail, prend en charge le transport sécurisé TLS, les comptes multiples, diverses méthodes d’authentification et les notifications de distribution.

Installation
```bash
apt install msmtp msmtp-mta
vim /etc/msmtprc
```
```bash
hashtag Valeurs par défaut pour tous les comptes.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

hashtag Exemple pour un compte Gmail
account        gmail
host           smtp.gmail.com
port           587
from           username@gmail.com
user           username
password       plain-text-password

hashtag Définir le compte par défaut
account default : gmail
```

Test email sending
```
echo -n "Subject: hello\n\nDo see my mail" | sendmail baptistedauphin76@gmail.com

```
You run the command... and, oops: sendmail: Cannot open mailhub:25. The reason for this is that we didn't provide mailhub settings at all. In order to forward messages, you need an SMTP server configured. That's where SSMTP performs really well: you just need to edit its configuration file once, and you are good to go.


#### Send mail using open (smtp) relay
Note that it also works with netcat 
```bash
nc smtp.free.fr 25
```

```bash
telnet smtp.free.fr 25
Trying 212.27.48.4...
Connected to smtp.free.fr.
Escape character is '^]'.
220 smtp4-g21.free.fr ESMTP Postfix
HELO test.domain.com
250 smtp4-g21.free.fr
MAIL FROM:<test@domain.com>
250 2.1.0 Ok
RCPT TO:<toto@domain.fr>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Subject: test message
This is the body of the message!
.
250 2.0.0 Ok: queued as 2D8FD4C80FF
quit
221 2.0.0 Bye
Connection closed by foreign host.
```




### Wireshark
#### DNS Analysis with Tshark
It just plugs into 
```bash
tshark -f "udp port 53" -Y "dns.qry.type == A and dns.flags.response == 0"
```
count total dns query
```bash
tshark -f "udp port 53" -n -T fields -e dns.qry.name | wc -l
```
#### HTTP
##### HTTP Analysis with Tshark
```bash
tshark -i wlan0 -Y http.request -T fields -e http.host -e http.user_agent
```

##### Parse User Agents and Frequency with Standard Shell Commands
```bash
tshark -r example.pcap -Y http.request -T fields -e http.host -e http.user_agent | sort | uniq -c | sort -n
```

##### Using additional HTTP filters in Analysis
```bash
tshark -r example.pcap -Y http.request -T fields -e http.host -e ip.dst -e http.request.full_uri
```

##### Using additional HTTP filters in Analysis
```bash
tshark -r example.pcap -Y http.request -T fields -e http.host -e ip.dst -e http.request.full_uri
```

## OpenLDAP
## Active Directory

Search into LDAP
```bash
ldapsearch --help
-H URI     LDAP Uniform Resource Identifier(s)
-x         Simple authentication
-W         prompt for bind password
-D binddn  bind DN
-b basedn  base dn for search
SamAccountName SINGLE-VALUE attribute that is the logon name used to support clients and servers from a previous version of Windows.

ldapsearch -H ldap://10.10.10.10 \
-x \
-W \
-D "user@fqdn" \
-b "ou=ou,dc=sub,dc=under,dc=com" "(sAMAccountName=b.dauphin)"
```

modify an acount (remotly)
```bash
apt install ldap-utils

ldapmodify \
-H ldaps://ldap.company.tld \
-D "cn=b.dauphin,ou=people,c=fr,dc=company,dc=fr" \
-W \
-f b.gates.ldif
```
(.ldif must contains modification data)

#### Locally
```bash
slapcat -f b.gates.ldif
```
#### Generate hash of the password, to update later the password account
will prompt you the string you wanna hash, and generate it in stout
```bash
slappasswd -h {SSHA}
```

#### Content of .ldif
```bash
dn: cn=b.dauphin@github.com,ou=people,c=fr,dc=company,dc=fr
changetype: modify
replace: userPassword
userPassword: {SSHA}0mBz0/OyaZqOqXvzXW8TwE8O/Ve+YmSl
```

## SaltStack
##### Saltstack master key management
| --list=$ARG                   | definition                     |
|:------------------------------|:-------------------------------|
| __pre__,__un__,__unaccepted__ | list unaccepted/unsigned keys. |
| __acc__ or __accepted__       | list accepted/signed keys.     |
| __rej__ or __rejected__       | list rejected keys             |
| __den__ or __denied__         | list denied keys               |
| __all__                       | list all above keys            |

### Targeting
```bash
salt -S 192.168.40.20 test.version
salt -S 192.168.40.0/24 test.version
```
compound match
```bash
salt -C 'S@10.0.0.0/24 and G@os:Debian' test.version
```
[full doc](https://docs.saltstack.com/en/latest/topics/targeting/globbing.html)
[Compound matchers](https://docs.saltstack.com/en/latest/topics/targeting/compound.html)

### Various useful module
```bash
salt '*' network.ip_addrs
salt '*' cmd.run
salt '*' state.Apply
salt '*' test.ping
salt '*' test.version
salt '*' grains.get
salt '*' grains.item
salt '*' grains.items
salt '*' grains.ls
```

##### salt diff between 2 servers
```bash
salt-run survey.diff '*' cmd.run "ls /home"
```

##### SaltStack - cache
Forcibly removes all caches on a minion.
WARNING: The safest way to clear a minion cache is by first stopping the minion and then deleting the cache files before restarting it.  
soft way
```bash
salt '*' saltutil.clear_cache
```
sure way
```bash
systemctl stop salt-minion \
&& rm -rf /var/cache/salt/minion/ \
&& systemctl start salt-minion
```
##### SaltStack - pillar, custom modules, states, beacons, grains, returners, output modules, renderers, and utils
Signal the minion to refresh the pillar data.
```bash
salt '*' saltutil.refresh_pillar
```
synchronizes custom modules, states, beacons, grains, returners, output modules, renderers, and utils.
```bash
salt '*' saltutil.sync_all
```

##### Classic grains
```bash
    - SSDs
    - biosreleasedate
    - biosversion
    - cpu_flags
    - cpu_model
    - cpuarch
    - disks
    - dns
    - domain
    - fqdn
    - fqdn_ip4
    - fqdn_ip6
    - gid
    - gpus
    - groupname
    - host
    - hwaddr_interfaces
    - id
    - init
    - ip4_gw
    - ip4_interfaces
    - ip6_gw
    - ip6_interfaces
    - ip_gw
    - ip_interfaces
    - ipv4
    - ipv6
    - kernel
    - kernelrelease
    - kernelversion
    - locale_info
    - localhost
    - lsb_distrib_codename
    - lsb_distrib_id
    - machine_id
    - manufacturer
    - master
    - mdadm
    - mem_total
    - nodename
    - num_cpus
    - num_gpus
    - os
    - os_family
    - osarch
    - oscodename
    - osfinger
    - osfullname
    - osmajorrelease
    - osrelease
    - osrelease_info
    - path
    - pid
    - productname
    - ps
    - pythonexecutable
    - pythonpath
    - pythonversion
    - saltpath
    - saltversion
    - saltversioninfo
    - selinux
    - serialnumber
    - server_id
    - shell
    - swap_total
    - systemd
    - uid
    - username
    - uuid
    - virtual
    - zfs_feature_flags
    - zfs_support
    - zmqversion
```

##### grains containing 'os' (for targeting)
```bash
    os:
        Debian
    os_family:
        Debian
    osarch:
        amd64
    oscodename:
        stretch
    osfinger:
        Debian-9
    osfullname:
        Debian
    osmajorrelease:
        9
    osrelease:
        9.5
    osrelease_info:
        - 9
        - 5
```
##### Upgrade Salt-Minion - FROM STATE
```yaml
Upgrade Salt-Minion:
  cmd.run:
    - name: |
        exec 0>&- # close stdin
        exec 1>&- # close stdout
        exec 2>&- # close stderr
        nohup /bin/sh -c 'salt-call --local pkg.install salt-minion && salt-call --local service.restart salt-minion' &
    - onlyif: "[[ $(salt-call --local pkg.upgrade_available salt-minion 2>&1) == *'True'* ]]" 
```

##### Upgrade Salt-Minion - FROM STATE
[Upgrade salt-minion bash script](../scripts/salt-minion_upgrade.bash)

#### Saltstack Python Templating - Jinja2 example
```python
{% set ipaddr = grains['fqdn_ip4'][0] %}
{% if (key | regex_match('.*dyn.company.tld.*', ignorecase=True)) != None %}
```

#### Useful exemple
##### Netcat
```bash
salt -C "minion.local or minion2.local" \
> cmd.run "docker run debian /bin/bash -c 'http_proxy=http://10.100.100.100:1598 apt update ; http_proxy=http://10.100.100.100:1598 apt install netcat -y ; nc -zvn 10.3.3.3 3306' | grep open"
minion.local:
    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    
    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    
    debconf: delaying package configuration, since apt-utils is not installed
    (UNKNOWN) [10.3.3.3] 3306 (?) open

minion2.local:
    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    
    
    WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
    
    debconf: delaying package configuration, since apt-utils is not installed
    (UNKNOWN) [10.3.3.3] 3306 (?) open
```

##### MySQL connexion
Will print you the GRANTS for the user
```bash
echo "enter your password" ; read -s password ; \
salt "*" \
cmd.run "docker pull imega/mysql-client ; docker run --rm imega/mysql-client mysql --host=10.10.10.10 --user=b.dauphin --password=$password --database=db1 --execute='SHOW GRANTS FOR CURRENT_USER();'" \
env='{"http_proxy": "http://10.10.10.10:9999"}'
```

## Apache
Validate config before reload/restart
```bash
apachectl configtest
```

## Nginx
pronouced 'Engine X'

Various variables
[HTTP variables](http://nginx.org/en/docs/http/ngx_http_core_module.html)
### virtual host
example redirect HTTP to HTTPS
```
server {
    listen 80;
    return 301 https://$host$request_uri;
}
```

## Bind9
https://wiki.csnu.org/index.php/Installation_et_configuration_de_bind9  
the process name of bind9 is "named"
### rndc
__name server control utility__

Write (dump) cache of named in default file (__/var/cache/bind/named_dump.db__)  
dumpdb [-all|-cache|-zones|-adb|-bad|-fail] [view ...]
```bash
rndc dumpdb -cache default_any
```

enable query logging in default location (__/var/log/bind9/query.log__)
```bash
rndc querylog [on|off]
```

toggle querylog mode
```bash
rndc querylog
```

flush   Flushes all of the server's caches.
```bash
rndc flush
```
flush [view]  Flushes the server's cache for a view.
```bash
rndc flush default_any
```

get unic master zone loaded
```bash
named-checkconf -z 2> /dev/null | grep 'zone' | sort -u | awk '{print $2}' | rev | cut --delimiter=/ -f2 | rev | sort -u
named-checkconf -z 2> /dev/null | grep 'zone' | grep -v 'bad\|errors' | sort -u | awk '{print $2}' | rev | cut --delimiter=/ -f2 | rev | sort -u
```

keep cache
```bash
systemctl reload bind9
```
empty cache
```bash
systemctl restart bind9
```

### dig
```bash
dig @8.8.8.8 +short www.qwant.com +nodnssec
dig @8.8.8.8 +short google.com +notcp
dig @8.8.8.8 +noall +answer +tcp www.qwant.com A
dig @8.8.8.8 +noall +answer +notcp www.qwant.com A
```

others options
- +short
- +(no)tcp
- +(no)dnssec
- +noall
- +answer
- type

[Full manual](https://linux.die.net/man/1/dig)







## Zabbix
### API usage  
Verify your url
```
https://zabbix.company/zabbix.php?action=dashboard.view
https://zabbix.company/zabbix/zabbix.php?action=dashboard.view
```
### Test zabbix agent key
```bash
### Test a given item
zabbix_agentd -t system.hostname
zabbix_agentd -t system.swap.size[all,free]
zabbix_agentd -t vfs.file.md5sum[/etc/passwd]
zabbix_agentd -t vm.memory.size[pavailable]

### print all known items 
zabbix_agentd -p
```

#### zabbix server info request (to perform a first test)
```bash
curl \
-d '{ 
  "jsonrpc":"2.0", 
  "method":"apiinfo.version", 
  "id":1, 
  "auth":null, 
  "params":{} 
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.company/api_jsonrpc.php | jq .
```

##### Authentication request. In order to get TOKEN for the next request
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": "b.dauphin",
        "password": "toto"
    },
    "id": 1,
    "auth": null
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.company/api_jsonrpc.php | jq .
```


##### Get all trigger of a specific host
replace $host and $token
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
        "filter": {
            "host": [
                "$host"
            ]
        },
        "with_triggers": "82567"
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.company/api_jsonrpc.php | jq .
```

##### get hostid with name(s)
Replace `$hostname1`,`$hostname2` and `$token`
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
      "output": ["hostid"],
        "filter": {
            "host": [
                ""$hostname1","$hostname2"
            ]
        }
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.tld/api_jsonrpc.php | jq '.result'
```

##### Get groups of a specific host(s)
Replace `$hostname1`,`$hostname2` and `$token`
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
      "output": ["hostid"],
      "selectGroups": "extend",
        "filter": {
            "host": [
                "$hostname1","$hostname2"
            ]
        }
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.tld/api_jsonrpc.php | jq .
```

##### Get host by TAG(S)
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
      "output": ["name"],     
        "selectTags": "extend",
        "tags": [
            {
                "tag": "environment",
                "value": "dev",
                "operator": 1
            }
        ]
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.company/api_jsonrpc.php | jq .
```

Output __hostid__, __host__ and __name__
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
      "output": ["hostid","host","name"],     
        "tags": [
            {
                "tag": "environment",
                "value": "dev",
                "operator": 1
            }
        ]
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.company/api_jsonrpc.php | jq .
```
##### Get host by multiple TAGS

```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.get",
    "params": {
      "output": ["name"],     
        "tags": [
            {
                "tag": "app",
                "value": "swarm",
                "operator": "1"
            },
            {
                "tag": "environment",
                "value": "dev",
                "operator": "1"
            }
        ]
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.tld/api_jsonrpc.php | jq .
```

##### Modify TAG
`Warning` erase all others tags + can set only one tag... So I do not recommend using this shity feature.
```bash
curl \
-d '{
    "jsonrpc": "2.0",
    "method": "host.update",
    "params": {
      "hostid": "12345",
        "tags": [
            {
                "tag": "environment",
                "value": "staging"
            }
        ]
    },
    "id": 2,
    "auth": "$token"
  }' \
-H "Content-Type: application/json-rpc" \
-X POST https://zabbix.tld/api_jsonrpc.php | jq '.result'
```

## Elastic Search

By default, each index in Elasticsearch is allocated __5 primary shards__ and __1 replica__ which means that if you have at least two nodes in your cluster, your index will have 5 primary shards and another 5 replica shards (1 complete replica) for a __total of 10 shards per index.__

| Meaning                                                  | end point (http://ip:9200)                                                                                         |
|:---------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------|
| Nodes name, load, heap, Disk used, segments, JDK version | /\_cat/nodes?v&h=name,ip,load_1m,heapPercent,disk.used_percent,segments.count,jdk                                  |
| info plus précises sur les index                         | /_cat/indices/__INDEX__/?v&h=index,health,pri,rep,docs.count,store.size,search.query_current,segments,memory.total |
| compter le nombre de doc                                 | /_cat/count/__INDEX__/?v&h=dc                                                                                      |
| savoir l'état du cluster à un instant T                  | /_cat/health                                                                                                       |
| full stats index                                         | /__INDEX__/_stats?pretty=true                                                                                      |
| Kopg plugin                                              | /_plugin/kopf                                                                                                      |

### Dump / Backup
Very good tutorial
https://blog.ruanbekker.com/blog/2017/11/22/using-elasticdump-to-backup-elasticsearch-indexes-to-json/

`Warning`
DO NOT BACKUP with wildcard matching

I tested to backup indexes with wildcard, It works but when you want to put back the data, elasticdump takes ALL the DATA from ALL index from the the json file to feed the one you provide in the url. Exemple :

```bash
elasticdump --input=es_test-index-wildcard.json --output=http://localhost:9200/test-index-1 --type=data
```

In this exemple the file es_test-index-wildcard.json was the result of the following command, which matches 2 indexes (test-index-1 and test-index-2)

```bash
elasticdump --input=http://localhost:9200/test-index-* --output=es_test-index-1.json --type=data
```

So, I'll have to manually expand all various indexes in order to back them up ! 


__Elasticsearch Cluster Topology__
![GitHub Logo](./src/elasticsearch_cluster_topology.png)

### Templates
Change the future index sharding and and replicas and other stuff.  
For example, if you have a mono-node cluster, you don't want any replica nor sharding.

```bash
curl -X POST '127.0.0.1:9200/_template/default' \
 -H 'Content-Type: application/json' \
 -d '
 {
  "index_patterns": ["*"],
  "order": -1,
  "settings": {
    "number_of_shards": "1",
    "number_of_replicas": "0"
  }
}
 ' \
 | jq .
```



## Php-FPM
check config
```bash
php-fpm7.2 -t
```

## HAProxy
### Check config
```bash
haproxy -f /etc/haproxy/haproxy.cfg -c -V
```

## Java
### JDK
version
```bash
java -version
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (build 1.8.0_222-b10)
OpenJDK 64-Bit Server VM (build 25.222-b10, mixed mode)
```
### Memory management
[Heap, stack etc](https://alvinalexander.com/blog/post/java/java-xmx-xms-memory-heap-size-control)

### Java - certificate authority 
Java doesn't use system CA but a specific `keystore`
You can manage the keystore with `keytool`
```bash
keytool -list -v -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts

keytool -import -alias dolphin_ltd_root_ca -file /etc/pki/ca-trust/source/anchors/dolphin_ltd_root_ca.crt -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts
keytool -import -alias dolphin_ltd_subordinate_ca -file /etc/pki/ca-trust/source/anchors/dolphin_ltd_subordinate_ca.crt -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts

keytool -delete -alias dolphin_ltd_root_ca -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts
keytool -delete -alias dolphin_ltd_subordinate_ca -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts
```

## Python
#### Knowledge

Symbol | Meaning
-|-
() | tuple
[] | list
{} | dictionary

[Python tutorial](https://docs.python.org/3/tutorial/datastructures.html)

#### Common commands
> list all versions of python (system wide)
```bash
ls -ls /usr/bin/python*
```

> install pip3
```bash
apt-get install build-essential python3-dev python3-pip
```

> install a package
```bash
pip install virtualenv

pip --proxy http://10.10.10.10:5000 install docker
```

> install without TLS verif (not recommended)
```bash
pip install --trusted-host pypi.python.org \
            --trusted-host github.com \
            https://github.com/Exodus-Privacy/exodus-core/releases/download/v1.0.13/exodus_core-1.0.13.tar.gz
```

> Show information about one or more installed packages

```bash
pip3 show $package_name
pip3 show virtualenv
```

> print all installed package (depends on your environement venv or system-wide)

```bash
pip3 freeze
```

> install from local sources (setup.py required)

```bash
python setup.py install --record files.txt
```

> print dependencies tree of a specified package
```bash
pipdeptree -p uwsgi
```

> global site-packages ("dist-packages") directories

```bash
python3 -m site
```

> more concise list

```bash
python3 -c "import site; print(site.getsitepackages())"
```

Note: With virtualenvs getsitepackages is not available, sys.path from above will list the virtualenv s site-packages directory correctly, though.

### Build a package
Create python package (to be downloaded in site-packages local dir)
#### 1) Make the following directory structure in your local dev machine

```bash

-----------------------------
some_root_dir/
|-- README
|-- setup.py
|-- an_example_pypi_project
|   |-- __init__.py
|   |-- useful_1.py
|   |-- useful_2.py
|-- tests
|-- |-- __init__.py
|-- |-- runall.py
|-- |-- test0.py

----------------------------
```

#### 2) setup.py content (in the dir)
Utility function to read the README file.  
Used for the long_description.  It's nice, because now 1) we have a top level  
README file and 2) it's easier to type in the README file than to put a raw  
string in below ...  

```python
import os
from setuptools import setup

def read(fname):
    return open(os.path.join(os.path.dirname(__file__), fname)).read()

setup(
    name = "an_example_pypi_project",
    version = "0.0.4",
    author = "Andrew Carter",
    author_email = "andrewjcarter@gmail.com",
    description = ("An demonstration of how to create, document, and publish "
               "to the cheese shop a5 pypi.org."),
    license = "BSD",
    keywords = "example documentation tutorial",
    url = "http://packages.python.org/an_example_pypi_project",
    packages=['an_example_pypi_project', 'tests'],
    long_description=read('README'),
    classifiers=[
        "Development Status :: 3 - Alpha",
        "Topic :: Utilities",
        "License :: OSI Approved :: BSD License",
    ],
)
```

#### 3) create ".whl" with wheel
within the root directory  
Your package have been built in /dist/$(package-name)-$(version)-$(py2-compatible)-$(py3-compatible)-any.whl  
```bash
python setup.py sdist bdist_wheel
example : ./dist/dns_admin-1.0.0-py2-none-any.whl
```

### virtualenv venv
##### dependencies
```bash
apt install python-pip python3-pip
pip install pipenv
``` 

```bash
Usage Examples:
   Create a new project using Python 3.7, specifically:
   $ pipenv --python 3.7

   Remove project virtualenv (inferred from current directory):
   $ pipenv --rm

   Install all dependencies for a project (including dev):
   $ pipenv install --dev

   Create a lockfile containing pre-releases:
   $ pipenv lock --pre

   Show a graph of your installed dependencies:
   $ pipenv graph

   Check your installed dependencies for security vulnerabilities:
   $ pipenv check

   Install a local setup.py into your virtual environment/Pipfile:
   $ pipenv install -e .

   Use a lower-level pip command:
   $ pipenv run pip freeze

Commands:
  check      Checks for security vulnerabilities and against
             PEP 508 markers provided in Pipfile.
  clean      Uninstalls all packages not specified in
             Pipfile.lock.
  graph      Displays currently-installed dependency graph
             information.
  install    Installs provided packages and adds them to
             Pipfile, or (if no packages are given),
             installs all packages from Pipfile.
  lock       Generates Pipfile.lock.
  open       View a given module in your editor.
  run        Spawns a command installed into the virtualenv.
  shell      Spawns a shell within the virtualenv.
  sync       Installs all packages specified in
             Pipfile.lock.
  uninstall  Un-installs a provided package and removes it
             from Pipfile.
  update     Runs lock, then sync.

```


### check the protocols supported by your Python version
```bash
vim /tmp/testPythonProtocols.py
```

```python
import ssl;
for i in dir(ssl): 
  if i.startswith("PROTOCOL"):
    print(i)
```

```bash
/tmp/testPythonProtocols.py
```

## RabbitMQ
https://www.rabbitmq.com/management.html



## Ansible
| Command                           | Meaning                                                    | default                   | SaltStack equivalent
-|-|-|-
| --check                           | Dry run                                                    | __no__ dry run            | test=True
| -b, --become                      | run operations with become                                 | __no__ password prompting |
| -K, --ask-become-pass             | ask for privilege escalation password                      |
| --become-method=__BECOME_METHOD__ | privilege escalation method to use valid choices: [ sudo su pbrun pfexec doas dzdo ksu runas pmrun enable machinectl sudo | sudo
| --become-user=__BECOME_USER__     | run operations as this user                                | root



| Example                                                                 | meaning                                                    |
|:------------------------------------------------------------------------|:-----------------------------------------------------------|
| ansible-playbook playbook.yml --user=b.dauphin --become-method=su -b -K | su b.dauphin + password prompting                          |
| ansible-playbook playbook.yml --check --diff --limit 1.2.3.4            | Dry run + show only diff + limit inventory to host 1.2.3.4 |

### service module
```bash
ansible webservers -m service -a "name=httpd state=restarted"
ansible all -m ping -u user1 --private-key /home/baptiste/.ssh/id_rsa
```

Specify python interpreter path
```bash
ansible 1.2.3.4 -m ping -e 'ansible_python_interpreter=/usr/bin/python3'
```
list available variables
```bash
ansible 10.10.10.10 -m setup
```
get specific fact
```bash
ansible 10.10.10.10 -m setup -a 'filter=ansible_python_version'
```

enable usage of operations like __<__ __>__ __|__ __&__  
the remote system has to got the package __python-apt__
```yaml
apt install python-apt
- debug: var=ansible_facts
```

#### Playbook start __at__ a specific task
```bash
ansible-playbook --start-at-task="Gather Networks Facts into Variable"
```

##### start __only__ specific task
```bash
ansible-playbook --tags "docker_login"
```

##### Debug ansible playbook
###### print a specific var. __Warning__ does not print vars in __group_vars__ nor __host_vars__
```yaml
[...]
msg: "{{ lookup('vars', ansible_dns) }}"
[...]
```

```yaml
[...]
- name: Gather Networks Facts into Variable
  setup:
  register: setup

- name: Debug Set Facts
  debug:
    var: setup.ansible_facts.ansible_python_version
```

##### Variables usage
```yaml

---
- hosts: webservers
  vars:
    syslog_protocol_lvl_4: udp
    syslog_port: 514
    ansible_python_interpreter: /bin/python
    ansible_ssh_user: root
```

##### Variables assignment
```bash
ansible-playbook release.yml --extra-vars '{"version":"1.23.45","other_variable":"foo"}'
ansible-playbook arcade.yml --extra-vars '{"pacman":"mrs","ghosts":["inky","pinky","clyde","sue"]}'
```
override playbook-defined variables (keep your playbook unmodified)
```bash
ansible-playbook lvm.yml --extra-vars "host=es_data_group remote_user=b.dauphin" -i ../inventory/es_data_staging.yml

```
[Full doc of passing-variables-on-the-command-line](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#passing-variables-on-the-command-line)

##### Variable precedence - Where should I put a variable ?
Here is the order of precedence __from least to greatest__ (the last listed variables winning prioritization):

* command line values (eg “-u user”)
* role defaults [1]
* inventory file or script group vars [2]
* inventory group_vars/all [3]
* playbook group_vars/all [3]
* inventory group_vars/* [3]
* playbook group_vars/* [3]
* inventory file or script host vars [2]
* inventory host_vars/* [3]
* playbook host_vars/* [3]
* host facts / cached set_facts [4]
* play vars
* play vars_prompt
* play vars_files
* role vars (defined in role/vars/main.yml)
* block vars (only for tasks in block)
* task vars (only for the task)
* include_vars
* set_facts / registered vars
* role (and include_role) params
* include params
* extra vars (__always win precedence__)



## Node js
### NPM (Node Package Manager)
npm est le gestionnaire de paquets officiel de Node.js. Depuis la version 0.6.3 de Node.js, npm fait partie de l'environnement et est donc automatiquement installé par défaut. npm fonctionne avec un terminal et gère les dépendances pour une application.
```bash
npm config set proxy http://ip:port
npm config set https-proxy http://ip:port

hashtag Print the effective node_modules FOLDER to standard out.
npm root
npm root -g

hashtag display a tree of every package found in the user’s folders (without the -g option it only shows the current directory’s packages)
npm list -g --depth 0

hashtag To show the package registry entry for the connect package, you can do this:
npm view ghost-cli
npm info ghost-cli
```

### NPM Script
```bash

```

### NVM (Node Version Manager)
```bash
nvm install 8.9.4
```


## Yarn
### Usage
> will read yarn.lock (like PipFile.lock)
```bash
yarn setup
```
> verify dep tree is ok
```
yarn --check-files
grep grunt.registerTask Gruntfile.js
[knex-migrator]
```

## Varnish
### Varnishadm
```bash
varnishadm -S /etc/varnish/secret

hashtag For states of backend
varnishadm -S /etc/varnish/secret debug.health

hashtag new version
varnishadm -S /etc/varnish/secret backend.list

hashtag After a crash of varnish:
varnishadm -S /etc/varnish/secret panic.show
```
### VarnishLog
Log hash with filter for request number 
```bash
varnishlog -c -i Hash
```

### varnishncsa
Not enabled by default
exemple de commandes  pour  tracker les requêtes ayant pris plus de 10 seconde
```bash
varnishncsa -F '%t "%r" %s %{Varnish:time_firstbyte}x %{VCL_Log:backend}x' -q "Timestamp:Process[2] > 10.0"
```

#### Varnish Purge
```bash
CURL -X PURGE  "http://IP/object"
```

## Log Rotate
don't do anything just checkconfig
```bash
logrotate -d /etc/logrotate/logrotate.conf
```

#### run logrotate
```bash
logrotate /etc/logrotate.conf -v
```

#### Exemple
```
/var/log/dpkg.* {
  monthly
  rotate 12
  size 100M
  compress
  delaycompress
  missingok
  notifempty
  create 644 root root
}
```

[Other exemple](https://doc.ubuntu-fr.org/logrotate#exemple)


# Databases
## MySQL
### User, Password
```sql
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'api_153'@'10.10.%.%' IDENTIFIED BY 'password';
SELECT user, host FROM mysql.user;
SHOW CREATE USER api
```
#### GRANT (rights)
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON `github`.* TO 'api_153'@'10.10.%.%';
GRANT ALL PRIVILEGES ON `github`.`user` TO 'api_153'@'10.10.%.%';

-- Apply GRANT
FLUSH PRIVILEGES;
```
#### Revoke (revert GRANT)
```sql
REVOKE INSERT ON *.* FROM 'jeffrey'@'localhost';
REVOKE ALL PRIVILEGES ON `github`.* FROM 'jeffrey'@'localhost';
```

#### Table information
```bash
show table status like 'mytablename'\G
```
```sql
*************************** 1. row ***************************
           Name: mytablename
         Engine: MyISAM
        Version: 10
     Row_format: Dynamic
           Rows: 2444
 Avg_row_length: 7536
    Data_length: 564614700
Max_data_length: 281474976710655
   Index_length: 7218176
      Data_free: 546194608
 Auto_increment: 1187455
    Create_time: 2008-03-19 10:33:13
    Update_time: 2008-09-02 22:18:15
     Check_time: 2008-08-27 23:07:48
      Collation: latin1_swedish_ci
       Checksum: NULL
 Create_options: pack_keys=0
        Comment:
```

### Worth known command
From shell (outside of a MySQL prompt)
```bash
mysql -u root -p -e 'SHOW VARIABLES WHERE Variable_Name LIKE "%dir";'
```
Show users and remote client IP or subnet etc
```sql
SELECT user, host FROM mysql.user;
select user, host FROM mysql.user WHERE user = 'b.dauphin';
```

Show current queries
```sql
SHOW FULL PROCESSLIST;
```

### Variables, status
`%` is a wildcard char like `*`
```sql
SHOW VARIABLES WHERE Variable_Name LIKE "%log%";

SHOW VARIABLES WHERE Variable_Name LIKE "wsrep%";

SHOW STATUS like 'Bytes_received';
SHOW STATUS like 'Bytes_sent';
```

### Log
The file mysql-bin.[index] keeps a list of all binary logs mysqld has generated and auto-rotated. The mechanisms for cleaning out the binlogs in conjunction with mysql-bin.[index] are:
```sql
PURGE BINARY LOGS TO 'binlogname';
PURGE BINARY LOGS BEFORE 'datetimestamp';
```
#### Analyze binary logs
```bash
mysqlbinlog -d github \
--base64-output=DECODE-ROWS \
--start-datetime="2005-12-25 11:25:56" \
pa6.k8s.node.01-bin.000483 
```

#### Show
```sql
SHOW CREATE TABLE user;
SHOW GRANTS FOR user@git.baptiste-dauphin.com;
```



#### Table size
```sql
SELECT table_name AS `Table`, round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` FROM information_schema.TABLES WHERE table_schema = "github_db1" AND table_name = "table1";
```

###### All tables of all databases with size
```sql
SELECT 
     table_schema as `Database`, 
     table_name AS `Table`, 
     round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB`,
     round(((data_length + index_length) / 1024 / 1024 / 1024), 2) `Size in GB` 
FROM information_schema.TABLES 
ORDER BY table_schema, data_length + index_length DESC;
```

###### All Databases size
```sql
SELECT table_schema "Database", ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" FROM information_schema.tables GROUP BY table_schema;
```
##### Feed database
put the .sql.gz file into STDIN of gunzip and then, send to mysql
```bash
gunzip < [compressed_filename.sql.gz] | mysql -u [user] -p[password] [databasename]
```
If you encouter errors like `foreign key`
```bash
gunzip < heros_db.sql.gz | mysql --init-command="SET SESSION FOREIGN_KEY_CHECKS=0;" -u root -p heros
```
[Full explanation](https://tableplus.com/blog/2018/08/mysql-how-to-temporarily-disable-foreign-key-constraints.html)

##### All in one usage <3
```bash
mysql -u baptiste -p -h database.baptiste-dauphin.com -e "SELECT table_schema 'DATABASE_1', ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) 'DB Size in MB' FROM information_schema.tables GROUP BY table_schema;"
```

## MySQL - tool
Run after an mysql upgrade. Update system tables like `performance_schema`
```bash
mysql_upgrade -u root -p
```

Test configuration before restart. Will output if some error exist
```bash
mysqld --help
```

Simulate the running config If you would have been started mysql
```bash
mysqld --print-defaults
```
### Dump
with __mysqldump__
```bash
mysqldump -u root -p \
--all-databases \       # Dump all tables in all databases, WITHOUT 'INFORMATION_SCHEMA' and 'performace_schema'
--add-drop-database \   # Add DROP DATABASE statement before each CREATE DATABASE statement
--ignore-table=DB.table_name \
--skip-add-locks \      # Do not add locks
--skip-lock-tables \
--single-transaction \
> /home/b.dauphin/mysqldump/dump_mysql_.sql

mysqldump -h 10.10.10.10 \
-u baptiste \
-p*********** db1 table1 table2 table3 \
--skip-add-locks \
--skip-lock-tables \
--single-transaction \
| gzip  > /home/b.dauphin/backup-`date +%d-%m-%Y-%H:%M:%S`.sql.gz
```

To export to file (`structure only`)
```bash
mysqldump -u [user] -p[pass] --no-data mydb > mydb.sql
```

To export to file (`data only`)
```bash
mysqldump -u [user] -p[pass] --no-create-info mydb > mydb.sql
```

Exemple
```bash
mysqldump \
-u root \
-p user1 \
--single-transaction \
--skip-add-locks \
--skip-lock-tables \
--skip-set-charset \
--no-data \
> db1_STRUCTURE.sql

mysqldump \
-u root \
-p user1 \
--single-transaction \
--skip-add-locks \
--skip-lock-tables \
--skip-set-charset \
--no-create-info \
> db1_DATA.sql
```
```sql
CREATE DATABASE db1;
```
```bash
mysql -u root -p db1 < db1_STRUCTURE.sql
mysql -u root -p db1 < db1_DATA.sql
```


To import to database
```bash
mysql -u [user] -p[pass] mydb < mydb.sql
or
gunzip < heros_db.sql.gz | mysql --init-command="SET SESSION FOREIGN_KEY_CHECKS=0;" -u root -p heros
```

## Percona XtraDB Cluster
(open source, cost-effective, and robust MySQL clustering)  
Test replication from reverse proxy
```bash
for i in `seq 1 6`; do mysql -u clustercheckuser -p -e "show variables like 'server_id'; select user()" ; done
```

## Redis
Get info about __master/slave__ replication
```bash
redis-cli -h 10.10.10.10 -p 6379 -a $PASSWORD info replication
```

FLUSH all keys of all databases
```bash
redis-cli FLUSHALL
```

Delete all keys of the specified Redis database
```bash
redis-cli -n <database_number> FLUSHDB
```

### Redis cluster
remove keys from file as input
```bash
redis --help
-c                 Enable cluster mode (follow -ASK and -MOVED redirections).
for line in $(cat lines.txt); do redis-cli -a xxxxxxxxx -p 7000 -c del $line; done
```

Check all databases
```bash
CONFIG GET databases
1) "databases"
2) "16"
```

```bash
INFO keyspace

db0:keys=10,expires=0
db1:keys=1,expires=0
db3:keys=1,expires=0
```

Delete multiples keys
```bash
redis-cli -a XXXXXXXXX --raw keys "my_word*" | xargs redis-cli -a XXXXXXXXX  del
```

Resolve warning
```bash
cat /etc/systemd/system/disable-transparent-huge-pages.service 
[Unit]
Description=Disable Transparent Huge Pages

[Service]
Type=oneshot
ExecStart=/bin/sh -c "/bin/echo "never" | tee /sys/kernel/mm/transparent_hugepage/enabled"

[Install]
WantedBy=multi-user.target
```

## InfluxDB
get prompt
```bash
influx
```
### Retention policy
```sql
SHOW databases;
USE lands

SHOW RETENTION POLICIES ON "lands"
```
### MySQL equivalent
| MySQL       | Influx       |
|:------------|:-------------|
| DATABASE    | DATABASE     |
| MEASUREMENT | TABLE        |
| COLUMN      | FIELD && TAG |

```sql
SHOW series ON database FROM virtualmachine WHERE cluster = 'PROD'
```

### InfluxDB paradygm

Each record stored inside of a __measurement__ is known as a __point__ . Points are made up of the following:

* pretime : Timestamp that represents the time in which the data was recorded.
* field : Contain the actual measurement data, e.g 5% CPU utilisation. Each point  must contain one or more fields .
* tags : Metadata about the data being recorded, e.g the hostname of the device whose CPU is being monitored. Each point  can contain zero or more tags .

(Note that both the fields and tags can be thought of as columns in the database table. We’ll see why in a moment.)

```sql
-- default on all measurement
SHOW field keys

-- default on all measurement
SHOW tag keys

SELECT usage_user,cpu,host
FROM cpu 
WHERE cpu='cpu-total' 
AND host='ubuntu'
AND time > now() - 30s
```

* [Good tuto](http://www.oznetnerd.com/getting-know-influxdb/)
* [Official doc](https://docs.influxdata.com/influxdb/v1.7/query_language/schema_exploration/)

# Hardware
## Memory
### Add memory and make it visible by Debian OS
Even if you add memory with VMWare, debian won't see it `free -m`
You have to make it 'online'
```bash
grep offline /sys/devices/system/memory/*/state | while read line; do echo online > ${line/:*/}; done
```

## Storage
can be
- Disk
- SSD
- SD card (mmc)
### List where your devices are located
Your devices are hardwarely recognize by the kernel and then linked on the system with a file (because on linux, everything is a file) by udev (micro device) (systemd-udevd.service) `not file system related`
```bash
dmesg -T

sudo udevadm monitor
```

### Burn a an image to an SD card
```bash
dd \
if=/home/baptiste/Downloads/2019-09-26-raspbian-buster-lite.img \
of=/dev/mmcblk0 \
bs=64K \
conv=noerror,sync \
status=progress
```
[Full perfect archlinux doc](https://wiki.archlinux.org/index.php/Dd#Remove_bootloader)

### Remove only the MBR of a disk
How to zeroe the first 512 bytes (MBR size) of a disk
```bash
dd \
if=/dev/zero \
of=/dev/mmcblk0 \
bs=512 count=1 \
conv=noerror,sync \
status=progress
```

## LVM
LVM stands for Logical Volume Management  
Basically, you have 3 nested levels in lvm
- __Physical volume__ (`pv`)
- __Volume Group__ (`vg`)
- __Logical volume__ (`lv`) which is the only one you can mount on a system
### Enlarge LVM parition with additional disk
list disks
```bash
lsblk
```

Run fdisk to manage disks 
```bash
fdisk /dev/sdx
m n p
t #### new partition
8e #### for partition type "Linux LVM"
w #### write changes on disk
```

Initialize a disk or PARTITION for use by LVM  
/dev/sdx : file system path of a __physical__ disk  
/dev/sdxX : file system path of a __partition__ of a physical disk  
```bash
pvcreate /dev/sdxX
```

Add physical volumes to a volume group (/dev/sdb1)
```bash
vgdisplay /dev/sdaX
```
```bash
vgextend system-vg /dev/sdbx
```

Extend the size of a logical volume
```bash
lvextend -l +100%FREE /dev/vg_data/lv_data
```
`/dev/vg_data/lv_data` is still a mountable device with a __greater physical size__ but with the __same file system size__ as previous. So you need to extend the fs to the new extended physical size.  

```bash
resize2fs /dev/VG_Name/LV_Name
```

Optional : notice that lvm create a directory with vg name and subfile with lv name  
```bash
resize2fs /dev/HOSTNAME-vg/root
resize2fs /dev/system-vg/root
```

Ensure the __extend procedure__ has succeed don't use `lsblk` Bbut `df` instead
```bash
df -h 
```



### Add a disk on system and mount it on new root directory (/data)
Create the new directory 
```bash
mkdir /data
```

1 - create the __physical volume__
```bash
pvcreate /dev/sdb
pvdisplay
```

2 - create the __volume group__
```bash
vgcreate vg_NAME /dev/sdb
vgdisplay
```

3 - create the logical volume
```bash
lvcreate -l +100%FREE -n lv_NAME vg_NAME
lvdisplay
```

4 - Create the file system
```bash
mkfs.ext4 /dev/mapper/vg_NAME-lv_NAME
```

5 - mount the Logicial Volume in /data
```bash
mount /dev/mapper/vg_NAME-lv_NAME /data
```

6 - Optional but recommended. Make persistent the mount of the lv even after reboot.  
copy the first line, and replace with LV path
```bash
vim /etc/fstab
```


### Delete partition in a disk
Follow the instruction
```bash
cfdisk /dev/sdb
```


### Reduce a LV size
If you want to remove a physical disk contained in a LV
[Tutorial](https://www.rootusers.com/lvm-resize-how-to-decrease-an-lvm-partition/)



### Various LVM commands
```bash
pvs
pvdisplay
vgdisplay
lvdisplay
fdisk -l
```
### How to remove bad disk from LVM2 with the less data loss on other PVs
```bash
# pvdisplay
Couldnt find device with uuid EvbqlT-AUsZ-MfKi-ZSOz-Lh6L-Y3xC-KiLcYx.
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               vg_srvlinux
  PV Size               931.51 GiB / not usable 4.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               0
  Allocated PE          238466
  PV UUID               xhwmxE-27ue-dHYC-xAk8-Xh37-ov3t-frl20d

  --- Physical volume ---
  PV Name               unknown device
  VG Name               vg_srvlinux
  PV Size               465.76 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              119234
  Free PE               0
  Allocated PE          119234
  PV UUID               EvbqlT-AUsZ-MfKi-ZSOz-Lh6L-Y3xC-KiLcYx



#### vgreduce --removemissing --force vg_srvlinux


  Couldnt find device with uuid EvbqlT-AUsZ-MfKi-ZSOz-Lh6L-Y3xC-KiLcYx.
  Removing partial LV LogVol00.
  Logical volume "LogVol00" successfully removed
  Wrote out consistent volume group vg_srvlinux

#### pvdisplay

 --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               vg_srvlinux
  PV Size               931.51 GiB / not usable 4.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              238466
  Free PE               238466
  Allocated PE          0
  PV UUID               xhwmxE-27ue-dHYC-xAk8-Xh37-ov3t-frl20d
```


## Listing
```bash
lspci
```
list you graphic card
```bash
lspci | grep -E "(VGA|3D)" -C 2
lsusb
lscpu : human readable of /proc/cpuinfon
less /proc/cpuinfo
cat /proc/meminfo
nproc
```

## Monitor
Xrandr common cmd
```bash
xrandr --help
xrandr --current

xrandr --output DP-2 --mode 1680x1050 --primary
xrandr --output DP-1 --mode 1280x1024 --right-of DP-2

xrandr --output DP-1 --auto --right-of eDP-1
xrandr --output HDMI-1 --auto --right-of DP-1

```
#### Troubleshooting
Monitor plugged in but not displaying anything
```bash
xrandr --auto
sudo dpkg-reconfigure libxrandr2
```
logout of your current Windows Manager (like I3 or cinnamon, or gnome), then select another one. Then logout and go back to your prefered WM. It may resolve the error.


# Virtualization
Virtualization (OS-level)  
OS-level virtualization refers to an operating system __paradigm__ in which the kernel allows the existence of multiple isolated user-space instances. Such instances, called
- __containers__ (Solaris, Docker)
- __Zones__ (Solaris)
- __virtual private servers__ (OpenVZ)
- __partitions__
- __virtual environments__ (VEs)
- __virtual kernel__ (DragonFly BSD)
- __jails__ (FreeBSD jail or chroot jail)

Those instance may __look like__ real computers from the point of view of programs running in them.  

- A computer program running on an ordinary operating system can see all resources (connected devices, files and folders, network shares, CPU power, quantifiable hardware capabilities) of that computer.
- However, programs running inside of a container can only see the container's contents and devices assigned to the container.  

#### __Overhead__
Operating-system-level virtualization usually imposes less overhead than full virtualization because programs in virtual partitions __use the operating system's normal system call interface__ and do not need to be subjected to emulation or be run in an intermediate virtual machine, __as is the case with full virtualization__ (such as VMware ESXi, QEMU or Hyper-V) and paravirtualization (such as Xen or User-mode Linux). This form of virtualization also does not require hardware support for efficient performance.   
[Wikipedia of Virtualization OS-level](https://en.wikipedia.org/wiki/OS-level_virtualization)

## Docker

```
Docker CLI -> Docker Engine -> containerd -> containerd-shim -> runC (or other runtime)
```
Note that dockerd (docker daemon) has no child. The master process of all containers is `containerd`.  
There is __only one containerd-shim by process__ and it manages the STDIO FIFO and keeps it open for the container in case containerd or Docker dies.

runC is built on libcontainer which is the same container library powering a Docker engine installation. Prior to the version 1.11, Docker engine was used to manage volumes, networks, containers, images etc.. Now, the Docker architecture is broken into four components: Docker engine, containerd, containerd-shm and runC. The binaries are respectively called docker, docker-containerd, docker-containerd-shim, and docker-runc.  
To run a container, Docker engine creates the image, pass it to containerd. containerd calls containerd-shim that uses runC to run the container.  
__Then, containerd-shim allows the runtime (runC in this case) to exit after it starts the container : This way we can run daemon-less containers because we are not having to have the long running runtime processes for containers.__

![GitHub Logo](./src/docker_architecture.jpeg)

[Sources](https://medium.com/faun/docker-containerd-standalone-runtimes-heres-what-you-should-know-b834ef155426)

### Find all the containerized process on the system

Get pid of containerd
```bash
pidof containerd
921
```

Get child of containerd (i.e. pid of containerd-shim) i.e. search for process who has for parent process containerd ( hence --ppid )
```bash
ps -o pid --no-headers --ppid $(pidof containerd)
19485
```

Get child of containerd-shim (i.e. the real final containerized process)
```bash
ps -o pid --no-headers --ppid $(ps -o pid --no-headers --ppid $(pidof containerd))
19502
```

Get the name of the output process
```bash
ps -p $(ps -o pid --no-headers --ppid $(ps -o pid --no-headers --ppid $(pidof containerd))) -o comm=
bash
```


### Run
```bash
docker run -d \
--name elasticsearch \
--net somenetwork \
--volume my_app:/usr/share/elasticsearch/data \
-p 9200:9200 -p 9300:9300 \
-e "discovery.type=single-node" \
elasticsearch:7.4.1
```

### Run a single command and output
(no interactive)
```bash
docker run debian ls

docker run debian /bin/bash -c 'cd /home ; ls -l'

docker run debian \
/bin/bash -c 'http_proxy=http://10.100.100.100:1598 apt update ; http_proxy=http://10.100.100.100:1598 apt install netcat -y ; nc -zvn 10.3.3.3 3306'
```

#### Volumes
```bash
docker volume create my_app
```

#### Cheat sheet
avoid false positives  
^ : begin with  
$ : end with  
```bash
docker ps -aqf "name=^containername$"
```

Print only running command
```bash
docker ps --format "{{.Command}}" --no-trunc
```
Resources management
```bash
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
docker stats --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" --no-stream
```

Info of filesystem
```bash
docker inspect -f '{{ json .Mounts }}' $(docker ps -aqf "name=elasticsearch") | jq
```

## Docker Swarm
(On swarm __manager__) find where an app is running. Find the last updated date
```bash
docker service ps <app_name>

docker service inspect log-master_logstash -f '{{ json .UpdatedAt }}'
```

print cluster nodes
```bash
docker node ls
```

get address + role
```bash
for node in $(docker node ls -q); do     docker node inspect --format '{{.Status.Addr}} ({{.Spec.Role}})' $node; done
```

Print labels of nodes
```bash
docker node ls -q | xargs docker node inspect \
  -f '[{{ .Description.Hostname }}]: {{ range $k, $v := .Spec.Labels }}{{ $k }}={{ $v }} {{end}}'
```

### Join new node
swarm manager shell
```bash
docker swarm join-token worker
```
We output a copy pastable bash line, like the following ! (Be carefull it doesn't include listen ip of the worker)

new worker shell

```bash
docker swarm join \
  --token <TOKEN_WORKER> \
  --listen-addr WORKER-LISTEN-IP:2377 \
   <MANGER-LISTEN-IP>:2377
```


# Kubernetes
## Context
Create you a context to work easier  
__context__ = `given_user` + `given_cluster` + `given_namespace`

```bash
kubectl config set-context bdauphin-training \
--user b.dauphin-k8s-home-cluster \
--cluster k8s-home-cluster \
--namespace dev-scrapper
```

Print your current context and cluster info
```bash
kubectl config get-contexts
kubectl cluster-info
```



## Deployment
A Deployment provides declarative updates for Pods and ReplicaSets.

You describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate. You can define Deployments to create new ReplicaSets, or to remove existing Deployments and adopt all their resources with new Deployments.  
```bash
kubectl create deployment nginx-test-deploy --image nginx -n bdauphin-test
```

## Pod
I do not recommend to declare a pod directly. Prefer using deploy

> Restart a pod
The quickest way is to set the number of replica to zero and then, put back your desired number of rep
```bash
kubectl scale deployment nginx --replicas=0
kubectl scale deployment nginx --replicas=5
```
[good tuto](https://medium.com/faun/how-to-restart-kubernetes-pod-7c702ca984c1)

## Service
```bash
kubectl create service nodeport bdauphin-nginx-test --tcp=8080:80
```

## ConfigMap
ConfigMaps allow you to decouple configuration artifacts from image content to keep containerized applications portable. This page provides a series of usage examples demonstrating how to create ConfigMaps and configure Pods using data stored in ConfigMaps.

Most of the time it's a list of key-value pairs  

It can be defined as environment variables  
and/or
Be mounted into the pod at a specified path

## Secrets
Kubernetes secret objects let you store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Putting this information in a secret is safer and more flexible than putting it verbatim in a Pod definition or in a container image . See Secrets design document for more information.

## RBAC
Role-based access control (RBAC) is a method of regulating access to computer or network resources based on the roles of individual users within an enterprise.  
[complete doc](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)

* Role : defines rules 
* Role Binding

### Role
Defines  
- __Rules__
  - __API Groups__  
  default : core API group
  - __resources__  
  ex : pod
  - __verbs__  
  allowed methods

A Role can only be used to grant access to resources within a single namespace. Here’s an example Role in the “default” namespace that can be used to grant read access to pods:  

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]  #### "" indicates the core API group
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```


### RoleBinding
Defines  
- __Subjects__
  - __Kind__  
  ex : user
  - __name__  
  ex : jane
  - __apiGroup__  
- __Role References__
  - __Kind__  
  ex : Role
  - __name__  
  ex : pod-reader
  - __apiGroup__  

A role binding grants the permissions defined in a role to a user or set of users. It holds a list of subjects (users, groups, or service accounts), and a reference to the role being granted. Permissions can be granted within a namespace with a RoleBinding, or cluster-wide with a ClusterRoleBinding.


Example  
This role binding allows "jane" to read pods in the "default" namespace.
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: jane #### Name is case sensitive
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role #### this must be Role or ClusterRole
  name: pod-reader #### this must match the name of the Role or ClusterRole you wish to bind to
  apiGroup: rbac.authorization.k8s.io
```

## Ingress
An API object that manages external access to the services in a cluster, typically HTTP.  
Ingress can provide load balancing, SSL termination and name-based virtual hosting.

__What is ingress ?__  
Ingress exposes HTTP and HTTPS routes from outside the cluster to services within the cluster. Traffic routing is controlled by rules defined on the Ingress resource.

```
  internet
      |
 [ Ingress ]
 --|-----|--
 [ Services ]
```

An Ingress can be configured to give Services externally-reachable URLs, load balance traffic, terminate SSL / TLS, and offer name based virtual hosting. An Ingress controller is responsible for fulfilling the Ingress, usually with a load balancer, though it may also configure your edge router or additional frontends to help handle the traffic.

An Ingress does not expose arbitrary ports or protocols. Exposing services __other than HTTP and HTTPS__ to the internet typically uses a service of type __Service.Type=NodePort__ or __Service.Type=LoadBalancer__.




## Config extraction
__Why use config file instead of CLI ?__
* Cli is good for begin, help to understand. But heavy to use everyday
* Often complexe definition, easier to use a config file
* Can version (git)

```bash
kubectl get deploy nginx                              -o yaml | tee nginx-deploy.yaml
kubectl get serviceaccounts/default -n bdauphin-test  -o yaml | tee serviceaccounts.yaml
kubectl get pods/nginx-65d61548fd-mfhpr               -o yaml | tee pod.yaml
```

## Common cmd
first, get all into your current namespace. Or specify another one
```bash
watch -n 1 kubectl get all -o wide
watch -n 1 kubectl get all -o wide -n default
```

## Helm
Client : helm  
Server : tiller

Helm uses go template render engine 

### Generate your first chart
```bash
helm create $mychart
helm create elasticsearch
```

Helm will create a new directory in your project called mychart with
```bash
elasticsearch
├── charts
├── Chart.yaml
├── templates
│   ├── deployment.yaml
│   ├── _helpers.tpl
│   ├── ingress.yaml
│   ├── NOTES.txt
│   ├── service.yaml
│   └── tests
│       └── test-connection.yaml
└── values.yaml
```

### Templates
The most important piece of the puzzle is the `templates/` directory.  

It’s worth noting however, that the directory is named templates, and Helm runs each file in this directory through a [Go template](https://golang.org/pkg/text/template/) rendering engine.

```bash
helm install --dry-run --debug ./elasticsearch
helm install ./elasticsearch
```

### Values
The template in service.yaml makes use of the Helm-specific objects `.Chart` and `.Values`.

Values | Default | override | meaning
-|-|-|-
`.Chart` |  |  | provides metadata about the chart to your definitions such as the name, or version
`.Values` | `values.yaml` | `--set key=value`, `--values $file` | key element of Helm charts, used to expose configuration that can be set at the time of deployment

For more advanced configuration, a user can specify a YAML file containing overrides with the `--values` option.

```bash
helm install --dry-run --debug ./mychart --set service.internalPort=8080
helm install --dry-run --debug ./mychart --values myCustomeValues.yaml
```

### Worth knowing cmd
As you develop your chart, it’s a good idea to run it through the linter to ensure you’re following best practices and that your templates are well-formed. Run the helm lint command to see the linter in action:
```bash
helm lint ./mychart
==> Linting ./mychart
[INFO] Chart.yaml: icon is recommended

1 chart(s) linted, no failures
```

# CentOS
CentOS specific commands which differs from debian
## Iptables
```bash
iptables-save > /etc/sysconfig/iptables
```
## OS Version
```bash
cat /etc/system-release
CentOS Linux release 7.6.1810 (Core)
```
## Yum
```bash
yum install httpd
yum remove  postgresql.x86_64
yum update postgresql.x86_64
yum search firefox
yum info samba-common.i686

yum groupinstall 'DNS Name Server'

yum repolist

yum check-update

yum list | less
yum list installed | less
yum provides /etc/sysconfig/nf
yum grouplist

yum list installed | grep unzip
```
`to be updated...`

# ArchLinux
Installation
## File system
### EFI
#### fs creation
```
mkfs.fat -F32 /dev/sdb5
```

#### fstab
```
/dev/sdb5 /efi vfat rw,relatime 0 2
```


## Grub

### install grub executable
```
pacman -S grub
```

### install grub directory
##### your grub name will be "GRUB_ARCH"
```
grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=GRUB_ARCH
```

### generate grub config (update-grub equivalent)
```
grub-mkconfig -o /boot/grub/grub.cfg
```

## package manager
#### full system upgrade
```
pacman -Syu
```

#### Query installed/local packages by regex
sudo pacman -Qsq pulseaudio

### Pacman apt equivalent
https://wiki.archlinux.org/index.php/Pacman/Rosetta
### My packages
```
sudo pacman -S pulseaudio tree xf86-video-intel mesa-dri opencl-nvidia sudo polkit lxsession kernel headers git gdm terminator keepass firefox
```

## Wi-Fi
#### With gdm (gnome desktop manager)
You have just have to use the service NetworkManager, which it way much more simple than other wireless connection manager (like wicd, netctl).
NetworkManager will allow you to graphically setup once your wifi settings and autodiscover SSID.
```
systemctl start NetworkManager
# and enable it at boot, by default no wifi connection manager is enable on archlinux
systemctl enable NetworkManager
```
Then, fill in your infos in your graphical wifi settings

# Miscellaneous
## Raspberry
### Raspbian Release
#### Latest
https://www.raspberrypi.org/downloads/raspbian/

## Sublime-text
### Preparing package installation
Before, you can download and install awesome packages, you first have to install the __Package Control package__. It's dumb, but it's not included in sublime-text installation...

The simplest method of installation is through the Sublime Text console. The console is accessed via the __ctrl+\`__ shortcut or the __View > Show Console__ menu. Once open, paste the appropriate Python code for your version of Sublime Text into the console. 

```python
import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by) 
```
[official source](https://packagecontrol.io/installation)
This code creates the Installed Packages folder for you (if necessary), and then downloads the Package Control.sublime-package into it. The download will be done over HTTP instead of HTTPS due to Python standard library limitations, however the file will be validated using SHA-256.


### Install a package (__insp__)
Open __commande palette__
```
ctrl + shift + p
```
Then, open __sublime-text package manager__, select __Package Control: Install package__ by shortname __insp__
```
insp
```
Then, enter

### My packages

Name | Usage | __insp__ name| URL
----|----|-----|------
Markdown Preview | To see a preview of your README.md files before commit them | `MarkdownPreview` | https://facelessuser.github.io/MarkdownPreview/install/
Compare Side-By-Side | Compares two tabs | `Compare Side-By-Side` | https://packagecontrol.io/packages/Compare%20Side-By-Side
Generic Config | Syntax generic config colorization |
PowerCursors | multiple cursors placements |
Materialize | Several beautiful __color scheme__
MarkdownPreview | Preview your .md file 
Markdown​TOC | Generate your Table of content of MarkDown files

### Shortcut

Name | shortcut
-----|---------
Do anything (command palet) | `Ctrl + Shirt + P`
Switch previous / next tab | `ctrl + shift + page_up` \ `ctrl + shift + page_down`
Switch to a specific tab | `ctrl + p`, and write name of your tab (file)
Move a line or a block of line | `ctrl + shift + arrow up` \ `ctrl + shift + arrow down`
Switch upper case | `Ctrl + k` and then `Ctrl + u`
Switch lower case | `Ctrl + k` and then `Ctrl + l`
Sort Lines | `F9` (Edit > Sort Lines)
Goto anywhere | `Ctrl + R`
Open any file | `Ctrl + P`
Goto line number | `ctrl + G`
Spell check | `F6`
New cursor above/below | `alt+shift+arrow`


#### older
Lite images: https://downloads.raspberrypi.org/raspbian_lite/images/  
With desktop: https://downloads.raspberrypi.org/raspbian/images/  
With desktop & recommended software: https://downloads.raspberrypi.org/raspbian_full/images/

## Regex
Excellent tutorial  
https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285

Online tester  
https://regex101.com/

## Markdown
[Support highlight syntax](https://support.codebasehq.com/articles/tips-tricks/syntax-highlighting-in-markdown)
[GitHub guide - Master Markdown tutorial](https://guides.github.com/features/mastering-markdown/)

## Pimp my terminal
[Source](https://hackernoon.com/how-to-trick-out-terminal-287c0e93fce0)
gnome-terminal
GNOME Terminal (the default Ubuntu terminal): `Open Terminal` → `Preferences` and click on the selected profile under `Profiles`. Check Custom font under Text Appearance and select `MesloLGS NF Regular` or `Hack` or the font you like.

### Debian
1- Ensure that your terminal is `gnome-terminal`
```bash
update-alternatives --get-selections | grep -i term
x-terminal-emulator            manual   /usr/bin/gnome-terminal.wrapper
```

#### Graphicaly
Install  `dconf`
```bash
sudo apt-get install dconf-tools
dconf-editor
```
Run it and go to path `org` > `gnome` > `desktop` > `interface` > `monospace-font-name`

CLI
gsettings offers a simple commandline interface to GSettings. It lets you get, set or monitor an individual key for changes.  
__To *Know* current settings type following commands in terminal :__
```bash
gsettings get org.gnome.desktop.interface document-font-name
gsettings get org.gnome.desktop.interface font-name 
gsettings get org.gnome.desktop.interface monospace-font-name
gsettings get org.gnome.nautilus.desktop font
```
__You can *set* fonts by following commands in terminal :__
For example `Monospace 11` do not support symbol. Which is uggly if you have a custom shell.  
My choises which differs from default :  
The last __number argument__ is the size
> for terminal
```bash
gsettings set org.gnome.desktop.interface monospace-font-name 'Hack 12'
```
> for soft like Keepass2
```bash
gsettings set org.gnome.desktop.interface font-name 'Hack 12'
```
__Get list of available fonts__
```bash
fc-list | more
fc-list | grep -i "word"
fc-list | grep -i UbuntuMono
```
To lists font faces that cover Hindi language:
```bash
fc-list :lang=hi
```
search by family
```bash
fc-list  :family="NotoSansMono Nerd Font Mono"
```
search with complete name
```bash
fc-list  :fullname="Noto Sans Mono ExtraCondensed ExtraBold Nerd Font Complete Mono"
```

To find all similar keys on schema type following command:
```bash
gsettings list-recursively org.gnome.desktop.interface
```
To reset all valuses of keys run following command in terminal:
```bash
gsettings reset-recursively org.gnome.desktop.interface
```

## xdg-settings / update-alternatives
In some case, __update-alternatives__ is not enough. Especially for __Url Handling or web browsing__  
`xdg-settings - get various settings from the desktop environment`

### Set brave as default browser
In my use case, I set up update-alternatives but it didn't change the behaviour for URL handling (printed in my terminal especially useful after `git push` for creating a merge request).  
Correctly setup but doesn't affect behaviour
```
sudo update-alternatives --config x-www-browser
```

```bash
xdg-settings check default-web-browser brave.desktop
no

xdg-settings --list default-url-scheme-handler
Known properties:
  default-url-scheme-handler    Default handler for URL scheme
  default-web-browser           Default web browser


xdg-settings get default-web-browser
firefox-esr.desktop


```


# Definitions
Name | TLDR meaning | further explanations
-|-|-
TLDR | Too long I didn't read | [:book:](https://en.wikipedia.org/wiki/Wikipedia:Too_long;_didn%27t_read)
CLI / Promt| Command Line Interpreter / Interface en ligne de commande. Different from Graphical mouse clickable | [:book:]()
Shell Linux | CLI of Linux (sh,bash,dash,csh,tcsh,zsh) | [:book:](https://fr.wikipedia.org/wiki/Shell_Unix#Shells)
Java Heap | shared among all Java virtual machine threads. The heap is the runtime data area from which memory for all __class__ instances and __arrays__ is allocated. | [:book:](https://alvinalexander.com/java/java-stack-heap-definitions-memory)
Java Stack | Each Java virtual machine thread has a private Java virtual machine stack holding __local variables__ and partial results, and plays a part in __method invocation__ and __return__ | [:book:](https://alvinalexander.com/java/java-stack-heap-definitions-memory)
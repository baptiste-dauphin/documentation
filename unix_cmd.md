# shell
## Environment variable
#### set variables to current __shell__
```
export http_proxy=http://10.10.10.10:9999
```
#### set variables only for the next line __execution__
```
http_proxy=http://10.10.10.10:9999 wget -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub
```
#### Export multiple env var
```
export {http,https,ftp}_proxy="http://10.10.10.10:9999"

export http_proxy=http://10.10.10.10:9999/
export https_proxy=$http_proxy
export ftp_proxy=$http_proxy
export rsync_proxy=$http_proxy
export no_proxy="localhost,127.0.0.1,localaddress,.localdomain.com"
```
#### Unset env var
```
unset http_proxy unset https_proxy unset HTTP_PROXY unset HTTPS_PROXY unset
```
# Bash test

|Operator   |   Description|
|-------------------|-------------|
|! EXPRESSION  |  The EXPRESSION is false.|
|-n STRING   |  The length of STRING is greater than zero.|
|-z STRING   |  The lengh of STRING is zero (ie it is empty).|
|STRING1 = STRING2 |STRING1 is equal to STRING2|
|STRING1 != STRING2 | STRING1 is not equal to STRING2|
|INTEGER1 -eq INTEGER2  | INTEGER1 is numerically equal to INTEGER2|
|INTEGER1 -gt INTEGER2  | INTEGER1 is numerically greater than INTEGER2|
|INTEGER1 -lt INTEGER2  | INTEGER1 is numerically less than INTEGER2|
|-d FILE  | FILE exists and is a directory.|
|-e FILE |  FILE exists.|
|-f FILE |  True if file exists AND is a regular file.|
|-r FILE |  FILE exists and the read permission is granted.|
|-s FILE |  FILE exists and its size is greater than zero (ie. it is not empty).|
|-w FILE |  FILE exists and the write permission is granted.|
|-x FILE |  FILE exists and the execute permission is granted.|
|-eq 0    |        COMMAND result equal to 0|

```bash
if [ -f /tmp/test.txt ]; then echo "true"; else echo "false"; fi
```
## Boolean
```bash
$ true && echo howdy!
howdy!

$ false || echo howdy!
howdy!
```

### For
```bash
for i in `seq 1 6`
do
mysql -h 127.0.0.1 -u user -p password -e "show variables like 'server_id'; select user()"
done
```

# symbolic link
## update sym link
```bash
ln -sfTv /opt/DSS/DnsAdminWUI_$TAG /opt/DSS/DnsAdminWUI_current
```

# OpenVpn
#### Run OpenVpn client in background, immune to hangups, with output to a non-tty
```
cd /home/baptiste/.openvpn && \
nohup sudo openvpn /home/baptiste/.openvpn/b_dauphin@vpn.domain.com.ovpn
```

# Network
#### ifconfig, netstat, rarp, route
```
apt install net-tools iproute2
```
##### get IP of the system
```
ip a
```
##### get routes of the system
```
ip r
```
##### modify default route
```
ip route change default via 99.99.99.99 dev ens8 proto dhcp metric 100
```
##### add (failover) IP to a NIC
```
ip addr add 88.88.88.88/32 dev ens4
```

##### netplan, new ubuntu network manager
```
cat /{lib,etc,run}/netplan/*.yaml
```
##### Show connections, listening process etc
```
netstat -plnt : p(PID), l(LISTEN), t(tcp), n(Convert names) 
netstat -pat : p(PID), a(all)(ESTABLISHED (default) + LISTEN), t(tcp)
netstat -lapute
netstat -salope
netstat -tupac
# ça donne un peu plus dinfo sur les process qui listen
ss -tulipe

```


#### List ports a process PID is listening on
```
lsof -Pan -p $PID -i
# ss version
ss -l -p -n | grep ",1234,"
```




#### Systemd (-networkd) network management with [debian 9]
```
vim /etc/systemd/network/50-default.network
systemctl status systemd-networkd
systemctl restart systemd-networkd
```

#### network - ENI - old management
##### vlan tagging and route add 
```
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



## Activer le NAT
```
iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o eth0 -j MASQUERADE
```

## netcat
### Listen
```
nc -l 127.0.0.1 -p 80
nc -lvup 514

# listen all ip on tcp port 443
nc -lvtp 443
```
### Check port opening
only for TCP (obviously), UDP is not connected protocol
```
nc -znv 10.10.10.10 3306
```

### fake network message with netcat
```
echo '<187>Apr 29 15:26:16 qwarch plop[12458]: baptiste' | nc -u 10.10.10.10 1514
```

# OpenSSL, TLS, private key, rsa, ecdsa

#### Get info of a certificate from internet
```
openssl s_client -connect www.qwant.com:443 -servername www.qwant.com   < /dev/null | openssl x509 -text
openssl s_client -connect qwant.com:443 -servername qwant.com           < /dev/null | openssl x509 -noout -fingerprint
openssl s_client -connect qwantjunior.fr:443 -servername qwantjunior.fr < /dev/null | openssl x509 -text -noout -dates
```

#### Get info about a certificate from the file (.pem)
```
openssl x509 --text --noout --in /etc/ssl/private/sub.domain.tld.pem
```

#### get system CA
```
ls -l /usr/local/share/ca-certificates
ls -l /etc/ssl/certs/
```
#### refresh system CA after changing files in the folder
```
sudo update-ca-certificates
```

### Generate __Certificate Signing Request__ (csr) + the associate private key
Will generates both private key and csr token
```
openssl req -nodes -newkey rsa:4096 -sha256 -keyout sub.mydomain.tld.key -out sub.mydomain.tld.csr -subj "/C=FR/ST=France/L=PARIS/O=My Company/CN=sub.mydomain.tld"
```
You can verify the content of your csr token here :
[DigiCert Tool](https://ssltools.digicert.com/checker/views/csrCheck.jsp)


# Systemd
## Journal
### Definition
journalctl is a command for viewing logs collected by systemd. The systemd-journald service is responsible for systemd’s log collection, and it retrieves messages from the kernel, systemd services, and other sources.

These logs are gathered in a central location, which makes them easy to review. The log records in the journal are structured and indexed, and as a result journalctl is able to present your log information in a variety of useful formats.

##### Run the journalctl command without any arguments to view all the logs in your journal:
```
journalctl
```
Each line starts with the date (in the server’s local time), followed by the server’s hostname, the process name, and the message for the log

##### To reverse this order and display the newest messages at the top
```
journalctl -r
```

#### Paging through Your Logs

##### journalctl pipes its output to the __less__ command
| Key command       |      Action |
|-------------------|-------------|
| down arrow key, enter, e, or j | Move down one line. |
| up arrow key, y, or k |  Move up one line. |
| space bar  | Move down one page. |
| b |  Move up one page. |
| right arrow key |  Scroll horizontally to the right. |
| left arrow key | Scroll horizontally to the left. |
| g  | Go to the first line. |
| G  | Go to the last line. |
| 10g  | Go to the 10th line. Enter a different number to go to other lines. |
| 50p or 50% | Go to the line half-way through the output. Enter a different number to go to other percentage positions. |
| /search term | Search forward from the current position for the search term string. |
| ?search term | Search backward from the current position for the search term string. |
| n |  When searching, go to the next occurrence. |
| N  | When searching, go to the previous occurrence. |
| m<c> | Set a mark, which saves your current position. Enter a single character in place of <c> to label the mark with that character. |
| '<c> | Return to a mark, where <c> is the single character label for the mark. Note that ' is the single-quote. |
| q  | Quit less |

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
| Format Name  | Description |
|----------|-------------|
| short |  The default option, displays logs in the traditional syslog format. |
| verbose  | Displays all information in the log record structure. |
| json | Displays logs in JSON format, with one log per line. |
| json-pretty  | Displays logs in JSON format across multiple lines for better readability. |
| cat  | Displays only the message from each log without any other metadata. |

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

| Setting  | Description |
|----------|-------------|
| SystemMaxUse | The total maximum disk space that can be used for your logs. |
| SystemKeepFree | The minimum amount of disk space that should be kept free for uses outside of systemd-journald’s logging functions. |
| SystemMaxFileSize  | The maximum size of an individual journal file. |
| SystemMaxFiles | The maximum number of journal files that can be kept on disk. |

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


# Monitor, screen
### Xrandr
```
xrandr --help
xrandr --current

xrandr --output DP-2 --mode 1680x1050 --primary
xrandr --output DP-1 --mode 1280x1024 --right-of DP-2

xrandr --output DP-1 --auto --right-of eDP-1
xrandr --output HDMI-1 --auto --right-of DP-1

```
#### Troubleshooting
__Monitor plugged in but not displaying anything__
```
xrandr --auto
sudo dpkg-reconfigure libxrandr2
logout of your current Windows Manager (like I3 or cinnamon, or gnome), then select another one. Then logout and go back to your prefered WM. It may resolve the error.
```


# Git
## Branch
```
git checkout dev
git checkout master
git checkout branch
```

## Commit
```
git checkout ac92da0124997377a3ee30f3159cdee838bd5b0b
```

## Stash
```bash
# (go at the previous commit)
# will uncommit your last changes
git reset --soft HEAD^
git stash
# verify
git stash show
# enventually FF merge without any conflict
git pull


# put back your work
git stash pop
# commit again
history | grep "git commit" | tail
git commit "copy-paste history commit message :)"
```

## Tag
### checkout to a specific tag
```
git checkout v_0.9
```

### Get the current tag version
```
git describe --tags --exact-match HEAD
```

### git log
##### Find commit by author or since a specific date
```
git log --author="g.allard" \
    --since="2 week ago"
```

##### Find n last commit
```
git log --author="g.allard" \
    -3
```
#### only print specific info from commits
##### author
```
git log --since="2 week ago" \
    --pretty=format:"%an"
```
##### hash, author name, date, message
```
git log --author="g.allard"  \
    --since="2 week ago" \
    --pretty=format:"%h - %an, %ar : %s"
```

##### Show modification of specific commits
```
git show 01624bc338d4a89c09ba2915ff25ce08174b8e93 3d9228fa99eab6c208590df91eb2af05daad8b40
```

# Tmux

Depuis le shell, avant de rentrer dans une session tmux
```bash
$ tmux ls
$ tmux new
$ tmux new -s session
$ tmux attach
$ tmux attach -t session_name
$ tmux kill-server : kill all sessions
:setw synchronize-panes on
:setw synchronize-panes off
:set-window-option xterm-keys on
```

## [.tmux.conf]
```bash
set-window-option -g xterm-keys on
```


## Inside tmux

__Ctrl + B__ : (to press __each time before another command__)

| Command |  meaning |
|---------|----------|
| Flèches | = se déplacer dans le splitage des fenêtres |
| N | "Next window" |
| P | "Previous window" |
| z | : zoom in/out in the current span |
| d | : detach from the current and let it running on the background (to be reattached to later) |
| x | : kill |
| % |  vertical split |
| " |  horizontal split |
| o | : swap panes |
| q | : show pane numbers |
| x | : kill pane |
| + | : break pane into window (e.g. to select text by mouse to copy) |
| - | : restore pane from window |
| ⍽ | : space - toggle between layouts |

"prefix" usually is "alt gr"
| <prefix> q | (Show pane numbers, when the numbers show up type the key to goto that pane) |
| <prefix> { | (Move the current pane left) |
| <prefix> } | (Move the current pane right) |
| <prefix> z | toggle pane zoom |
| ":set synchronise-panes on" :|  synchronise_all_panes in the current session (to execute parallel tasks like multiple iperfs client)" |

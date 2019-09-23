# shell
### User
```bash
useradd -m -s /bin/bash b.dauphin
-m create home dir
-s shell path
```

### Group
Add user baptiste to sudoer
```bash
usermod -aG sudo baptiste
usermod -aG wireshark b.dauphin
```

### Change user
switch to root
```bash
su -
# switch to b.dauphin
su - b.dauphin
```

### Change password of a specific user
```bash
echo 'root:toto' | chpasswd
```

### sudo
Switch to root
You have to be __sudoer__ (i.e. being member of 'sudo' group)
```bash
# ensure you're in sudo group, by checking groups you belong to
groups

sudo su
```

# stream redirection
The `>` operator redirects the output usually to a file but it can be to a device. You can also use `>>` to append.
If you don't specify a number then the standard output stream is assumed but you can also redirect errors

* `>`file redirects stdout to file
* `1>` file redirects stdout to file
* `2>` file redirects stderr to file
* `&>`file redirects stdout and stderr to file

/dev/null is the null device it takes any input you want and throws it away. It can be used to suppress any output. 

is there a difference between `> /dev/null 2>&1` and `&> /dev/null` ?
> &> is new in Bash 4, the former is just the traditional way, I am just so used to it (easy to remember)


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
|$?| last exit code|
|$# | Number of parameters |
|$@ |expands to all the parameters|
|||
|||

# Bash worth known commands
file
tail -n 15 -f
head -n 15
w
who
wall
sudo updatedb
locate $file_name
echo app.$(date +%Y_%m_%d)
touch app.$(date +%Y_%m_%d)
mkdir app.$(date +%Y_%m_%d)

#### remove some characters __(__ and __)__ if found
.. | tr -d '()'


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
### Bash valide exemples
```bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
DIR="$(dirname "$0")"
```

## Bash knowledge
### Why is $(...) preferred over `...` (backticks)?
`...` is the legacy syntax required by only the very oldest of non-POSIX-compatible bourne-shells. There are several reasons to always prefer the $(...) syntax: 
#### Backslashes (\) inside backticks are handled in a non-obvious manner: 
```
$ echo "`echo \\a`" "$(echo \\a)"
  a \a
  $ echo "`echo \\\\a`" "$(echo \\\\a)"
  \a \\a
  # Note that this is true for *single quotes* too!
  $ foo=`echo '\\'`; bar=$(echo '\\'); echo "foo is $foo, bar is $bar" 
  foo is \, bar is \\
```
#### Nested quoting inside $() is far more convenient.
```
echo "x is $(sed ... <<<"$y")"
```
In this example, the quotes around $y are treated as a pair, because they are inside $(). This is confusing at first glance, because most C programmers would expect the quote before x and the quote before $y to be treated as a pair; but that isn't correct in shells. On the other hand, 
```
echo "x is `sed ... <<<\"$y\"`"
```

#### It makes nesting command substitutions easier. Compare: 
```
x=$(grep "$(dirname "$path")" file)
x=`grep "\`dirname \"$path\"\`" file`
```

# symbolic link
## update sym link
```bash
ln -sfTv /opt/DSS/DnsAdminWUI_$TAG /opt/DSS/DnsAdminWUI_current
```

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

### TcpDump
Just see what’s going on, by looking at all interfaces.
```bash
tcpdump -i any -w capturefile.pcap
tcpdump port 80 -w capture_file
tcpdump 'tcp[32:4] = 0x47455420'
```
https://danielmiessler.com/study/tcpdump/

#### Real time
```bash
tcpdump -n dst host ip
tcpdump -vv -i any port 514
tcpdump -i any -XXXvvv src net 10.0.0.0/8 and dst port 1234 or dst port 4321 | ccze -A
tcpdump -i any port not ssh and port not domain and port not zabbix-agent | ccze -A
```

#### udp dump
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

## Internet Exchange Point
[FranceIX](https://www.franceix.net/en/technical/france-ix-route-servers/)


# Public key certificate

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

# debian 7, openssl style
openssl x509 -text -in  /etc/ssl/private/sub.domain.tld.pem
```

| openssl s_client   args | comments |
|-|-|
|  -host host     | use -connect instead |
|  -port port     | use -connect instead |
|  -connect host:port | who to connect to (default is localhost:4433) |
|  -verify_hostname host | check peer certificate matches "host" |
|  -verify_email email | check peer certificate matches "email" |
|  -verify_ip ipaddr | check peer certificate matches "ipaddr" |
|  -verify arg   | turn on peer certificate verification |
|  -verify_return_error | return verification errors |
|  -cert arg     | certificate file to use, PEM format assumed |
|  -certform arg | certificate format (PEM or DER) PEM default |
|  -key arg      | Private key file to use, in cert file if not specified but cert file is.
|  -keyform arg  | key format (PEM or DER) PEM default |
|  -pass arg     | private key file pass phrase source |
|  -CApath arg   | PEM format directory of CA's |
|  -CAfile arg   | PEM format file of CA's |
|  -trusted_first | Use trusted CA's first when building the trust chain |
|  -no_alt_chains | only ever use the first certificate chain found |
|  -reconnect    | Drop and re-make the connection with the same Session-ID |
|  -pause        | sleep(1) after each read(2) and write(2) system call |
|  -prexit       | print session information even on connection failure |
|  -showcerts    | show all certificates in the chain |
|  -debug        | extra output |
|  -msg          | Show protocol messages |
|  -nbio_test    | more ssl protocol testing |
|  -state        | print the 'ssl' states |
|  -nbio         | Run with non-blocking IO |
|  -crlf         | convert LF from terminal into CRLF |
|  -quiet        | no s_client output |
|  -ign_eof      | ignore input eof (default when -quiet) |
|  -no_ign_eof   | don't ignore input eof |
|  -psk_identity arg | PSK identity |
|  -psk arg      | PSK in hex (without 0x) |
|  -ssl3         | just use SSLv3 |
|  -tls1_2       | just use TLSv1.2 |
|  -tls1_1       | just use TLSv1.1 |
|  -tls1         | just use TLSv1 |
|  -dtls1        | just use DTLSv1 |
|  -fallback_scsv | send TLS_FALLBACK_SCSV |
|  -mtu          | set the link layer MTU |
|  -no_tls1_2/-no_tls1_1/-no_tls1/-no_ssl3/-no_ssl2 | turn off that protocol |
|  -bugs         | Switch on all SSL implementation bug workarounds |
|  -cipher       | preferred cipher to use, use the 'openssl ciphers' command to see what is available
|  -starttls prot | use the STARTTLS command before starting TLS for those protocols that support it, where 'prot' defines which one to assume. Currently, only "smtp", "pop3", "imap", "ftp", "xmpp", "xmpp-server", "irc", "postgres", "lmtp", "nntp", "sieve" and "ldap" are supported. |
|  -xmpphost host | Host to use with "-starttls xmpp[-server]" |
|  -name host     | Hostname to use for "-starttls lmtp" or "-starttls smtp" |
|  -krb5svc arg  | Kerberos service name |
|  -engine id    | Initialise and use the specified engine -rand file:file:...
|  -sess_out arg | file to write SSL session to |
|  -sess_in arg  | file to read SSL session from |
|  -servername host  | Set TLS extension servername in ClientHello |
|  -tlsextdebug      | hex dump of all TLS extensions received |
|  -status           | request certificate status from server |
|  -no_ticket        | disable use of RFC4507bis session tickets |
|  -serverinfo types | send empty ClientHello extensions (comma-separated numbers) |
|  -curves arg       | Elliptic curves to advertise (colon-separated list) |
|  -sigalgs arg      | Signature algorithms to support (colon-separated list) |
|  -client_sigalgs arg | Signature algorithms to support for client certificate authentication (colon-separated list)
|  -nextprotoneg arg | enable NPN extension, considering named protocols supported (comma-separated list) |
|  -alpn arg         | enable ALPN extension, considering named protocols supported (comma-separated list) |
|  -legacy_renegotiation | enable use of legacy renegotiation (dangerous) |
|  -use_srtp profiles | Offer SRTP key management with a colon-separated profile list |
|  -keymatexport label   | Export keying material using label |
|  -keymatexportlen len  | Export len bytes of keying material (default 20) |


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
#### RSA style (old)
```bash
openssl req -nodes -newkey rsa:4096 -sha256 -keyout $(SUB.MYDOMAIN.TLD).key -out $(SUB.MYDOMAIN.TLD).csr -subj "/C=FR/ST=France/L=PARIS/O=My Company/CN=$(SUB.MYDOMAIN.TLD)"
```

#### Elliptic Curve (ECDSA) style (new)
```bash
# generate private key
openssl ecparam -out $(SUB.MYDOMAIN.TLD).key -name sect571r1 -genkey
# generate csr
openssl req -new -sha256 -key $(SUB.MYDOMAIN.TLD).key -nodes -out $(SUB.MYDOMAIN.TLD).csr -subj "/C=FR/ST=France/L=PARIS/O=My Company/CN=$(SUB.MYDOMAIN.TLD)"
```

You can verify the content of your csr token here :
[DigiCert Tool](https://ssltools.digicert.com/checker/views/csrCheck.jsp)




# Systemd
## Systemctl (system control)

#### show all installed unit files
systemctl list-unit-files --type=service

#### active / running / loaded
```bash
systemctl list-units --type=service --state=loaded
systemctl list-units --type=service --state=active
systemctl list-units --type=service --state=running
systemctl show --property=Environment docker
systemctl show docker --no-pager | grep proxy
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
![GitHub Logo](../src/git_cheat.png)

## Global info
```bash
git remote -v
git branch -v
```

### Edit remote URL
```bash
git remote set-url origin git@git.baptiste-dauphin.com:GROUP/SUB_GROUP/project_name
```

## Git Tag
```bash
# create tag at your current commit
git tag temp_tag_2

# By default tags are not __pushed__, nor __pulled__ 
git push origin tag_1 tag_2

# list tag
git tag -l

# delete tag
git tag -d temp_tag_2
```

## Git Checkout (branch)
```bash
git checkout dev
git checkout master
git checkout branch
```
## Git Diff
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

## Commit
```bash
git checkout ac92da0124997377a3ee30f3159cdee838bd5b0b
```

## Undo/move your work or avoid conflicts with __Git reset__ and __Git stash__
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

## Git Stash
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


## Git Merge conflict
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

You can tell him that you want your modifications take precedance 
So, in that case of __merge conflict__
```bash
# cancel your conflict by cancel the current merge,
git merge --abort

# Then, pull again telling git to keep YOUR local changes
git pull -X ours origin master

# Or if you want to keep only the REMOTE work
git pull -X theirs origin master
```

### Tag
```
### checkout to a specific tag
```bash
git checkout v_0.9
```

### Get the current tag version
```bash
git describe --tags --exact-match HEAD
```

### git log
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
#### only print specific info from commits
##### author
```bash
git log --since="2 week ago" \
    --pretty=format:"%an"
```
#### hash, author name, date, message
```bash
git log --author="b.dauphin"  \
    --since="2 week ago" \
    --pretty=format:"%h - %an, %ar : %s"
```

#### Show modification of specific commits
```bash
git show 01624bc338d4a89c09ba2915ff25ce08174b8e93 3d9228fa99eab6c208590df91eb2af05daad8b40
```

#### See changes to a specific file using git
```bash
git log --follow -p -- file
git --no-pager log --follow -p -- file
```

## Git Revert
The git revert command can be considered an 'undo' type command, however, it is not a traditional undo operation. __INSTEAD OF REMOVING the commit from the project history__, it figures out how to __invert the changes introduced by the commit and appends a new commit with the resulting INVERSE CONTENT__. This prevents Git from losing history, which is important for the integrity of your revision history and for reliable collaboration.

Reverting should be used when you want to apply the inverse of a commit from your project history. This can be useful, for example, if you’re tracking down a bug and find that it was introduced by a single commit. Instead of manually going in, fixing it, and committing a new snapshot, you can use git revert to automatically do all of this for you.

![GitHub Logo](../src/git_revert.svg)

```bash
git revert <commit hash>
git revert c6c94d459b4e1ed81d523d53ef81b6a4744eac12

# find a specific commit
git log --pretty=format:"%h - %an, %ar : %s"
```

## Git Reset
The __git reset__ command is a complex and versatile tool for undoing changes. It has three primary forms of invocation. These forms correspond to command line arguments __--soft__, __--mixed__, __--hard__. The three arguments each correspond to Git's three internal state management mechanism's, The Commit Tree (HEAD), The Staging Index, and The Working Directory.

Git reset & three trees of Git

To properly understand git reset usage, we must first understand Git's internal state management systems. Sometimes these mechanisms are called Git's "three trees".

![GitHub Logo](../src/git_reset.svg)

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
| q | (Show pane numbers, when the numbers show up type the key to goto that pane) |
| { | (Move the current pane left) |
| } | (Move the current pane right) |
| z | toggle pane zoom |
| ":set synchronise-panes on" :|  synchronise_all_panes in the current session (to execute parallel tasks like multiple iperfs client)" |


# MySQL

## User, Password
```sql
CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
CREATE USER 'api_153'@'10.10.%.%' IDENTIFIED BY 'password';
SELECT user, host FROM mysql.user;
SHOW CREATE USER api
```
## GRANT (rights)
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON `github`.* TO 'api_153'@'10.10.%.%';
GRANT ALL PRIVILEGES ON `github`.`user` TO 'api_153'@'10.10.%.%';

-- Apply GRANT
FLUSH PRIVILEGES;
```
## From shell (outside of a MySQL prompt)
```bash
mysql -u root -p -e 'SHOW VARIABLES WHERE Variable_Name LIKE "%dir";'
```
## Show users and remote client IP or subnet etc
```sql
SELECT user, host FROM mysql.user;
```


## System

#### Log Rotate
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

### Log
The file mysql-bin.[index] keeps a list of all binary logs mysqld has generated and auto-rotated. The mechanisms for cleaning out the binlogs in conjunction with mysql-bin.[index] are:
```sql
PURGE BINARY LOGS TO 'binlogname';
PURGE BINARY LOGS BEFORE 'datetimestamp';
```
### Analyze binary logs
```bash
mysqlbinlog -d github \
--base64-output=DECODE-ROWS \
--start-datetime="2005-12-25 11:25:56" \
pa6.k8s.node.01-bin.000483 
```

## Show
```sql
SHOW CREATE TABLE user;
SHOW GRANTS FOR user@git.baptiste-dauphin.com;
```

## DUMP data (mysqldump)
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

#### Table size
```sql
SELECT table_name AS `Table`, round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB` FROM information_schema.TABLES WHERE table_schema = "github_db1" AND table_name = "table1";
```

#### All tables of all databases with size
```sql
SELECT 
     table_schema as `Database`, 
     table_name AS `Table`, 
     round(((data_length + index_length) / 1024 / 1024), 2) `Size in MB`,
     round(((data_length + index_length) / 1024 / 1024 / 1024), 2) `Size in GB` 
FROM information_schema.TABLES 
ORDER BY table_schema, data_length + index_length DESC;
```

#### All Databases size
```sql
SELECT table_schema "Database", ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) "DB Size in MB" FROM information_schema.tables GROUP BY table_schema;
```
### Feed database
```bash
gunzip < [compressed_filename.sql.gz]  | mysql -u [user] -p[password] [databasename]
```
### All in one usage <3
```bash
mysql -u baptiste -p -h database.baptiste-dauphin.com -e "SELECT table_schema 'DATABASE_1', ROUND(SUM(data_length + index_length) / 1024 / 1024, 1) 'DB Size in MB' FROM information_schema.tables GROUP BY table_schema;"
```

# Percona XtraDB Cluster (open source, cost-effective, and robust MySQL clustering)
Test replication from reverse proxy
```bash
for i in `seq 1 6`; do mysql -u clustercheckuser -p -e "show variables like 'server_id'; select user()" ; done
```


# Wireshark
## DNS Analysis with Tshark
It just plugs into 
```bash
tshark -f "udp port 53" -Y "dns.qry.type == A and dns.flags.response == 0"
# count total dns query
tshark -f "udp port 53" -n -T fields -e dns.qry.name | wc -l
```
## HTTP
### HTTP Analysis with Tshark
```bash
tshark -i wlan0 -Y http.request -T fields -e http.host -e http.user_agent
```

### Parse User Agents and Frequency with Standard Shell Commands
```bash
tshark -r example.pcap -Y http.request -T fields -e http.host -e http.user_agent | sort | uniq -c | sort -n
```

### Using additional HTTP filters in Analysis
```bash
tshark -r example.pcap -Y http.request -T fields -e http.host -e ip.dst -e http.request.full_uri
```

### Using additional HTTP filters in Analysis
```bash
tshark -r example.pcap -Y http.request -T fields -e http.host -e ip.dst -e http.request.full_uri
```

# Files
## Tar
```bash
tar --help
```

| Command |  meaning |
|---------|----------|
| -c | create   (name your file .tar) |
| -(c)z | archive type gzip    (name your file .tar.gz) |
| -(c)j | archive type bzip2 |
| -x | extract |
| -f | file |
| -v | verbose |
| -C | Set dir name to extract files |
| --directory | same |


#### compress
```bash
tar zfcv myfiles.tar.gz /dir1 /dir2 /dir3
```

#### extract
```bash
tar zxvf somefilename.tar.gz or .tgz
tar jxvf somefilename.tar.bz2
tar xf file.tar -C /path/to/directory
```

# update-alternatives - Default system software (Debian)
 update-alternatives - maintain symbolic links determining default commands 

### List existing selections
```bash
update-alternatives --get-selections
```

### Modify existing selection interactively
```bash
sudo update-alternatives --config x-terminal-emulator
```

### Create a new selection
```bash
update-alternatives --install /usr/bin/x-window-manager x-window-manager /usr/bin/i3 20
```

### Example : Change default terminal
will prompt you an interactive console to chose among recognized software
```bash
sudo update-alternatives --config x-terminal-emulator
```


# Process
## get processes info
```bash
# debian style
ps -ef
ps -o pid,user,%mem,command ax

# RedHat style
ps aux
```
## Kill etc
```bash
kill default TERM
kill -l list all signals
kill -l 15 get name of signal
kill -s TERM PID 
kill -TERM PID 
kill -15 PID
```

## Shortcut
| shortcut | meaning |
|-|-|
| ctrl + \   | SIGQUIT |
| ctrl + C   | SIGINT |


## signals list

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


## list every running process
```bash
ps -ef | grep ssh-agent | awk '{print $2}'
ps -ef | grep ssh-agent | awk '$0=$2'
```

#### Print only the process IDs of syslogd:
```bash
ps -C syslogd -o pid=
```
#### Print only the name of PID 42:
```bash
ps -q 42 -o comm=
```

#### To see every process running as root (real & effective ID) in user format:
```bash
ps -U root -u root u
```

#### Use process substitution:
```bash
diff <(cat /etc/passwd) <(cut -f2 /etc/passwd)
```
<(...) is called process substitution.
It converts the output of a command into a file-like object that diff can read from.
While process substitution is not POSIX, it is supported by bash, ksh, and zsh.

### Get PID (process Identifier) of a running process
```bash
pidof iceweasel
pgrep ssh-agent
```

# Unix File types
|Description   |   symbol |
|-------------------|-------------|
| Regular file  | - |
| Directory  | d |
| Special files  | (5 sub types in it) |
| block file | b |
| Character device file | c |
| Named pipe file or just a pipe file | p |
| Symbolic link file | l |
| Socket file | s |

# LDAP // Activate Directory

#### Search into LDAP
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

#### modify an acount (remotly)
```bash
apt install ldap-utils
#
ldapmodify \
-H ldaps://ldap.company.tld \
-D "cn=b.dauphin,ou=people,c=fr,dc=company,dc=fr" \
-W \
-f b.gates.ldif
# .ldif must contains modification data
```
#### Locally
```bash
slapcat -f b.gates.ldif
```
#### Generate hash of the password, to update later the password account
```bash
slappasswd -h {SSHA}
# will prompt you the string you wanna hash, and generate it in stout
```

#### Content of .ldif
```bash
dn: cn=b.dauphin@github.com,ou=people,c=fr,dc=company,dc=fr
changetype: modify
replace: userPassword
userPassword: {SSHA}0mBz0/OyaZqOqXvzXW8TwE8O/Ve+YmSl
```

# SaltStack
### salt-key
```bash
salt-call --local key.finger  : Print the minion key fingerprint (when directly SSH connected)
salt-key -F master          : Print the master key fingerprint
-p PRINT, --print=PRINT       : Print the specified public key.                         
-P, --print-all  : Print all public keys.
-d DELETE, --delete=DELETE      : Delete the specified key. Globs are supported.
-D, --delete-all          : Delete all keys.
-f FINGER, --finger=FINGER      : Print the specified key's fingerprint.'
-F, --finger-all        : Print all keys's fingerprints.'
```

### Targeting
```bash
salt -S 192.168.40.20 test.version
salt -S 192.168.40.0/24 test.version
# compound match
salt -C 'S@10.0.0.0/24 and G@os:Debian' test.version
```
[full doc](https://docs.saltstack.com/en/latest/topics/targeting/globbing.html)
[Compound matchers](https://docs.saltstack.com/en/latest/topics/targeting/compound.html)

### Various useful module
```bash
salt '*' network.ip_addrs 
```

# Iptables
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

# Conntrack
#### debian old
```bash
cat /proc/sys/net/netfilter/nf_conntrack_count
```

#### debian 9
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

# NTP (Network Time Protocol)
![GitHub Logo](../src/ntp_stratum.png)

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
$ ntpq -pn
     remote           refid      st t when poll reach   delay   offset  jitter
==============================================================================
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

Column | Meaning
-|-
remote | The remote server you wish to synchronize your clock with
refid | The upstream stratum to the remote server. For stratum 1 servers, this will be the stratum 0 source.
st | The stratum level, 0 through 16.
t | The type of connection. Can be "u" for unicast or manycast, "b" for broadcast or multicast, "l" for local reference clock, "s" for symmetric peer, "A" for a manycast server, "B" for a broadcast server, or "M" for a multicast server
when | The last time when the server was queried for the time. Default is seconds, or "m" will be displayed for minutes, "h" for hours and "d" for days.
poll | How often the server is queried for the time, with a minimum of 16 seconds to a maximum of 36 hours. It's also displayed as a value from a power of two. Typically, it's between 64 seconds and 1024 seconds.
reach | This is an 8-bit left shift octal value that shows the success and failure rate of communicating with the remote server. Success means the bit is set, failure means the bit is not set. 377 is the highest value.
delay | This value is displayed in milliseconds, and shows the round trip time (RTT) of your computer communicating with the remote server.
offset | This value is displayed in milliseconds, using root mean squares, and shows how far off your clock is from the reported time the server gave you. It can be positive or negative.
jitter | This number is an absolute value in milliseconds, showing the root mean squared deviation of your offsets.


Next to the remote server, you'll notice a single character. This character is referred to as the "tally code", and indicates whether or not NTP is or will be using that remote server in order to synchronize your clock. Here are the possible values:

__remote single character__ | Meaning
-|-
__whitespace__ | Discarded as not valid. Could be that you cannot communicate with the remote machine (it's not online), this time source is a ".LOCL." refid time source, it's a high stratum server, or the remote server is using this computer as an NTP server.
__x__ | Discarded by the intersection algorithm.
__.__ | Discarded by table overflow (not used).
__-__ | Discarded by the cluster algorithm.
__+__ | Included in the combine algorithm. This is a good candidate if the current server we are synchronizing with is discarded for any reason.
__#__ | Good remote server to be used as an alternative backup. This is only shown if you have more than 10 remote servers.
__*__ | The current system peer. The computer is using this remote server as its time source to synchronize the clock
__o__ | Pulse per second (PPS) peer. This is generally used with GPS time sources, although any time source delivering a PPS will do. This tally code and the previous tally code "*" will not be displayed simultaneously.


[Sources](https://pthree.org/2013/11/05/real-life-ntp/)

### NTP Management

```bash
apt-get install ntp
ntpq -p
vim /etc/ntp.conf
sudo service ntp restart
ntpq -p
```

# Apache
### Validate config before reload/restart
```bash
apachectl configtest
```

# NGINX (Engine X)
### Various variables
[HTTP variables](http://nginx.org/en/docs/http/ngx_http_core_module.html)
### virtual host example
#### Redirect HTTP to HTTPS
```
server {
    listen 80;
    return 301 https://$host$request_uri;
}
```



# Zabbix Server
## API usage
Verify your url
```
https://zabbix.company/zabbix.php?action=dashboard.view
https://zabbix.company/zabbix/zabbix.php?action=dashboard.view
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


# Elastic Search

By default, each index in Elasticsearch is allocated __5 primary shards__ and __1 replica__ which means that if you have at least two nodes in your cluster, your index will have 5 primary shards and another 5 replica shards (1 complete replica) for a __total of 10 shards per index.__

Meaning | end point (http://ip:9200)
-|-
Nodes name, load, heap, Disk used, segments, JDK version | /\_cat/nodes?v&h=name,ip,load_1m,heapPercent,disk.used_percent,segments.count,jdk
info plus précises sur les index | /_cat/indices/__INDEX__/?v&h=index,health,pri,rep,docs.count,store.size,search.query_current,segments,memory.total
compter le nombre de doc | /_cat/count/__INDEX__/?v&h=dc
savoir l'état du cluster à un instant T | /_cat/health
full stats index | /__INDEX__/_stats?pretty=true
Kopg plugin | /_plugin/kopf

# Apt
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

# Security
## Fail2Ban
### Useful commands
```bash
# print jails
fail2ban-client status

# get banned ip and other info about a specific jail
fail2ban-client status ssh

# set banip triggers email send
fail2ban-client set ssh banip 10.10.10.10

# unbanip
fail2ban-client set ssh unbanip 10.10.10.10

# check a specific fail2ban chain
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


# Email system

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

## MSTMP
msmtp est un client SMTP très simple et facile à configurer pour l'envoi de courriels.
Son mode de fonctionnement par défaut consiste à transférer les courriels au serveur SMTP que vous aurez indiqué dans sa configuration. Ce dernier se chargera de distribuer les courriels à leurs destinataires.
Il est entièrement compatible avec sendmail, prend en charge le transport sécurisé TLS, les comptes multiples, diverses méthodes d’authentification et les notifications de distribution.

### Installation

apt install msmtp msmtp-mta

vim /etc/msmtprc

```
# Valeurs par défaut pour tous les comptes.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

# Exemple pour un compte Gmail
account        gmail
host           smtp.gmail.com
port           587
from           username@gmail.com
user           username
password       plain-text-password

# Définir le compte par défaut
account default : gmail
```

#### Test email sending
```
echo -n "Subject: hello\n\nDo see my mail" | sendmail baptistedauphin76@gmail.com

```
You run the command... and, oops: sendmail: Cannot open mailhub:25. The reason for this is that we didn't provide mailhub settings at all. In order to forward messages, you need an SMTP server configured. That's where SSMTP performs really well: you just need to edit its configuration file once, and you are good to go.


# grep

# less
### Start at the end of a file

+ will run an initial command when the file is opened
G jumps to the end

```bash
less +G app.log
```




# sed (Stream editor)
```bash
sed '/^#/ d' redis.conf : supprime le dieze en début de ligne (décommente)
sed -n : silent mode. By default print nothing. Use with /p to print interesting cmd
sed -e : Script directement dans la ligne de commande
sed -f script_file  : script dans un fichier
sed -i : agit non pas sur l input stream mais sur le fichier specifier

sed -i 's/patern 1/patern 2/g' /etc/ssh/sshd_config
sed -n 's/ *Not After : *//p'`  remplace Not after par rien 
```

##### remove 342th line of file
```bash
sed '342d' -i ~/.ssh/known_hosts
```

##### remove 342th to 342th line, equivalent to precedent cmd
```bash
sed '342,342d' -i ~/.ssh/known_hosts
```

##### remove first 42 lines of test.sql file and print result
```bash
sed -i '1,42d' -i test.sql
```

# Find

##### Various example, with xargs
```bash
find . -maxdepth 1 -type l -ls
find /opt -type f -mmin -5 -exec ls -ltr {} +
find /var/log/nginx -type f -name "*access*" -mmin +5 -exec ls -ltr {} +
ls 2019* | xargs -I % mv % ./working_sheet_of_the_day

#list files with last modified date of LESS than 5 minutes
find . -type f -mmin -5 -exec ls -ltr {} +

# xargs
find . -type f -mmin -5 -print0 | xargs -0 /bin/ls -ltr
```

date de modif des DATA du fichier (day)
```bash
find -mtime n
```
last acces time (day)
```bash
find -atime n
```
date de modif du STATUT du fichier
```bash
find -ctime n
```


list in the current directory, all files last modifed __more__ (+10) than 10 days ago, historical order
```bash
find . -type f -mtime +10 -exec ls -ltr {} +
```
list in the current directory, all files last modifed __less__ (-10) than 10 days ago, historical order
```bash
find . -type f -mtime -10 -exec ls -ltr {} +
```


# FileSystem
## Mount
### When lost remote access to machine.
press `e` to edit grub
After editing grub, add this at the end of __linux__ line
` init=/bin/bash`
F10 to boot with the current config
Make writable the root filesystem
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

### List read only filesystem
```bash
awk '$4~/(^|,)ro($|,)/' /proc/mounts
```

### Unmount partition
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

###### Forcefully umount a busy device

When you cannot wait to properly umount a busy device, use umount -f as shown below.
```bash
umount -f /mnt
```

If it still doesn’t work, lazy unmount should do the trick. Use umount -l as shown below.
```bash
umount -l /mnt
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

## Raid

### mdadm
To be updated


# redis
### Get info about __master/slave__ replication
```bash
redis-cli -h 10.10.10.10 -p 6379 -a $PASSWORD info replication
```

### FLUSH all keys of all databases
```bash
redis-cli FLUSHALL
```

### Delete all keys of the specified Redis database
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

### Check all databases
```bash
CONFIG GET databases
1) "databases"
2) "16"
```

```bash
INFO keyspace
# Keyspace
db0:keys=10,expires=0
db1:keys=1,expires=0
db3:keys=1,expires=0
```

### Delete multiples keys
```bash
redis-cli -a XXXXXXXXX --raw keys "my_word*" | xargs redis-cli -a XXXXXXXXX  del
```


# Php-FPM
### check config
```bash
php-fpm7.2 -t
```

# Docker
## Docker Swarm
```bash
docker node ls
docker
```
## Docker-proxy
[Explanations](https://windsock.io/the-docker-proxy/)

## Dockerd


# System performance
```bash
htop
nload
# memory
free -g
```

## Get memory physical size

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

## Get number processing units (CPU / cores)
```bash
# available to the current process (may be less than all online)
nproc
# all online
nproc --all

# old fashion version
grep -c ^processor /proc/cpuinfo
```

# Graphic
* Graphic server (often X11, Xorg, or just X, it's the same software)
* Display Manager (SDDM, lightDM, gnome)
* Windows Manager (i3-wm, gnome)

## Display Manager

### SDDM - lightweight
Traduit de l'anglais-Simple Desktop Display Manager est un gestionnaire d’affichage pour les systèmes de fenêtrage X11 et Wayland. SDDM a été écrit à partir de zéro en C ++ 11 et supporte la thématisation via QML
```bash
service sddm status
service sddm restart    : restart sddm (to load new monitor)
```

### Gnome - Nice display for personal laptop

## Windows Manager
### i3
```bash
update-alternatives --install /usr/bin/x-window-manager x-window-manager /usr/bin/i3 20
```

# HAProxy
### Check config
```bash
haproxy -f /etc/haproxy/haproxy.cfg -c -V
```

# Markdown
[GitHub guide - Master Markdown tutorial](https://guides.github.com/features/mastering-markdown/)


# Java
## JDK
version
```bash
java -version
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (build 1.8.0_222-b10)
OpenJDK 64-Bit Server VM (build 25.222-b10, mixed mode)
```

## Java - certificate authority 
Java doesn't use system CA but a specific `keystore`
You can manage the keystore with `keytool`
```bash
keytool -list -v -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts

keytool -import -alias dolphin_ltd_root_ca -file /etc/pki/ca-trust/source/anchors/dolphin_ltd_root_ca.crt -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts
keytool -import -alias dolphin_ltd_subordinate_ca -file /etc/pki/ca-trust/source/anchors/dolphin_ltd_subordinate_ca.crt -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts

keytool -delete -alias dolphin_ltd_root_ca -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts
keytool -delete -alias dolphin_ltd_subordinate_ca -keystore /usr/jdk64/jdk1.7.0_62/jre/lib/security/cacerts
```

# Python
### check the protocols supported by your Python version
```bash
vim /tmp/testPythonProtocols.py
```

```python
#!/usr/bin/env python
import ssl;
for i in dir(ssl): 
  if i.startswith("PROTOCOL"):
    print(i)
```

```bash
/tmp/testPythonProtocols.py
```

# InfluxDB
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
MySQL | Influx
|-|-|
| DATABASE | DATABASE |
| MEASUREMENT | TABLE |
| COLUMN | FIELD && TAG |

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




# Regex
Online tester
https://regex101.com/

# User's IPC shared memory, semaphores, and message queues 

```bash
USERNAME=$1

# Type of IPC object. Possible values are:
#   q -- message queue
#   m -- shared memory
#   s -- semaphore
TYPE=$2

ipcs -$TYPE | grep $USERNAME | awk ' { print $2 } ' | xargs -I {} ipcrm -$TYPE {}
ipcs -s | grep zabbix | awk ' { print $2 } ' | xargs -I {} ipcrm -s {}
```


# RabbitMQ
https://www.rabbitmq.com/management.html
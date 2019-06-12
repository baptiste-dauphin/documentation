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

# Definition


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

# Git
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



# OpenSSL, TLS, private key, rsa, ecdsa
### Generate __Certificate Signing Request__ (csr) + the associate private key
Will generates both private key and csr token
```
openssl req -nodes -newkey rsa:4096 -sha256 -keyout sub.mydomain.tld.key -out sub.mydomain.tld.csr -subj "/C=FR/ST=France/L=PARIS/O=My Company/CN=sub.mydomain.tld"
```
You can verify the content of your csr token here :
[DigiCert Tool](https://ssltools.digicert.com/checker/views/csrCheck.jsp)


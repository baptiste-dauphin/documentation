# CentOS specific commands which differs from debian
## Save iptables rules
```bash
iptables-save > /etc/sysconfig/iptables
```
## OS Version
```bash
cat /etc/system-release
CentOS Linux release 7.6.1810 (Core)
```

yum list installed | grep unzip
#!/bin/bash

export LANG=C
systemctl stop salt-minion || service salt-minion stop
export http_proxy="http://ip:port"
export https_proxy="http://ip:port"

debver="$(cat /etc/debian_version 2>/dev/null)"
echo $debver

case "$debver" in
   7.*) wget -O /var/tmp/SALTSTACK-GPG-KEY.pub http://repo.saltstack.com/apt/debian/7/amd64/2016.11/SALTSTACK-GPG-KEY.pub
        apt-key add /var/tmp/SALTSTACK-GPG-KEY.pub
        rm -f /var/tmp/SALTSTACK-GPG-KEY.pub
        apt-get remove python-pycrypto
        apt-get remove python-apache-libcloud
        echo "deb http://repo.saltstack.com/apt/debian/7/amd64/2016.11 wheezy main" \
           > /etc/apt/sources.list.d/saltstack.list
        rm -f /etc/apt/sources.list.d/salt.list

        # EOL wheezy
        echo "deb http://archive.debian.org/debian wheezy main" \
           > /etc/apt/sources.list

        #apt-get update
        #apt-get install python-pycurl
        #apt-get install libjs-jquery libjs-sphinxdoc libjs-underscore
        #apt-get install python-backports.ssl-match-hostname
        #cd /tmp
        #wget http://repo.saltstack.com/apt/debian/7/amd64/2016.11/pool/main/p/python-tornado/python-tornado_4.2.1-1~ds+1_amd64.deb
        #wget http://repo.saltstack.com/apt/debian/7/amd64/2016.11/pool/main/p/python-concurrent.futures/python-concurrent.futures_3.0.3-1_all.deb
        #dpkg -i /tmp/python-tornado_4.2.1-1~ds+1_amd64.deb /tmp/python-concurrent.futures_3.0.3-1_all.deb
        #rm -f /tmp/python-tornado_4.2.1-1~ds+1_amd64.deb /tmp/python-concurrent.futures_3.0.3-1_all.deb
   ;;
   8.*) wget -O /var/tmp/SALTSTACK-GPG-KEY.pub https://repo.saltstack.com/apt/debian/8/amd64/2018.3/SALTSTACK-GPG-KEY.pub
        apt-key add /var/tmp/SALTSTACK-GPG-KEY.pub
        rm -f /var/tmp/SALTSTACK-GPG-KEY.pub
        echo "deb http://repo.saltstack.com/apt/debian/8/amd64/2018.3 jessie main" \
           > /etc/apt/sources.list.d/saltstack.list
        rm -f /etc/apt/sources.list.d/salt.list

        # python-systemd is now in jessie-backports
        #grep -q "jessie-backports" /etc/apt/sources.list || \
        #    echo "deb http://deb.debian.org/debian jessie-backports main" >> /etc/apt/sources.list
        apt-get update
        apt-get install python-systemd

        ## BEGIN-SOMETIME-OPTIONAL (WHY?)
          apt-get update
          apt-get install python-pycurl
          cd /var/tmp
          wget http://repo.saltstack.com/apt/debian/8/amd64/2018.3/pool/main/p/python-tornado/python-tornado_4.2.1-1~ds+1_amd64.deb
          wget http://repo.saltstack.com/apt/debian/8/amd64/2018.3/pool/main/p/python-concurrent.futures/python-concurrent.futures_3.0.3-1_all.deb
          #wget http://repo.saltstack.com/apt/debian/8/amd64/2018.3/pool/main/p/python-systemd/python-systemd_231-2~bpo8+1_amd64.deb
          dpkg -i python-tornado_4.2.1-1~ds+1_amd64.deb python-concurrent.futures_3.0.3-1_all.deb
          apt-get -f install
          rm -f *.deb
        ## END-OF-SOMETIME-OPTIONAL
   ;;
   9.*) wget -O - https://repo.saltstack.com/apt/debian/9/amd64/latest/SALTSTACK-GPG-KEY.pub | apt-key add -
        echo "deb http://repo.saltstack.com/py3/debian/9/amd64/2019.2 stretch main" \
           > /etc/apt/sources.list.d/saltstack-2019.2-py3.list
        rm -f /etc/apt/sources.list.d/{salt.list,saltstack.list}
        ;;
        
        # -or-
        # wget -O - https://repo.saltstack.com/py3/debian/9/amd64/2019.2/SALTSTACK-GPG-KEY.pub | apt-key add -
esac

echo "\
master: "$FQDN_OF_MASTER"
master_finger: "$MASTER_FINGERPRINT"" \
  > /etc/salt/minion.d/salt-master.conf

apt-get update
apt-get install -y -o DPkg::Options::=--force-confnew salt-minion salt-common

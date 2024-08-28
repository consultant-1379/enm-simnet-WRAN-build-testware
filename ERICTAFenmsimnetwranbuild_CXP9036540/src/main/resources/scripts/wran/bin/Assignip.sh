#!/bin/sh
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";

cat ~/freeIPs.log >> availableip.txt


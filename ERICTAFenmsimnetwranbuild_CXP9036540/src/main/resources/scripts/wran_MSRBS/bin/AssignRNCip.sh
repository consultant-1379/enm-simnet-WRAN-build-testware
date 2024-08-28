#!/bin/sh

#!/bin/sh
# Created by  : zchianu
# Created in  : 16 09 2021
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : Assinging Ips from the freeips.log file in sequential order
#               instead of incrementing last value
# Description :
# Date        : 16 09 2021
# Who         : zchianu
###########################################

SIM=$1
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

######################################
#Checking Freeips
echo "Please be patient ... gathering free ips"
######################################
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
#########################################
cat /netsim/freeIPs.log | grep -v ":" | sort -V  > RNC_Ipv4_freeIp.log
#################################################

RNC_ip=`head -1 RNC_Ipv4_freeIp.log`

cat >> $SIM.mml << XYZ
.open $SIM
.select $RNCNAME
.stop
.modifyne set_subaddr ${RNC_ip} subaddr no_value
.set taggedaddr subaddr ${RNC_ip} 1
.set save
.start
XYZ
#####################################################
/netsim/inst/netsim_shell < $SIM.mml
rm $SIM.mml


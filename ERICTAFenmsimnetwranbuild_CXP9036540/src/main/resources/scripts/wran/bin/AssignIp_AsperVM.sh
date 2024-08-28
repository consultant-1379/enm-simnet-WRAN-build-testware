#!/bin/sh

#!/bin/sh
# Created by  : zchianu
# Created in  : 15 08 2021
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : Assinging Ips from the freeips.log file in sequential order 
#               instead of incrementing last value
# Description :
# Date        : 15 08 2021
# Who         : zchianu
###########################################

SIM=$1
######################################
#Checking Freeips
echo "Please be patient ... gathering free ips"
######################################
lsof -nl >/tmp/lsof.log;rm -rf ~/freeIPs.log; for ip in `ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'`;do grep $ip /tmp/lsof.log > /dev/null; if [ $? != 0 ]; then echo $ip >> ~/freeIPs.log; fi; done; rm -rf /tmp/lsof.log;echo "Total IPs:`ip add list|grep -v "127.0.0\|::1\|0.0.0.0\|00:00:"|cut -d" " -f6|cut -d"/" -f1|grep -v qdisc|awk 'NF'|wc -l`"; echo "Free IPs:`wc -l ~/freeIPs.log`";
#########################################
cat /netsim/freeIPs.log | grep -v ":" | sort -V  > Ipv4_freeIp.log
#################################################

Nodenames=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | tail -n+5 | head -n -1 | awk -F ' ' '{print $1}' | grep -v ">>"`

numberofnodes=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | tail -n+5 | head -n -1 | awk -F ' ' '{print $1}' | grep -v ">>" | wc -l`
###################################################
req_ips=`head -$numberofnodes Ipv4_freeIp.log`

read -a nodenames_array <<< $Nodenames
read -a req_ips_array <<< $req_ips

###################################################
for i in "${!nodenames_array[@]}"
do
cat >> $SIM.mml << XYZ
.open $SIM
.select ${nodenames_array[$i]}
.stop
.modifyne set_subaddr ${req_ips_array[$i]} subaddr no_value
.set taggedaddr subaddr ${req_ips_array[$i]} 1
.set save
.start
XYZ
done
#####################################################
/netsim/inst/netsim_shell < $SIM.mml
rm $SIM.mml


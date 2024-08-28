#!/bin/bash

#VERSION HISTORY
####################################################################
# Version1    : LTE 19.17
# Revision    : CXP 903 6540-1-2
# Purpose     : creates OAMAccesspoint MO in MSRBS nodes
# Description : creates IPV4Address MO and IPV6Address MO on 
#               the 80:20 for RV and 100:00 for MT
# Jira        : NSS-27634
# Date        : NOV 2019
# Who         : zyamkan
####################################################################
SIM=$1
ENV=$2

echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <env file>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x10-RNC01 CONFIG.env"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

RncStr=(${SIM//RNC/ }) 
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

Node=`echo $SIM | cut -d "x" -f3 | cut -d "-" -f1`
NodeCount=$(expr $Node + 1)

if [ "$SwitchToRV" == "YES" ]
 then
   DG2=`echo 'scale=3;'$NodeCount'*8/10' | bc`
   DG2Count=`echo $DG2 | perl -nl -MPOSIX -e 'print ceil($_);'`
   Ipv4NodeCount=$(expr $DG2Count - 1)
   Ipv6NodeCount=$(expr $Node - $Ipv4NodeCount)
else
  Ipv4NodeCount=$(expr $NodeCount - 1)
  Ipv6NodeCount=0
fi
echo "***$Ipv4NodeCount and $Ipv6NodeCount***"
NodesList=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | grep "LTE MSRBS-V2" | cut -d" " -f1`
Ipv4Nodes=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | grep "LTE MSRBS-V2" | cut -d" " -f1 | head -$Ipv4NodeCount`
Ipv6Nodes=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | grep "LTE MSRBS-V2" | cut -d" " -f1 | tail -$Ipv6NodeCount`

Path=`pwd`

for ipv4Node in ${Ipv4Nodes[@]}
do
cat >> $ipv4Node.mo << DEF
CREATE
(
    parent "ComTop:ManagedElement=$ipv4Node,ComTop:Transport=1"
    identity "OAM"
    moType RtnL3Router:Router
    exception none
    nrOfAttributes 1
    "routerId" String "OAM" 
)
CREATE
(
    parent "ComTop:ManagedElement=$ipv4Node,ComTop:Transport=1,RtnL3Router:Router=OAM"
    identity "1"
    moType RtnL3InterfaceIPv4:InterfaceIPv4
    exception none
    nrOfAttributes 1
    "interfaceIPv4Id" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$ipv4Node,ComTop:Transport=1,RtnL3Router:Router=OAM,RtnL3InterfaceIPv4:InterfaceIPv4=1"
    identity "1"
    moType RtnL3InterfaceIPv4:AddressIPv4
    exception none
    nrOfAttributes 1
    "addressIPv4Id" String "1"
)
DEF
cat >> ipv4.mml << ABC
.open $SIM
.select $ipv4Node
kertayle:file="$Path/$ipv4Node.mo";
ABC

moFiles+=($ipv4Node.mo)
done

for ipv6Node in ${Ipv6Nodes[@]}
do
cat >> $ipv6Node.mo << DEF
CREATE
(
    parent "ComTop:ManagedElement=$ipv6Node,ComTop:Transport=1"
    identity "OAM"
    moType RtnL3Router:Router
    exception none
    nrOfAttributes 1
    "routerId" String "OAM"
)
CREATE
(
    parent "ComTop:ManagedElement=$ipv6Node,ComTop:Transport=1,RtnL3Router:Router=OAM"
    identity "1"
    moType RtnL3InterfaceIPv6:InterfaceIPv6
    exception none
    nrOfAttributes 1
    "interfaceIPv6Id" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$ipv6Node,ComTop:Transport=1,RtnL3Router:Router=OAM,RtnL3InterfaceIPv6:InterfaceIPv6=1"
    identity "1"
    moType RtnL3InterfaceIPv6:AddressIPv6
    exception none
    nrOfAttributes 1
    "addressIPv6Id" String "1"
)
DEF
cat >> ipv6.mml << ABC
.open $SIM
.select $ipv6Node
kertayle:file="$Path/$ipv6Node.mo";
ABC

moFiles+=($ipv6Node.mo)
done

if [ "$SwitchToRV" == "YES" ]
 then
   /netsim/inst/netsim_pipe < ipv4.mml
   /netsim/inst/netsim_pipe < ipv6.mml
else
   /netsim/inst/netsim_pipe < ipv4.mml
fi

for filenum in ${moFiles[@]}
do
rm $filenum
done
rm ipv4.mml
rm ipv6.mml

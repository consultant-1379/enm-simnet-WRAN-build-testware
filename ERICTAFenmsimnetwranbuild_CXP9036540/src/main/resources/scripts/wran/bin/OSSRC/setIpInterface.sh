#!/bin/sh
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2  ]
then
 echo
 echo "#************* Please give inputs correctly **********************#"
 echo
 echo "Usage: $0 <sim name> <envfile>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10 CONFIG.env"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

SIM=$1
ENV=$2

. ../../dat/$ENV
CURRDIR=$SIMDIR"/bin/OSSRC"
RNCNUM=$(echo $SIM | awk -F"RNC" '{print $3}')
RNC="RNC"$RNCNUM
NODELIST=$(echo -e '.open '$SIM'\n.show simnes' | /netsim/inst/netsim_shell | grep " RBS" | cut -d" " -f1)
NODES=(${NODELIST// / })
for NODE in ${NODES[@]}
do
if [ -e ip_interface.mo ] 
then
   rm ip_interface.mo
fi
if [ -e ip_interface.mml ]
then
   rm ip_interface.mml
fi
cat >> ip_interface.mml << MML
.open $SIM
.select $NODE
.start
kertayle:file="/netsim/ip_interface.mo";
MML
cat >> ip_interface.mo << MOSC
SET
(
    mo "ManagedElement=1,IpSystem=1,IpAccessHostEt=1"
    exception none
    nrOfAttributes 1
    "ipInterfaceMoRef" Ref "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1,IpInterface=1"
)
SET
(
    mo "ManagedElement=1,IpOam=1,Ip=1,IpHostLink=1"
    exception none
    nrOfAttributes 1
    "ipInterfaceMoRef" Ref "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1,IpInterface=2"
)
MOSC
/netsim/inst/netsim_shell < ip_interface.mml
rm ip_interface.mml
rm ip_interface.mo
done
if [ -e IpHub.mo ]
then
   rm IpHub.mo
fi
cat >> IpHub.mo << MOSC
CREATE
(
    parent "ManagedElement=1,IpSystem=1"
    identity "Iub"
    moType IpAccessHostPool
    exception none
    nrOfAttributes 1
    "IpAccessHostPoolId" String "Iub"
)
MOSC
echo -e '.open '$SIM'\n.select '$RNC'\n.start\nkertayle:file="/netsim/IpHub.mo";' | /netsim/inst/netsim_shell


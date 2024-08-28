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
NODELIST=`echo -e '.open '$SIM' \n.show simnes' | /netsim/inst/netsim_shell | grep " RBS" | cut -d" " -f1`
NODES=(${NODELIST// / })
for NODE in ${NODES[@]}
do
MMLSCRIPT=$CURRDIR"/"$NODE"_GigaBitEthernet.mml"
MOSCRIPT=$CURRDIR"/"$NODE"_GigaBitEthernet.mo"
if [ -e $MMLSCRIPT ]
then
   rm $MMLSCRIPT
fi
if [ -e $MOSCRIPT ]
then
   rm $MOSCRIPT
fi
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1,ExchangeTerminalIp=1"
    identity "1"
    moType GigaBitEthernet
    exception none
    nrOfAttributes 1
    "GigaBitEthernetId" String "1"
)

SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1"
    exception none
    nrOfAttributes 1
    "dscpPbitMap" Array Struct 64
        nrOfElements 2
        "dscp" Integer 0
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 1
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 2
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 3
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 4
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 5
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 6
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 7
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 8
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 9
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 10
        "pbit" Integer 1

        nrOfElements 2
        "dscp" Integer 11
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 12
        "pbit" Integer 1

        nrOfElements 2
        "dscp" Integer 13
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 14
        "pbit" Integer 1

        nrOfElements 2
        "dscp" Integer 15
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 16
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 17
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 18
        "pbit" Integer 3

        nrOfElements 2
        "dscp" Integer 19
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 20
        "pbit" Integer 3

        nrOfElements 2
        "dscp" Integer 21
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 22
        "pbit" Integer 3

        nrOfElements 2
        "dscp" Integer 23
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 24
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 25
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 26
        "pbit" Integer 4

        nrOfElements 2
        "dscp" Integer 27
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 28
        "pbit" Integer 4

        nrOfElements 2
        "dscp" Integer 29
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 30
        "pbit" Integer 4

        nrOfElements 2
        "dscp" Integer 31
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 32
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 33
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 34
        "pbit" Integer 5

        nrOfElements 2
        "dscp" Integer 35
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 36
        "pbit" Integer 5

        nrOfElements 2
        "dscp" Integer 37
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 38
        "pbit" Integer 5

        nrOfElements 2
        "dscp" Integer 39
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 40
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 41
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 42
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 43
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 44
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 45
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 46
        "pbit" Integer 6

        nrOfElements 2
        "dscp" Integer 47
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 48
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 49
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 50
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 51
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 52
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 53
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 54
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 55
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 56
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 57
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 58
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 59
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 60
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 61
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 62
        "pbit" Integer 0

        nrOfElements 2
        "dscp" Integer 63
        "pbit" Integer 0

)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1"
    identity "1"
    moType IpInterface
    exception none
    nrOfAttributes 1
    "IpInterfaceId" String "1"
)

CREATE
(
    parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1,ExchangeTerminalIp=1,GigaBitEthernet=1"
    identity "2"
    moType IpInterface
    exception none
    nrOfAttributes 1
    "IpInterfaceId" String "2"
)
MOSC
cat >> $MMLSCRIPT << MML
.open $SIM
.select $NODE
.start
e X= csmo:ldn_to_mo_id(null,["ManagedElement=1","Equipment=1","Subrack=1","Slot=ET-MFX","PlugInUnit=1","ExchangeTerminalIp=1","InternalEthernetPort=1"]).
e: csmodb:delete_mo_by_id(null, X).
kertayle:file="$MOSCRIPT";
MML
/netsim/inst/netsim_shell < $MMLSCRIPT
rm $MOSCRIPT
rm $MMLSCRIPT
done

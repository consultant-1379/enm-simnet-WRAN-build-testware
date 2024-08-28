#!/bin/sh


if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <msrbsnum> "
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1 9 (to create RNC09)"
 echo
 exit 1
fi




SIMNAME=$1
NUMOFMSRBS=$2

if [ "$2" -le 9 ]
then
RNCNAME="RNC0"$2
RNCCOUNT="0"$2
else
RNCNAME="RNC"$2
RNCCOUNT=$2
fi


if [ "$2" -eq 0 ]
then
RNCNAME=
fi




PWD=`pwd`


MOSCRIPT=$0".mo"
MMLSCRIPT=$0".mml"

if [ -f $PWD/$MOSCRIPT ]
then
rm -r  $PWD/$MOSCRIPT
echo "old "$PWD/$MOSCRIPT " removed"
fi

if [ -f $PWD/$MMLSCRIPT ]
then
rm -r  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi

COUNT=1

while [ "$COUNT" -le "$NUMOFMSRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME"MSRBS-V20"$COUNT
else
NODENAME=$RNCNAME"MSRBS-V2"$COUNT
fi
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME"
    identity "1"
    moType Grat:BtsFunction
    exception none
    nrOfAttributes 5
    "btsFunctionId" String "1"
    "btsVersion" String "null"
    "gsmMcpaIpmCapacity" Uint32 "null"
    "release" String ""
    "userLabel" String "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Grat:BtsFunction=1"
    identity "1"
    moType Grat:GsmSector
    exception none
    nrOfAttributes 13
    "abisAtOperCondition" Integer "null"
    "abisAtState" Integer "null"
    "abisClusterGroupId" Uint16 "null"
    "abisScfOmlState" Integer "null"
    "abisScfOperCondition" Integer "null"
    "abisScfState" Integer "null"
    "abisTfMode" Integer "null"
    "abisTfOperCondition" Integer "null"
    "abisTfState" Integer "null"
    "bscNodeIdentity" String "BSC-RNC1701"
    "bscTgIdentity" String "RXSTG-1"
    "gsmSectorId" String "SECTOR1"
    "userLabel" String "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Grat:BtsFunction=1,Grat:GsmSector=1"
    identity "1"
    moType Grat:AbisIp
    exception none
    nrOfAttributes 14
    "abisIpId" String "1"
    "administrativeState" Integer 0
    "availabilityStatus" Array Integer 1
         0
    "bscBrokerIpAddress" String ""
    "dscpSectorControlUL" Uint8 46
    "gsmSectorName" String "null"
    "initialRetransmissionPeriod" Uint16 1
    "ipv4Address" Ref ""
    "keepAlivePeriod" Uint16 1
    "maxRetransmission" Uint16 5
    "operationalState" Integer 0
    "peerIpAddress" String "null"
    "retransmissionCap" Uint16 4
    "userLabel" String "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Grat:BtsFunction=1,Grat:GsmSector=1"
    // moid = 6004
    identity "1"
    moType Grat:Trx
    exception none
    nrOfAttributes 38
    "trxId" String "1"
    "administrativeState" Integer 0
    "operationalState" Integer 0
    "availabilityStatus" Array Integer 0
    "userLabel" String "null"
    "abisRxState" Integer "null"
    "abisTxState" Integer "null"
    "abisTrxcOmlState" Integer "null"
    "abisTrxcState" Integer "null"
    "abisTrxRslState" Integer "null"
    "abisTsState" Array Integer 0
    "arfcnMax" Uint16 0
    "arfcnMin" Uint16 0
    "frequencyBand" Uint8 0
    "noOfRxAntennas" Uint8 2
    "noOfTxAntennas" Uint8 1
    "trxIndex" Uint8 "null"
    "sectorEquipmentFunctionRef" Ref ""
    "configuredMaxTxPower" Uint32 20000
    "maxTxPowerCapability" Uint16 "null"
    "bscMaxTxPower" Uint16 "null"
    "rfBranchRxRef" Array Ref 0
    "rfBranchTxRef" Array Ref 0
    "rfBranchTx" Array Ref 0
	"reservedMaxTxPower" Uint32 "null"
    "abisRxOperCondition" Integer "null"
    "abisTxOperCondition" Integer "null"
    "abisTrxcOperCondition" Integer "null"
    "abisTsOperCondition" Array Integer 0
    "rfBranchRx" Array Ref 0
    "rxImbAvgDeltaMeas2" Uint8 "null"
    "rxImbNoOfSamples2" Uint16 "null"
    "rxImbAvgDeltaMeas1" Uint8 "null"
    "rxImbNoOfSamples1" Uint16 "null"
    "rxImbSupTimeElapsed" Uint16 "null"
    "rxImbSupWindowSize" Uint16 288
    "rxImbMinNoOfSamples" Uint16 7000
    "rxImbAlarmThreshold" Uint8 60
)




MOSC
echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT
COUNT=`expr $COUNT + 1`
done 

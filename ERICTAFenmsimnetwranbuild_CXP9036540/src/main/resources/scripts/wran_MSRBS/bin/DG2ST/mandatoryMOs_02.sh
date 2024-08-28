#!/bin/sh

# Created by : XRANDYA 
##
### VERSION HISTORY
##################################################
# Ver1        : Created for O16B 
# Purpose     : DG2 data population 
# Description :
# Date        : 2015-06-01
# Who         : XRANDYA 
##################################################



if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCL145-ST-RNC15 R7-ST-K-N.env 15

CREATE & SETS: WratLocalCell and Iub 

HELP

exit 1
fi

################################
# MAIN
################################

SIMNAME=$1
ENV=$2
RNCIDCOUNT=$3

. ../../dat/$ENV
. ../utilityFunctions.sh

if [ "$RNCIDCOUNT" -le 9 ]
then
  RNCNAME="RNC0"$RNCIDCOUNT
  RNCCOUNT="0"$RNCIDCOUNT
else
  RNCNAME="RNC"$RNCIDCOUNT
  RNCCOUNT=$RNCIDCOUNT
fi

if [ "$RNC_NODE_CREATION" != "YES" ]
then
  RNCNAME=""
fi


echo "#//...$0:$SIMNAME script started running at "`date`
echo "#//"


PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:${NOW}:$SIMNAME
MMLSCRIPT=$0:${NOW}:$SIMNAME".mml"

SCRIPTNAME=`basename "$0"`
DELETE_ALL_MO_SCRIPTS="DELETE_ALL_MO_SCRIPTS_${SIMNAME}_${SCRIPTNAME}"

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

#########################################
# 
# Make MO Script
#
#########################################

#echo ""
#echo "MAKING MO SCRIPT"
#echo ""

NUMOFDG2=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`
COUNT=1
MOFILECOUNT=1



  cat >> $MMLSCRIPT << MMLSCT
  .open $SIMNAME
MMLSCT
while [ "$COUNT" -le "$NUMOFDG2" ]
do
  
  if [ "$COUNT" -le 9 ]
   then
    DG2NAME=MSRBS-V20
   else
    DG2NAME=MSRBS-V2
  fi
  
  MOFILEEXTENSION="__"$MOFILECOUNT".mo"

####################################################################################################

  cat >> $MMLSCRIPT << MMLSCT
  .select $RNCNAME$DG2NAME$COUNT
  .start
useattributecharacteristics:switch="off";
MMLSCT

cat >> $MOSCRIPT$MOFILEEXTENSION << MOSCT
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqExternalNode:ExternalNode=1"
    identity "2"
    moType ReqEcPort:EcPort
    exception none
    nrOfAttributes 4
    "cascadingOrder" Int32 0
    "ecBusRef" Ref "null"
    "ecPortId" String "1"
    "hubPosition" String "null"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "2"
    moType ReqFieldReplaceableUnit:FieldReplaceableUnit
    exception none
    nrOfAttributes 1
    "fieldReplaceableUnitId" String "1"
 )
 CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "2"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "3"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "4"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "5"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "6"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "7"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "8"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "9"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "10"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "2"
    moType ReqRiLink:RiLink
    exception none
    nrOfAttributes 1
    "riLinkId" String "1"
	)
	CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "3"
    moType ReqRiLink:RiLink
    exception none
    nrOfAttributes 1
    "riLinkId" String "1"
	)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "4"
    moType ReqRiLink:RiLink
    exception none
    nrOfAttributes 1
    "riLinkId" String "1"
)	
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "2"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "3"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "4"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "5"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "6"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "7"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "8"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "9"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "10"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "11"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "12"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "13"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "14"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)	
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "2"
    moType ReqSfpModule:SfpModule
    exception none
    nrOfAttributes 1
    "sfpModuleId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "3"
    moType ReqSfpModule:SfpModule
    exception none
    nrOfAttributes 1
    "sfpModuleId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "2"
    moType RtnEthernetOam:EthernetOamLocalMep
    exception none
    nrOfAttributes 1
    "ethernetOamLocalMepId" String "1"
  )
  CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "2"
    moType RtnIPv4ACLPolicy:AclIpv4
    exception none
    nrOfAttributes 1
    "aclIpv4Id" String "1"

)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "3"
    moType RtnIPv4ACLPolicy:AclIpv4
    exception none
    nrOfAttributes 1
    "aclIpv4Id" String "1"

)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "4"
    moType RtnIPv4ACLPolicy:AclIpv4
    exception none
    nrOfAttributes 1
    "aclIpv4Id" String "1"

)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "2"
    moType RtnL3InterfaceIPv6:InterfaceIPv6
    exception none
    nrOfAttributes 1
    "interfaceIPv6Id" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "2"
    moType RtnL3Router:Router
    exception none
    nrOfAttributes 1
    "routerId" String "1"
)
MOSCT


echo 'kertayle:file="'$PWD'/'$MOSCRIPT$MOFILEEXTENSION'";' >> $MMLSCRIPT
echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts
  
  MOFILECOUNT=`expr $MOFILECOUNT + 1`
  COUNT=`expr $COUNT + 1`

	
done

################################################
$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

cat $PWD/$MMLSCRIPT 
#rm $PWD/$MMLSCRIPT
exit

#############################
#rm $MMLSCRIPT
#. $DELETE_ALL_MO_SCRIPTS
#rm $DELETE_ALL_MO_SCRIPTS

echo "#//...$0:$SIMNAME script ended running at "`date`
echo "#//"


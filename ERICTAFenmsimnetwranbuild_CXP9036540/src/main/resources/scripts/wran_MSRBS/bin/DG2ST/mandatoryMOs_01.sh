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
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:SystemFunctions=1"
    identity "1"
    moType RcsHwIM:HwInventory
    exception none
    nrOfAttributes 3
    "hwInventoryId" String "1"
    "timeOfLatestInvChange" String ""
    "userLabel" String "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1"
    identity "1"
    moType RcsHwIM:HwItem
    exception none
    nrOfAttributes 1
    "hwItemId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,RmeSupport:NodeSupport=1"
    identity "1"
    moType RmeSectorEquipmentFunction:SectorEquipmentFunction
    exception none
    nrOfAttributes 1
    "sectorEquipmentFunctionId" String "1"
       
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqFieldReplaceableUnit:FieldReplaceableUnit
    exception none
    nrOfAttributes 1
	    "fieldReplaceableUnitId" String "1"
		)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqAlarmPort:AlarmPort
    exception none
    nrOfAttributes 1
    "alarmPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqAntennaSystem:AntennaUnitGroup
    exception none
    nrOfAttributes 1
    "antennaUnitGroupId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1"
    identity "1"
    moType ReqAntennaSystem:AntennaNearUnit
    exception none
    nrOfAttributes 1
    "antennaNearUnitId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1,ReqAntennaSystem:AntennaNearUnit=1"
    identity "1"
    moType ReqAntennaSystem:RetSubUnit
    exception none
    nrOfAttributes 1
    "retSubUnitId" String "1"
 )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1,ReqAntennaSystem:AntennaNearUnit=1"
    identity "1"
    moType ReqAntennaSystem:TmaSubUnit
    exception none
    nrOfAttributes 1
    "tmaSubUnitId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1"
    identity "1"
    moType ReqAntennaSystem:AntennaUnit
    exception none
    nrOfAttributes 2
    "antennaUnitId" String "1"
    "mechanicalAntennaTilt" Int32 0
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1,ReqAntennaSystem:AntennaUnit=1"
    identity "1"
    moType ReqAntennaSystem:AntennaSubunit
    exception none
    nrOfAttributes 1
    "antennaSubunitId" String "1"
 
 )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1,ReqAntennaSystem:AntennaUnit=1,ReqAntennaSystem:AntennaSubunit=1"
    identity "1"
    moType ReqAntennaSystem:AuPort
    exception none
    nrOfAttributes 3
    "auPortId" String "1"
    "reservedBy" Array Ref 0
    "userLabel" String "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqAntennaSystem:AntennaUnitGroup=1"
    identity "1"
    moType ReqAntennaSystem:RfBranch
    exception none
    nrOfAttributes 1
    "rfBranchId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqCabinet:Cabinet
    exception none
    nrOfAttributes 1
    "cabinetId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqCabinet:Cabinet=1"
    identity "1"
    moType ReqFanGroup:FanGroup
    exception none
    nrOfAttributes 3
    "fanGroupFaultIndicator" Integer 0
    "fanGroupId" String "1"
    "fanPort" Int32 0
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqDiLink:DiLink
    exception none
    nrOfAttributes 5
    "availabilityStatus" Array Integer 1
         0
    "diLinkId" String "1"
    "diPortRef1" Ref ""
    "diPortRef2" Ref ""
    "operationalState" Integer 0
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqDiPort:DiPort
    exception none
    nrOfAttributes 4
    "availabilityStatus" Array Integer 1
         0
    "diPortId" String "1"
    "operationalState" Integer 0
    "reservedBy" Array Ref 0
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqEcBus:EcBus
    exception none
    nrOfAttributes 3
    "ecBusConnectorRef" Ref ""
    "ecBusId" String "1"
    "reservedBy" Array Ref 0
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqEFuse:EFuse
    exception none
    nrOfAttributes 8
    "availabilityStatus" Array Integer 1
         0
    "eFuseId" String "1"
    "eFuseIndicator" Integer 0
    "loadType" Integer 0
    "onAtColdStartup" Boolean true
    "operationalState" Integer 0
    "plugInModuleRef" Ref ""
    "remoteControllable" Boolean true
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqEnergyMeter:EnergyMeter
    exception none
    nrOfAttributes 1
    "energyMeterId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,RmeSupport:NodeSupport=1"
    identity "1"
    moType ReqEquipmentDiscovery:EquipmentDiscovery
    exception none
    nrOfAttributes 2
    "antennaDeviceScanStatus" Integer 0
    "equipmentDiscoveryId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqExternalNode:ExternalNode
    exception none
    nrOfAttributes 6
    "externalNodeId" String "1"
    "fullDistinguishedName" String ""
    "informationOnly" Boolean false
    "logicalName" String ""
    "radioAccessTechnology" Integer 0
    "supportSystemControl" Integer 0
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqExternalNode:ExternalNode=1"
    identity "1"
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
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqCabinet:Cabinet=1"
    identity "1"
    moType ReqFanGroup:FanGroup
    exception none
    nrOfAttributes 3
    "fanGroupFaultIndicator" Integer 0
    "fanGroupId" String "1"
    "fanPort" Int32 0
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqFieldReplaceableUnit:FieldReplaceableUnit
    exception none
    nrOfAttributes 1
    "fieldReplaceableUnitId" String "1"
 )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqHwGroup:HwGroup
    exception none
    nrOfAttributes 4
    "hwGroupId" String "1"
    "positionInformation" String "null"
    "reservedBy" Array Ref 0
    "userLabel" String "null"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqPlugInModule:PlugInModule
    exception none
    nrOfAttributes 1
    "plugInModuleId" String "1"
 
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqRfPort:RfPort
    exception none
    nrOfAttributes 1
    "rfPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1"
    identity "1"
    moType ReqRiLink:RiLink
    exception none
    nrOfAttributes 6
    "availabilityStatus" Array Integer 1
         0
    "linkRate" Int32 0
    "operationalState" Integer 0
    "riLinkId" String "1"
    "riPortRef1" Ref ""
    "riPortRef2" Ref ""
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqRiPort:RiPort
    exception none
    nrOfAttributes 1
    "riPortId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqSfpModule:SfpModule
    exception none
    nrOfAttributes 1
    "sfpModuleId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqSyncPort:SyncPort
    exception none
    nrOfAttributes 5
    "availabilityStatus" Array Integer 1
         0
    "operationalState" Integer 0
    "reservedBy" Array Ref 0
    "syncPortId" String "1"
    "userLabel" String "null"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ReqEquipment:Equipment=1,ReqFieldReplaceableUnit:FieldReplaceableUnit=1"
    identity "1"
    moType ReqTnPort:TnPort
    exception none
    nrOfAttributes 3
    "reservedBy" Array Ref 0
    "tnPortId" String "1"
    "userLabel" String "null"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT"
    identity "1"
    moType ResEquipmentSupportFunction:EquipmentSupportFunction
    exception none
    nrOfAttributes 5
    "equipmentSupportFunctionId" String "1"
    "release" String ""
    "supportFunction" Boolean true
    "supportSystemControl" Boolean true
    "userLabel" String "null"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResBatteryBackup:BatteryBackup
    exception none
    nrOfAttributes 1
    "batteryBackupId" String "1"
   )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResBatteryBackup:BatteryBackup
    exception none
    nrOfAttributes 1
    "batteryBackupId" String "1"
   
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResEnergyMeasurement:EnergyMeasurement
    exception none
    nrOfAttributes 1
    "energyMeasurementId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResEnergyMeasurement:EnergyMeasurement
    exception none
    nrOfAttributes 1
     "energyMeasurementId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT"
    identity "1"
    moType ResEquipmentSupportFunction:EquipmentSupportFunction
    exception none
    nrOfAttributes 1
    "equipmentSupportFunctionId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResPowerDistribution:PowerDistribution
    exception none
    nrOfAttributes 3
    "powerDistributionId" String "1"
    "priorityLoadUndervoltageDisconnect" Int32 -450
    "undervoltageDisconnectCeaseOffset" Int32 70
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResPowerDistribution:PowerDistribution
    exception none
    nrOfAttributes 1
    "powerDistributionId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResPowerSupply:PowerSupply
    exception none
    nrOfAttributes 1
    "powerSupplyId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ResEquipmentSupportFunction:EquipmentSupportFunction=1"
    identity "1"
    moType ResPowerSupply:PowerSupply
    exception none
    nrOfAttributes 1
    "powerSupplyId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RtnIpsecProposalProfile:IpsecProposalProfile
    exception none
    nrOfAttributes 1
     "ipsecProposalProfileId" String "1"

)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RtnBridging:Bridge
    exception none
    nrOfAttributes 1
    "bridgeId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RtnEthernetOam:EthernetOamLocalMep
    exception none
    nrOfAttributes 1
    "ethernetOamLocalMepId" String "1"
  )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RtnIkev2PolicyProfile:Ikev2PolicyProfile
    exception none
    nrOfAttributes 1
    "ikev2PolicyProfileId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnEthernetOam:EthernetOamLocalMep=1"
    identity "1"
    moType RtnEthernetOam:EthernetOamRemoteMep
    exception none
    nrOfAttributes 1
    "ethernetOamRemoteMepId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RtnL3Router:Router
    exception none
    nrOfAttributes 1
    "routerId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnIPv4ACLPolicy:AclIpv4
    exception none
    nrOfAttributes 1
    "aclIpv4Id" String "1"

)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnIpsec:IpsecTunnel
    exception none
    nrOfAttributes 1
    "ipsecTunnelId" String "1"
 )

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnDhcpRelayIPv4:DhcpRelayIPv4
    exception none
    nrOfAttributes 1
    "dhcpRelayIPv4Id" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnDnsClient:DnsClient
    exception none
    nrOfAttributes 1
    "dnsClientId" String "1"
      
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnIPv4ACLPolicy:AclIpv4
    exception none
    nrOfAttributes 1
    "aclIpv4Id" String "1"

)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1,RtnIPv4ACLPolicy:AclIpv4=1"
    identity "1"
    moType RtnIPv4ACLPolicy:AclEntryIpv4
    exception none
    nrOfAttributes 1
    "aclEntryIpv4Id" String "1"
 )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnL3InterfaceIPv6:InterfaceIPv6
    exception none
    nrOfAttributes 1
    "interfaceIPv6Id" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1"
    identity "1"
    moType RtnOSPFv2:Ospfv2
    exception none
    nrOfAttributes 1
    "ospfv2Id" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1,RtnOSPFv2:Ospfv2=1"
    identity "1"
    moType RtnOSPFv2:Area
    exception none
    nrOfAttributes 1
    "areaId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1,RtnOSPFv2:Ospfv2=1,RtnOSPFv2:Area=1"
    identity "1"
    moType RtnOSPFv2:Interface
    exception none
    nrOfAttributes 1
    "interfaceId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1,RtnOSPFv2:Ospfv2=1,RtnOSPFv2:Area=1"
    identity "1"
    moType RtnOSPFv2:Nssa
    exception none
    nrOfAttributes 1
    "nssaId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RtnL3Router:Router=1,RtnOSPFv2:Ospfv2=1,RtnOSPFv2:Area=1"
    identity "1"
    moType RtnOSPFv2:Stub
    exception none
    nrOfAttributes 1
    "stubId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:SystemFunctions=1,ComSysM:SysM=1"
    identity "93"
    moType ComSysM:Schema
    exception none
    nrOfAttributes 1
    "schemaId" String "93"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RtnSctpProfile:SctpProfile
    exception none
    nrOfAttributes 1
       "sctpProfileId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncSynchronization:Synchronization=1"
    identity "1"
    moType RsyncFrequencySyncIO:FrequencySyncIO
    exception none
    nrOfAttributes 1
    "frequencySyncIOId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RsyncNtp:Ntp
    exception none
    nrOfAttributes 1
    "ntpId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RsyncPtp:Ptp
    exception none
    nrOfAttributes 1
    "ptpId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncPtp:Ptp=1"
    identity "1"
    moType RsyncPtp:BoundaryOrdinaryClock
    exception none
    nrOfAttributes 12
    "boundaryOrdinaryClockId" String "1"
)
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncPtp:Ptp=1,RsyncPtp:BoundaryOrdinaryClock=1"
    identity "1"
    moType RsyncPtpBcOcPort:PtpBcOcPort
    exception none
    nrOfAttributes 1
    "ptpBcOcPortId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1"
    identity "1"
    moType RsyncSynchronization:Synchronization
    exception none
    nrOfAttributes 1
    "synchronizationId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncSynchronization:Synchronization=1"
    identity "1"
    moType RsyncTimeSyncIO:TimeSyncIO
    exception none
    "timeSyncIOId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncSynchronization:Synchronization=1,RsyncTimeSyncIO:TimeSyncIO=1"
    identity "1"
    moType RsyncGnssInfo:GnssInfo
    exception none
    nrOfAttributes 1
    "gnssInfoId" String "1"
 )
CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncSynchronization:Synchronization=1"
    identity "1"
    moType RsyncRadioEquipmentClock:RadioEquipmentClock
    exception none
    nrOfAttributes 1
     "radioEquipmentClockId" String "1"
)

CREATE
(
    parent "ComTop:ManagedElement=$RNCNAME$DG2NAME$COUNT,ComTop:Transport=1,RsyncSynchronization:Synchronization=1,RsyncRadioEquipmentClock:RadioEquipmentClock=1"
    identity "1"
    moType RsyncNodeGroupSyncMember:NodeGroupSyncMember
    exception none
    nrOfAttributes 1
    "nodeGroupSyncMemberId" String "1"
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


#!/bin/sh


if [ "$#" -ne 4  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <rnc num> <RXI Name>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env 9 RNC09RXI01 (to create RNC09)"
 echo
 exit 1
fi


SIMNAME=$1
ENV=$2
RNCIDCOUNT=$3
RXINAME=$4


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

echo "//...$0:$SIMNAME rxi script started running at "`date`
echo "//"


. ../../dat/$ENV

. ../utilityFunctions.sh



RXIVERSION=`getMimType $RNCCOUNT $RXIVERSIONARRAY`


PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:${NOW}:$SIMNAME".mo"
MMLSCRIPT=$0:${NOW}:$SIMNAME".mml"


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


echo "//.....$0:$SIMNAME MAKING MO SCRIPT RXI started running at "`date`
echo "//"

#echo ""
#echo "MAKING MO SCRIPT"
#echo ""


echo 'SET' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  mo "ManagedElement=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 3' >> $MOSCRIPT
echo '   faultTolerantCoreStates Array String 1'  >> $MOSCRIPT
echo '   "ManagedElement=1,Equipment=1,Subrack=MS,Slot=1,PlugInUnit=1;ftcState=Active"' >> $MOSCRIPT
echo '   mimName String '$RXIVERSION >> $MOSCRIPT
echo ')' >> $MOSCRIPT


#
## tmp1010createUpgradePackage.sh
#
echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,SwManagement=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType UpgradePackage' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 1' >> $MOSCRIPT
echo '   userLabel String UpgradePackage-1' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo 'SET' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  mo "ManagedElement=1,SwManagement=1,ConfigurationVersion=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 1' >> $MOSCRIPT
echo '   currentUpgradePackage Ref "ManagedElement=1,SwManagement=1,UpgradePackage=1"' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

#
## tmp1020createIpsys.sh
#
cat $SIMDIR/mo/$RXIDIR/ipsys.mo >> $MOSCRIPT


cat >> $MOSCRIPT << MOSCT

CREATE
(
    parent "ManagedElement=1,SystemFunctions=1"
    identity "1"
    moType Licensing
    exception none
    nrOfAttributes 8
    "LicensingId" String "1"
    "emergencyStateInfo" Struct
        nrOfElements 3
        "state" Integer 0
        "time" Integer 0
        "expiryTime" String ""

    "fingerprint" String ""
    "integrationUnlockStateInfo" Struct
        nrOfElements 3
        "state" Integer 0
        "remainingTime" Integer 0
        "expiryTime" String ""

    "lastLicensingPiChange" String "140710-062225"
    "licenseFileUrl" String ""
    "licenseFileUrlIpv6" String ""
    "userLabel" String "dfgg"
)

MOSCT

#
## tmp1030createSecurity.sh
#
echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,SystemFunctions=1"' >> $MOSCRIPT
echo ' identity 1' >> $MOSCRIPT
echo ' moType Security' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

#
## tmp1040createasms.sh
#
cat $SIMDIR/mo/$RXIDIR/asms.mo >> $MOSCRIPT

#
## tmp1050createEquip.sh
#

cat >> $MOSCRIPT << MOSCT

CREATE
(
    parent "ManagedElement=1"
    identity "1"
    moType Equipment
    exception none
    nrOfAttributes 2
    "EquipmentId" String "1"
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1"
    identity "1"
    moType Jvm
    exception none
    nrOfAttributes 14
    "JvmId" String "1"
    "admClasspath" Array Ref 0
    "admMain" String ""
    "admOptions" Array String 0
    "classpath" String ""
    "freeMemory" Integer 0
    "main" String ""
    "mopplets" Array String 0
    "options" String ""
    "properties" Array String 0
    "reliableProgramUniter" Ref "null"
    "reservedBySwAllocation" Array Ref 0
    "totalMemory" Integer 0
    "userLabel" String ""
)

CREATE
(
    parent "ManagedElement=1,Equipment=1"
    identity "MS"
    moType Subrack
    exception none
    nrOfAttributes 11
    "SubrackId" String "MS"
    "administrativeProductData" Struct
        nrOfElements 5
        "productNumber" String $RXINAME
        "productRevision" String $RXINAME
        "productName" String $RXINAME
        "productInfo" String $RXINAME
        "productionDate" String $RXINAME

    "cabinetPosition" String ""
    "numberOfSlots" Integer 28
    "operationalProductData" Struct
        nrOfElements 5
        "productName" String $RXINAME
        "productNumber" String $RXINAME
        "productRevision" String $RXINAME
        "serialNumber" String $RXINAME
        "productionDate" String $RXINAME

    "productType" String ""
    "reservedBy" Array Ref 0
    "subrackPosition" String "0"
    "subrackType" Integer 0
    "switchModule" Ref "null"
    "userLabel" String ""
)

MOSCT



cat $SIMDIR/mo/$RXIDIR/equip.mo >> $MOSCRIPT


#
## tmp1060createSwmgmt.sh
#
cat $SIMDIR/mo/$RXIDIR/swmgmt.mo >> $MOSCRIPT

#
## tmp1070createImaGroup.sh
#
COUNT=1
while [ "$COUNT" -le 5 ]
do

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
  echo '   identity '$COUNT >> $MOSCRIPT
  echo '   moType ImaGroup' >> $MOSCRIPT
  echo '   exception none' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,TransportNetwork=1,ImaGroup='$COUNT'"' >> $MOSCRIPT
  echo '   identity '$COUNT >> $MOSCRIPT
  echo '   moType ImaLink' >> $MOSCRIPT
  echo '   exception none' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo ' parent "ManagedElement=1,IpOam=1,Ip=1"' >> $MOSCRIPT
  echo ' identity '$COUNT >> $MOSCRIPT
  echo ' moType IpAtmLink' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT=`expr $COUNT + 1`
done


#
## tmp1090createPlugInUnit.sh
#

COUNT=1
while [ "$COUNT" -le 4 ]
do

  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,Equipment=1"' >> $MOSCRIPT
  echo '   identity '$COUNT >> $MOSCRIPT
  echo '   moType Subrack' >> $MOSCRIPT
  echo '   exception none' >> $MOSCRIPT
  echo '    "administrativeProductData" Struct' >> $MOSCRIPT
  echo '   nrOfElements 5' >> $MOSCRIPT
  echo '   "productName" String '$RXINAME >> $MOSCRIPT
  echo '   "productNumber" String '$RXINAME >> $MOSCRIPT
  echo '   "productRevision" String '$RXINAME >> $MOSCRIPT
  echo '   "serialNumber" String '$RXINAME >> $MOSCRIPT
  echo '   "productionDate" String '$RXINAME >> $MOSCRIPT
  echo '    "operationalProductData" Struct' >> $MOSCRIPT
  echo '   nrOfElements 5' >> $MOSCRIPT
  echo '   "productName" String '$RXINAME >> $MOSCRIPT
  echo '   "productNumber" String '$RXINAME >> $MOSCRIPT
  echo '   "productRevision" String '$RXINAME >> $MOSCRIPT
  echo '   "serialNumber" String '$RXINAME >> $MOSCRIPT
  echo '   "productionDate" String '$RXINAME >> $MOSCRIPT
 
  echo '  "subrackPosition" String "0"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT


  COUNT2=1
  while [ "$COUNT2" -le 28 ]
  do

	if [ $COUNT2 = 1 ]; then

	cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,Equipment=1,Subrack=$COUNT"
   identity $COUNT2
   moType Slot
   exception none
   nrOfAttributes 0
   "productData" Struct
        nrOfElements 5
        "productName" String " DUL 20 01 "
        "productNumber" String "KDU137533/4"
        "productRevision" String "R2A "
        "serialNumber" String "20111130 "
        "productionDate" String "C825522633 "
)

MOSCT

else
cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,Equipment=1,Subrack=$COUNT"
   identity $COUNT2
   moType Slot
   exception none
   nrOfAttributes 0
)

MOSCT
fi

# echo 'CREATE' >> $MOSCRIPT
  #  echo '(' >> $MOSCRIPT
  #  echo '  parent "ManagedElement=1,Equipment=1,Subrack='$COUNT'"' >> $MOSCRIPT
  #  echo '   identity '$COUNT2 >> $MOSCRIPT
  #  echo '   moType Slot' >> $MOSCRIPT
  #  echo '   exception none' >> $MOSCRIPT
  #  echo ')' >> $MOSCRIPT

    echo 'CREATE' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo '  parent "ManagedElement=1,Equipment=1,Subrack='$COUNT',Slot='$COUNT2'"' >> $MOSCRIPT
    echo '   identity 1' >> $MOSCRIPT
    echo '   moType PlugInUnit' >> $MOSCRIPT
    echo '   exception none' >> $MOSCRIPT
    echo ')' >> $MOSCRIPT

    COUNT2=`expr $COUNT2 + 1`
   done

  COUNT=`expr $COUNT + 1`
done

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType TimingUnit' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1,TimingUnit=1' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType TuSyncRef' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT



#
## tmp1095createPlugInUnit.sh
#
COUNT2=1
while [ "$COUNT2" -le 28 ]
do
  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,Equipment=1,Subrack=MS,Slot='$COUNT2'"' >> $MOSCRIPT
  echo '   identity 1' >> $MOSCRIPT
  echo '   moType PlugInUnit' >> $MOSCRIPT
  echo '   exception none' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT

  COUNT2=`expr $COUNT2 + 1`
done

#
## tmp1110setUpgradePackage.sh
#
echo 'SET' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  mo "ManagedElement=1,SwManagement=1,UpgradePackage=1"' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 1' >> $MOSCRIPT
echo '   loadModuleList Array Ref 90' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=asms"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=asms_sharp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Gpb3Basic"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=DbmBasic"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=LoaderServer"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Database"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Database"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SysMan"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SwInst"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Inet"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Ospf"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Sock"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Ethernet"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=IpUtil"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SpasRes"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Jvm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SpasConn"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SpasLink"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Http"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SpasSm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=48vpwrsup"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=CpyLoader"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=tsafpga"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=EquipMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=AtmMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=AtmBp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal0DynAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal0StaticAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal0TermMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal0TuBp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2Mp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2Bp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2Rh"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2Adm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal5DynAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal5StaticAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal5TermMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal5TermBp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal05Ncc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=AalCc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NssMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NssScb"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NssSyciBp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NssSyciMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Pms"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=UsaalAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=UsaalTerm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=TuFpga"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=PhyE1Mp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=PhyE1Bp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=EqpM1Bp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=amd_m1_fpga"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=PhyStm1Mp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=PhyStm1Bp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=EqpM4Bp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Cs"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Cma"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Oms"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=VbjOrb"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Classes"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Asms"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=optional"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NssTuRNCBp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2NccAdm12"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2DisNcc12"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2CpsRc12"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2Ap12"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=Aal2Ap13"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SppMp"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SppFpga"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NsaalAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=NsaalTerm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SppBpBasic"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SppBpAal025"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SccServer"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=SccAdm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=XPM"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=DbmFpgaLoader"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=tuRnRnc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmCenDh"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmCenRh"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmBdh"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmDh"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmCc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmDc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmDc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmIurCc"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmFro"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmMao"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmUe"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmModOm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmCenOm"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RnhLmCenRnh"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmRanap"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmRnsap"' >> $MOSCRIPT
echo '   "ManagedElement=1,SwManagement=1,LoadModule=RncLmCell"' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


echo "//.....$0:$SIMNAME MAKING MO SCRIPT RXI ended running at "`date`
echo "//"

#########################################
# Make MML Script
#########################################


RXINES='.*RXI.*'

echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RXINAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT


$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT


#rm $PWD/$MOSCRIPT
#rm $PWD/$MMLSCRIPT

echo "//...$0:$SIMNAME rxi script ended running at "`date`
echo "//"


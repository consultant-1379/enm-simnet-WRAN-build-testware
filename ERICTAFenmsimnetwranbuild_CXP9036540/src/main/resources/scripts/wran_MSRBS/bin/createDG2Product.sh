#!/bin/sh
######################################################################################
### Version2    : 23.11
### Revision    : CXP 903 6540-1-20
### Description : Adding support for fileLocation attribute value in CcpdService MO.
### JIRA        : NSS-44314
### Date        : 23rd June 2023
### Author      : znrvbia
######################################################################################
### Version2    : 23.02
### Revision    : CXP 903 6540-1-18
### Description : Adding correct MO structure and there values for RcsRem fragment
### JIRA        : NSS-41460
### Date        : 30th NOV 2022
### Author      : zachaja
#######################################################################################
### Version2    : 23.01
### Revision    : CXP 903 6540-1-17
### Description : Adding enrollmentSupport attribute for MSRBS nodes
### JIRA        : NSS-41456
### Date        : 15th NOV 2022
### Author      : zmogsiv
#######################################################################################
### Version2    : 22.02
### Revision    : CXP 903 6540-1-15
### Description : Updating BRM Mo attributes
### JIRA        : NSS-37850
### Date        : 17th Dec 2021
### Author      : zhainic
#######################################################################################
### Version2    : 20.11
### Revision    : CXP 903 6540-1-7
### Purpose     : Correcting the attribute ulSpectrumAnalyzerId
### Description : Rectifying the ulSpectrumAnalyzer MO number and ulSpectrumAnalyzerId 
### JIRA        : NSS-31245
### Date        : 10th June 2020
### Author      : zyamkan
########################################################################################
#######################################################################################
### Version1    : XXXX
### Purpose     : Supporting Product data for RNC DG2 nodes
### Author      : zchianu
########################################################################################
echo "#####################################################################"
echo "# $0 script Started Execution"
echo "---------------------------------------------------------------------"

if [ "$#" -ne 4  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <rnc count> <MSRBS ProductData>"
 echo
 echo "Example: RNCV71569x1-FT-PRBS17Ax2-RNC01 CONFIG.env 1 CXP9024418/12:R31A96"
 echo
 echo "------------ERROR: Please give inputs correctly---------------------"
 echo
 echo " $0 script ended ERRONEOUSLY !!!!"
 echo "####################################################################"
 exit 1
fi

SIMNAME=$1
ENV=$2
RNCCOUNT=$3
MSRBSPRODUCTDATA=$4

NUMOFMSRBS=$(echo $SIMNAME | awk -F"MSRBS" '{print $2}'| awk -F"x" '{print $2}'| awk -F"-" '{print $1}')
RncStr=(${SIMNAME//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

NodeStr=$(echo $SIMNAME | awk -F"MSRBS" '{print $2}'| awk -F"x" '{print $2}')
NUMOFMSRBS=(${NodeStr//-/ })
echo "NUM of Msrbs: $NUMOFMSRBS"
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`
TIME=`date '+%FT04:04:04.666%:z'`

MSRBSNode=MSRBS
MSRBSVERSION=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-MSRBS-//g' | sed s/-/_/2`
MSRBS_Link="https://netsim.seli.wh.rnd.internal.ericsson.com/tssweb/simulations/com3.1/"
MSRBS_Template=`curl $MSRBS_Link | grep ${MSRBSNode}"_V2_"${MSRBSVERSION} | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'`
NodeVersionInNumbers=`echo $SIMNAME | cut -d 'x' -f2 | awk -F 'MSRBS' '{print $2}' | sed 's/[A-Z]//g' | sed 's/-//g'`

echo "Node version in numbers is $NodeVersionInNumbers used to compare"
echo  "node templates is  ${MSRBS_Template} "
#MSRBS_Template=`echo $MSRBS_Link | awk -F '/' '{print $NF}'`
MSRBS_Template_WithoutZIP=`echo $MSRBS_Template | cut -d "." -f1`
echo "Msrbs Template is $MSRBS_Template_WithoutZIP"

etcmcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
etcmcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
etcmdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

ftemcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
ftemcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
ftemdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

pmcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
pmcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
pmdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`


  


NODEMIM=`getMimType $RNCCOUNT $DG2VERSIONARRAY`

IFS=";"

for x in $DG2PRODUCTARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$NODEMIM" ]
then
productNumber=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
productRevision=$(echo $x | awk -F":" '{print $2}')
break

fi

done
#productNumber=CXP9024418/6
#productRevision=R46A103
productNumber=$(echo $MSRBSPRODUCTDATA | awk -F ":" '{print $1}')
productRevision=$(echo $MSRBSPRODUCTDATA | awk -F ":" '{print $2}')

echo "Prod Number: $productNumber"
echo "Prod version: $productRevision"

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
NODENAME=$RNCNAME'MSRBS-V20'$COUNT
else
NODENAME=$RNCNAME'MSRBS-V2'$COUNT
fi
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1"
	identity 1
	moType HwItem
    // moid = 6005
    exception none
    nrOfAttributes 18
    "hwItemId" String "1"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-24GB"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)


CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1,HwItem=1"
	identity 1
	moType HwItem
    // moid = 6005
    exception none
    nrOfAttributes 18
    "hwItemId" String "1"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-24GB"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsBrM:BrM=1,RcsBrM:BrmBackupManager=1,RcsBrM:BrmBackupLabelStore=1"
    exception none
    nrOfAttributes 4
    "lastRestoredBackup" String "${NODENAME}_Restored"
    "lastImportedBackup" String "${NODENAME}_Imported"
    "lastExportedBackup" String "${NODENAME}_Exported"
    "lastCreatedBackup" String "${NODENAME}_Created"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsBrM:BrM=1,RcsBrM:BrmBackupManager=1,RcsBrM:BrmBackup=1"
    exception none
    nrOfAttributes 3
    "backupName" String "1"
    "creationType" Integer 3
    "creationTime" String "$TIME"
    "swVersion" Array Struct 1
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String "RadioNode"
        "type" String "RadioNode"

)
// Set Statement generated: 2017-08-14 13:07:28
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=1,RcsHwIM:HwItem=1"
    // moid = 6005
    exception none
    nrOfAttributes 1
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

)

// Set Statement generated: 2017-08-14 13:08:44
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=1,RcsHwIM:HwItem=1"
    // moid = 6005
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)

CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1"
	identity 2
	moType HwItem
    // moid = 6006
    exception none
    nrOfAttributes 18
    "hwItemId" String "2"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-HD300"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)

// Create Statement generated: 2017-08-14 13:05:37
CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,HwInventory=1,HwItem=2"
	identity 2
	moType HwItem
    // moid = 6006
    exception none
    nrOfAttributes 18
    "hwItemId" String "2"
    "vendorName" String "Ericsson"
    "hwModel" String "RadioNode"
    "hwType" String "Blade"
    "hwName" String "GEP3-HD300"
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)



// Create Statement generated: 2017-08-14 13:06:04

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "1"
    moType RcsRem:LtePmEvents
    exception none
    nrOfAttributes 4
    "ltePmEventsId" String "1"
    "documentNumber" String "null"
    "ffv" String "null"
    "revision" String "null"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "1"
    moType RcsRem:NrPmEvents
    exception none
    nrOfAttributes 3
    "nrPmEventsId" String "1"
    "managedFunction" String "CUCP"
    "version" String "$pmcucp"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "2"
    moType RcsRem:NrPmEvents
    exception none
    nrOfAttributes 3
    "nrPmEventsId" String "2"
    "managedFunction" String "CUUP"
    "version" String "$pmcuup"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:PmEventSpecification=1"
    identity "3"
    moType RcsRem:NrPmEvents
    exception none
    nrOfAttributes 3
    "nrPmEventsId" String "3"
    "managedFunction" String "DU"
    "version" String "$pmdu"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "2"
    moType RcsRem:NrEtcm
    exception none
    nrOfAttributes 3
    "nrEtcmId" String "2"
    "version" String "$etcmcuup"
    "managedFunction" String "CUUP"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "3"
    moType RcsRem:NrEtcm
    exception none
    nrOfAttributes 3
    "nrEtcmId" String "3"
    "version" String "$etcmdu"
    "managedFunction" String "DU"
)
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "2"
    moType RcsRem:NrFtem
    exception none
    nrOfAttributes 3
    "nrFtemId" String "2"
    "version" String "$ftemcuup"
    "managedFunction" String "CUUP"
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1"
    identity "3"
    moType RcsRem:NrFtem
    exception none
    nrOfAttributes 3
    "nrFtemId" String "3"
    "version" String "$ftemdu"
    "managedFunction" String "DU"
)



// Set Statement generated: 2017-08-14 13:09:42
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=2,RcsHwIM:HwItem=2"
    // moid = 6007
    exception none
    nrOfAttributes 1
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productDesignation" String ""

)

// Set Statement generated: 2017-08-14 13:11:08
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=2,RcsHwIM:HwItem=2"
    // moid = 6007
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwItem=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwVersion=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String "$NOW"
        "description" String ""
        "type" String "1"

)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwItem=1"
    // moid = 25
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)


SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwVersion=1"
    // moid = 24
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwItem=1
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1"
    exception none
    nrOfAttributes 1
    "active" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,RmeSupport:NodeSupport=1,RmeUlSpectrumAnalyzer:UlSpectrumAnalyzer=1"
    exception none
    nrOfAttributes 1
    "ulSpectrumAnalyzerId" String "1"
)

MOSC

if [[ $NodeVersionInNumbers -eq 2333 ]]
then
 echo 'Inside condition'
cat >> $MOSCRIPT << MOSC

SET
 (
      mo "ComTop:ManagedElement=$NODENAME,RmeSupport:NodeSupport=1,RmeCcpdService:CcpdService=1"
      exception none
      nrOfAttributes 1
      "fileLocation" String "/productdata"
 )

MOSC
fi

cat >> $MOSCRIPT << MOSC


SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSecM:SecM=1,RcsCertM:CertM=1,RcsCertM:CertMCapabilities=1"
    exception none
    nrOfAttributes 1
    "enrollmentSupport" Array Integer 3
         0
         1
         3
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1,RcsRem:NrFtem=1"
    exception none
    nrOfAttributes 2
    "version" String "$ftemcucp"
    "managedFunction" String "CUCP"
)
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSysM:SysM=1,RcsRem:RuntimeExportM=1,RcsRem:EbsCounterSpecification=1,RcsRem:NrEtcm=1"
    exception none
    nrOfAttributes 2
    "version" String "$etcmcucp"
    "managedFunction" String "CUCP"
)



MOSC
#echo "$ftemcucp"
echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
/netsim/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
COUNT=`expr $COUNT + 1`
done 
echo "$pmcucp"
echo "$pmdu"
echo "$etcmcuup"
echo "$etcmdu"
echo "$ftemcuup"
echo "$ftemdu"

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"

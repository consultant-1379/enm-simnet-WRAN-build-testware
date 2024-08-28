#!/bin/sh

echo "#####################################################################"
echo "# $0 script Started Execution"
echo "---------------------------------------------------------------------"

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <rnc count>"
 echo
 echo "Example: RNCV71569x1-FT-PRBS17Ax2-RNC01 CONFIG.env 1"
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

NUMOFMSRBS=$(echo $SIMNAME | awk -F"MSRBS" '{print $2}'| awk -F"x" '{print $2}'| awk -F"-" '{print $1}')
RncStr=(${SIMNAME//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

NodeStr=$(echo $SIMNAME | awk -F"MSRBS" '{print $2}'| awk -F"x" '{print $2}')
NUMOFMSRBS=(${NodeStr//-/ })
echo "NUM of Msrbs: $NUMOFMSRBS"

. ../dat/$ENV
. utilityFunctions.sh

PWD=`pwd`

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
        "productionDate" String ""
        "description" String ""
        "type" String ""

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
        "productionDate" String ""
        "description" String ""
        "type" String ""

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
        "productionDate" String ""
        "description" String ""
        "type" String ""

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
        "productionDate" String ""
        "description" String ""
        "type" String ""

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
        "productionDate" String ""
        "description" String ""
        "type" String ""

)



// Create Statement generated: 2017-08-14 13:06:04




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
        "productionDate" String ""
        "description" String ""
        "type" String ""

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
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsSwIM:SwInventory=1,RcsSwIM:SwItem=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "$productNumber"
        "productRevision" String "$productRevision"
        "productionDate" String ""
        "description" String ""
        "type" String ""

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
        "productionDate" String ""
        "description" String ""
        "type" String ""

)


MOSC
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

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"


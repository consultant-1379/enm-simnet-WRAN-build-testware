#!/bin/sh

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <numOfMsrbsNodes>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)"
 echo
 exit 1
fi


SIMNAME=$1
NUMOFRBS=$3

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


productNumber="CXP9024418/6"
productRevision="R21A43"

NOW=`date +"%Y_%m_%d_%T:%N"`
pdkdate="$NOW"

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME'MSRBS-V20'$COUNT
else
NODENAME=$RNCNAME'MSRBS-V2'$COUNT
fi
MOSCRIPT=$NODENAME"_dg2Product.mo"
MMLSCRIPT=$NODENAME"_dg2Product.mml"
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=1"
	identity 1
	moType RcsHwIM:HwItem
    // moid = 6005
    exception none
    nrOfAttributes 18
    "hwItemId" String ""
    "vendorName" String ""
    "hwModel" String ""
    "hwType" String ""
    "hwName" String ""
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "dateOfLastService" String ""
    "dateOfManufacture" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String ""
        "productRevision" String ""
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
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

// Create Statement generated: 2017-08-14 13:05:37
CREATE
(
    parent "ManagedElement=$NODENAME,SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=2"
	identity 2
	motype RcsHwIM:HwItem
    // moid = 6006
    exception none
    nrOfAttributes 18
    "hwItemId" String ""
    "vendorName" String ""
    "hwModel" String ""
    "hwType" String ""
    "hwName" String ""
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "dateOfLastService" String ""
    "dateOfManufacture" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String ""
        "productRevision" String ""
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "productionDate" String ""
        "description" String ""
        "type" String ""

)



// Create Statement generated: 2017-08-14 13:06:04

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsHwIM:HwInventory=1,RcsHwIM:HwItem=2,RcsHwIM:HwItem=2"
	exception none
    nrOfAttributes 18
    "hwItemId" String ""
    "vendorName" String ""
    "hwModel" String ""
    "hwType" String ""
    "hwName" String ""
    "hwCapability" String ""
    "equipmentMoRef" Array Ref 0
    "additionalInformation" String ""
    "hwUnitLocation" String ""
    "manualDataEntry" Integer 1
    "serialNumber" String ""
    "dateOfLastService" String ""
    "dateOfManufacture" String ""
    "swInvMoRef" Array Ref 0
    "licMgmtMoRef" Array Ref 0
    "additionalAttributes" Array Struct 0
    "productIdentity" Struct
        nrOfElements 3
        "productNumber" String ""
        "productRevision" String ""
        "productDesignation" String ""

    "productData" Struct
        nrOfElements 6
        "productName" String ""
        "productNumber" String ""
        "productRevision" String ""
        "productionDate" String ""
        "description" String ""
        "type" String ""

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

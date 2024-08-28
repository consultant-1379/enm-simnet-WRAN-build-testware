#!/bin/sh

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> "
 echo
 echo "Example: RNCV71569x1-FT-PRBS17Ax2-RNC01 1 "
 echo
 exit 1
fi




SIMNAME=$1



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

echo "$RNCNAME"

cat >> $MOSCRIPT << MOSC

DELETE
(

    mo "parent ManagedElement=1,SystemFunctions=1,Licensing=1"
    moType RncFeature
    identity GpehCapIncrRedRopPer
    exception none
    nrOfAttributes 7
    "reservedBy" Array Ref 0
    "RncFeatureId" String ""
    "featureState" Integer 1
    "licenseState" Integer 1
    "serviceState" Integer 0
    "keyId" String ""
    "isLicenseControlled" Integer 0


)

CREATE
(
    parent "ManagedElement=1,SystemFunctions=1,Licensing=1"
    moType RncFeature
    identity GpehCapIncrRedRopPer
    exception none
    nrOfAttributes 7
    "reservedBy" Array Ref 0
    "RncFeatureId" String ""
    "featureState" Integer 0
    "licenseState" Integer 1
    "serviceState" Integer 0
    "keyId" String ""
    "isLicenseControlled" Integer 0
)

MOSC
echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT


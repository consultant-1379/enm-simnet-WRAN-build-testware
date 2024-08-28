#!/bin/sh


if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env (to create RNC09)"
 echo
 exit 1
fi




SIMNAME=$1

NUMOFRBS=$(echo $SIMNAME | awk -F"MSRBS" '{print $2}'| awk -F"x" '{print $2}'| awk -F"-" '{print $1}')
RncStr=(${SIMNAME//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

PWD=`pwd`
date=`date`

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME"MSRBS-V20"$COUNT
else
NODENAME=$RNCNAME"MSRBS-V2"$COUNT
fi
MOSCRIPT=$NODENAME"_LicenseMo.mo"
MMLSCRIPT=$NODENAME"_LicenseMo.mml"

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

cat >> $MOSCRIPT << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,RmeSupport:NodeSupport=1,RmeLicenseSupport:LicenseSupport=1,RmeLicenseSupport:InstantaneousLicensing=1"
    exception none
    nrOfAttributes 3
    "swltId" String "19DZ725311F4595D22D12666"
    "euft" String "949525"
    "availabilityStatus" Array Integer 1
         3
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsLM:Lm=1,RcsLM:CapacityKey=1"
    exception none
    nrOfAttributes 3
    "productType" String "WRAN"
    "validFrom" String "$date"
    "keyId" String "RadioNode"
    "licensedCapacityLimit" Struct
        nrOfElements 2
        "value" Int32 32
        "noLimit" Boolean false
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



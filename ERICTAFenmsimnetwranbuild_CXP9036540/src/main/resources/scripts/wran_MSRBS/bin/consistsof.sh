#!/bin/sh

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <prbsnum>"
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


productNumber="CXP9028777/1"
productRevision="R1AC"

NOW=`date +"%Y_%m_%d_%T:%N"`
pdkdate="$NOW"

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME'PRBS0'$COUNT
else
NODENAME=$RNCNAME'PRBS'$COUNT
fi
MOSCRIPT=$NODENAME"_PicoProduct.mo"
MMLSCRIPT=$NODENAME"_PicoProduct.mml"
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwItem=1"
    // moid = 25
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)


SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwVersion=1"
    // moid = 24
    exception none
    nrOfAttributes 1
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwItem=1
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

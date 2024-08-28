#!/bin/sh


if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <prbsnum>"
 echo
 echo "Example: RNCV71569x1-FT-PRBS17Ax2-RNC01 1 2"
 echo
 exit 1
fi




SIMNAME=$1
NUMOFPRBS=$3

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

PRODUCTNUMBER=CXP9028777/1
PRODUCTREVISION=R1AC

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

while [ "$COUNT" -le "$NUMOFPRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME"PRBS0"$COUNT
else
NODENAME=$RNCNAME"PRBS"$COUNT
fi
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwItem=1"
    // moid = 107
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "SwItem"
        "productNumber" String "$PRODUCTNUMBER"
        "productRevision" String "$PRODUCTREVISION"
        "productionDate" String "2017-06-16T08:47:27"
        "description" String ""
        "type" String "1"

)

// Set Statement generated: 2017-06-16 08:06:29
SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwVersion=1"
    // moid = 106
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "SwVersion"
        "productNumber" String "$PRODUCTNUMBER"
        "productRevision" String "$PRODUCTREVISION"
        "productionDate" String "2017-06-16T08:47:27"
        "description" String ""
        "type" String "1"

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


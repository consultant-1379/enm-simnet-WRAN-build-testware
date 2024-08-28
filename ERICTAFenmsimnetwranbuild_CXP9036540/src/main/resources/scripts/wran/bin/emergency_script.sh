#!/bin/sh


if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <env file>"
 echo
 echo "Example: RNCV71569x1-FT-PRBS17Ax2-RNC01 CONFIG.env"
 echo
 exit 1
fi

SIMNAME=$1
ENV=$2

RncStr=(${SIM//RNC/ })
RNCCOUNT=${RncStr[1]}
NodeStr=$(echo $SIM | awk -F"PRBS" '{print $2}'| awk -F"x" '{print $2}')
PRBSNUM=(${NodeStr//-/ })

. ../dat/$ENV
. utilityFunctions.sh

PWD=`pwd`

NODEMIM=`getMimType $COUNT $PICOVERSIONARRAY`

IFS=";"

for x in $PICOPRODUCTARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$RBSMIM" ]
then
PICOPRODNUMBER=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
PICOPRODVERSION=$(echo $x | awk -F":" '{print $2}')
break

fi

done

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
        "productName" String "$NODENAME"
        "productNumber" String "CXP9028777/1"
        "productRevision" String "R1AC"
        "productionDate" String "2017-06-16T08:47:27"
        "description" String "MSRBS_V1"
        "type" String "MSRBS_V1"

)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwItem=1"
    // moid = 107
    exception none
    nrOfAttributes 2
    "userLabel" String "$NODENAME"
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwItem=1
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwVersion=1"
    // moid = 106
    exception none
    nrOfAttributes 2
    "userLabel" String "$NODENAME"
    "administrativeData" Struct
        nrOfElements 6
        "productName" String "$NODENAME"
        "productNumber" String "CXP9028777/1"
        "productRevision" String "R1AC"
        "productionDate" String "2017-06-16T08:47:27"
        "description" String "MSRBS_V1"
        "type" String "MSRBS_V1"

)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwVersion=1"
    // moid = 107
    exception none
    nrOfAttributes 2
    "userLabel" String "$NODENAME"
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwVersion=1"
    // moid = 107
    exception none
    nrOfAttributes 2
    "userLabel" String "$NODENAME"
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1"
    exception none
    nrOfAttributes 3
    "active" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
    "swInventoryId" String "1"
    "userLabel" String "null"
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


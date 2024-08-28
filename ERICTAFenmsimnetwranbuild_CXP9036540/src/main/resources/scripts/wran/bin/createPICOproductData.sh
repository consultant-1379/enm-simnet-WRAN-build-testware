#!/bin/sh

echo "#####################################################################"
echo "# $0 script Started Execution"
echo "---------------------------------------------------------------------"

if [ "$#" -ne 4  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> < RNCNUM> <PICO ProductData>"
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
PICOPRODUCTDATA=$4

if [ "$3" -le 9 ]
then
RNCNAME="RNC0"$3
RNCCOUNT="0"$3
else
RNCNAME="RNC"$3
RNCCOUNT=$3
fi

#RncStr=(${SIM//RNC/ })
#RNCCOUNT=${RncStr[1]}
NodeStr=$(echo $SIMNAME | awk -F"PRBS" '{print $2}'| awk -F"x" '{print $2}')
NUMOFPRBS=(${NodeStr//-/ })
echo "NUM of Prbs: $NUMOFPRBS"

. ../dat/$ENV
. utilityFunctions.sh

PWD=`pwd`

NODEMIM=`getMimType $3 $PICOVERSIONARRAY`

IFS=";"

for x in $PICOPRODUCTARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$NODEMIM" ]
then
PICOPRODNUMBER=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
PICOPRODVERSION=$(echo $x | awk -F":" '{print $2}')
break

fi

done
PICOPRODNUMBER=$(echo $PICOPRODUCTDATA | awk -F ":" '{print $1}')
PICOPRODVERSION=$(echo $PICOPRODUCTDATA | awk -F ":" '{print $2}')
echo "Prod Number: $PICOPRODNUMBER"
echo "Prod version: $PICOPRODVERSION"

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
        "productNumber" String "$PICOPRODNUMBER"
        "productRevision" String "$PICOPRODVERSION"
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
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwVersion=1
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
        "productNumber" String "$PICOPRODNUMBER"
        "productRevision" String "$PICOPRODVERSION"
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
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwItem=1
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,MSRBS_V1_SwIM:SwInventory=1,MSRBS_V1_SwIM:SwVersion=1"
    // moid = 107
    exception none
    nrOfAttributes 2
    "userLabel" String "$NODENAME"
    "consistsOf" Array Ref 1
        ManagedElement=$NODENAME,SystemFunctions=1,SwInventory=1,SwItem=1
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

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"


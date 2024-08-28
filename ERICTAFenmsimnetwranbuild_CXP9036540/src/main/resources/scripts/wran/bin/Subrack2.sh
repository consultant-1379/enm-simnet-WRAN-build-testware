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




NOW=`date +"%Y_%m_%d_%T:%N"`
pdkdate="$NOW"

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME'RBS0'$COUNT
else
NODENAME=$RNCNAME'RBS'$COUNT
fi
MOSCRIPT=$NODENAME"_SUBRACK.mo"
MMLSCRIPT=$NODENAME"_SUBRACK.mml"
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=CBU"
    // moid = 2436
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 5
        "productName" String "RBS14B"
        "productNumber" String "ENM14B"
        "productRevision" String "27CXP124553"
        "serialNumber" String "3oQ"
        "productionDate" String ""

)


SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX"
    // moid = 2441
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 5
        "productName" String "RBS14B"
        "productNumber" String "ENM14B"
        "productRevision" String "28CXP124665"
        "serialNumber" String "3oQ"
        "productionDate" String ""

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


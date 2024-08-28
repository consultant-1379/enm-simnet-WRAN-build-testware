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

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME"MSRBS-V20"$COUNT
else
NODENAME=$RNCNAME"MSRBS-V2"$COUNT
fi
MOSCRIPT=$NODENAME"_FilePull.mo"
MMLSCRIPT=$NODENAME"_FilePull.mml"

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
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsPMEventM:PmEventM=1,RcsPMEventM:EventProducer=Lrat,RcsPMEventM:FilePullCapabilities=2"
    // moid = 3603
    exception none
    nrOfAttributes 1
    "outputDirectory" String "/c/pm_data/"
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,ComTop:SystemFunctions=1,RcsPm:Pm=1,RcsPm:PmMeasurementCapabilities=1"
    // moid = 40
    exception none
    nrOfAttributes 1
    "fileLocation" String "/c/pm_data/"
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



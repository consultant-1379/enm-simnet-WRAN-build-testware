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
productRevision="R1AA"

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
MOSCRIPT=$NODENAME"_RBSAnalyser.mo"
MMLSCRIPT=$NODENAME"_RBSAnalyser.mml"
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ManagedElement=1,NodeBFunction=1"
    // moid = 2621
    identity "1"
    moType UlSpectrumAnalyzer
    exception none
    nrOfAttributes 5
    "ulSpectrumSamplingStatus" Integer 0
    "info" Integer 0
    "UlSpectrumAnalyzerId" String "1"
    "targetAiDevice" String ""
    "samplingType" Integer 0
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

echo '.open '$SIMNAME >> abc.mml
echo '.select network' >> abc.mml
echo '.saveandcompress force nopmdata' >> abc.mml
/netsim/inst/netsim_shell < abc.mml
rm abc.mml

#!/bin/sh
SIM=$1
RBSNUM=$3
RNCNUM=$2
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> rncnum rbsnum"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10 NRM3_60KG1.env"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

PWD=`pwd`

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

NOW=`date +"%Y_%m_%d_%T:%N"`
pdkdate="$NOW"

COUNT=1

while [ "$COUNT" -le "$RBSNUM"  ]
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
DELETE
(
  mo "ManagedElement=1,NodeBFunction=1,UlSpectrumAnalyzer=1"
)

MOSC
echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
COUNT=`expr $COUNT + 1`
done
echo " #######Execution of script ended####### "


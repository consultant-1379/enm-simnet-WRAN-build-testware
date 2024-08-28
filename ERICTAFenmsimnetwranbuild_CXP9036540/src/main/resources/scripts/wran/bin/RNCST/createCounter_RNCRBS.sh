#!/bin/sh


if [ "$#" -ne 4  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <rnc num> <rbsnum>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)"
 echo
 exit 1
fi




SIMNAME=$1
ENV=$2
NUMOFRBS=$4

if [ "$3" -le 9 ]
then
RNCNAME="RNC0"$3
RNCCOUNT="0"$3
else
RNCNAME="RNC"$3
RNCCOUNT=$3
fi


if [ "$3" -eq 0 ]
then
RNCNAME=
fi


. ../../dat/$ENV


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



#########################################
# 
# Make MO Script
#
#########################################

echo ""
echo "MAKING MO SCRIPT"
echo ""


COUNT=1
while [ "$COUNT" -le 4 ]
do

 case "$COUNT"
 in
   1) MOTYPE=Aal0TpVccTp ;;
   2) MOTYPE=Aal1TpVccTp ;;
   3) MOTYPE=Aal2PathVccTp ;;
   4) MOTYPE=Aal5TpVccTp ;;
 esac
for iterator in 1 2 3 4 5 
do
echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
echo '   identity pm-'"$iterator"'' >> $MOSCRIPT
echo '   moType '$MOTYPE >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

done
COUNT=`expr $COUNT + 1`
done




#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""

echo '.open '$SIMNAME >> pqr.mml
echo '.select '$RNCNAME >> pqr.mml
echo '.start ' >> pqr.mml
echo 'useattributecharacteristics:switch="off";' >> pqr.mml
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> pqr.mml

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
echo '.open '$SIMNAME >> $MMLSCRIPT
if [ $COUNT -le 9 ]
then
echo '.select '$RNCNAME'RBS0'$COUNT >> $MMLSCRIPT
else
echo '.select '$RNCNAME'RBS'$COUNT >> $MMLSCRIPT
fi
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
COUNT=`expr $COUNT + 1`
done


$NETSIMDIR/$NETSIMVERSION/netsim_pipe < pqr.mml
$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT



rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT
rm $PWD/pqr.mml






































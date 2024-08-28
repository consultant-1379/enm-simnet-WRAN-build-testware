#!/bin/sh

echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2  ]
then
 echo
 echo "#************* Please give inputs correctly **********************#"
 echo
 echo "Usage: $0 <sim name> <envfile>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10 CONFIG.env"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

SIM=$1
ENV=$2
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

RbsStr=$(echo $SIM | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
echo "RNCNUM: $RNCNUM"
RNCNAME="RNC"$RNCNUM

if [ "$RNCNUM" -le "9" ]
then
NUMOFRNC=(${RNCNUM//0/ })
else
NUMOFRNC=$RNCNUM
fi

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

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
echo '   identity pm-1' >> $MOSCRIPT
echo '   moType '$MOTYPE >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


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

echo '.open '$SIM >> pqr.mml
echo '.select '$RNCNAME >> pqr.mml
echo '.start ' >> pqr.mml
echo 'useattributecharacteristics:switch="off";' >> pqr.mml
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> pqr.mml

if [ "$RBS_NODE_CREATION" == "YES" ]
then
   COUNT=1
   while [ "$COUNT" -le "$RBSNUM"  ]
   do
   echo '.open '$SIM >> $MMLSCRIPT
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
   $NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT
fi

$NETSIMDIR/$NETSIMVERSION/netsim_pipe < pqr.mml

rm $PWD/$MOSCRIPT
rm $PWD/pqr.mml


cd RNCST/
./3000createRNC_Direct_Connection_MUB_Crossconnected.sh $SIM $ENV $NUMOFRNC

if [ "$RBS_NODE_CREATION" == "YES" ]
then
cd ../RBSST
./3000createRBS_Direct_Connection_MUB_Crossconnected.sh $SIM $ENV $NUMOFRNC 1 $RBSNUM
fi

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"


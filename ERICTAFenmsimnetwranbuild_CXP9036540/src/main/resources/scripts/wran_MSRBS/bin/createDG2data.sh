#!/bin/sh

if [ "$#" -ne 3 ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <count>"
 echo
 echo "Example: $0 RNCJ30-ST-RNC01 SIM1.env 1"
 echo
 exit 1
fi

SIM=$1
ENV=$2
COUNT=$3

# Initilize the allBGP
#echo "" &
#allBGP=$!
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

echo "//"
echo "//..$SIM:$0 started at `date`" | tee -a $LOGFILE


cd $SIMDIR/bin/$DG2DIR

./runScripts.sh $SIM $ENV $COUNT 1 | tee -a $SIMDIR"/log/"$SIM"-DG2-1.log"

echo "**********************************************************"
echo "deleting all MO and MML files"
echo "***********************************************************"
rm -rf *.mo
rm -rf *.mml


echo "//"
echo "//..$SIM:$0 ended at `date`" | tee -a $LOGFILE


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


cd $SIMDIR/bin/$RBSDIR

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MMLSCRIPT=$0:$NOW:$SIM".mml"


#1 sh: no transport
#2 sh: IP transport
#3 sh: ATM transport



#Below script call moved to down by xramjag to avoid subrack slot missing errors
#./runScripts.sh $SIM $ENV $COUNT 1 | tee -a $SIMDIR"/log/"$SIM"-RBS-1.log"


if [ "$3" -le 9 ]
then
RNCNAME="RNC0"$3
RNCCOUNT="0"$3
else
RNCNAME="RNC"$3
RNCCOUNT=$3
fi

neType="RBS"

rbsNames=`echo ".selectregexp simne .*$RNCNAME$neType.*" | /netsim/inst/netsim_pipe -sim $SIM | grep -i ".select " | awk -F" " '{print $3}'`;

rbsNamesArr=(`echo $rbsNames | sed -e "s/|/ /g"`)

#moved up
./aOut1202createCarrier.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-createCarrier-1.log"



for i in "${rbsNamesArr[@]}"
do
         ./Test_1000createRadioNetworkForRBS.sh $SIM $ENV $COUNT $i | tee -a $SIMDIR"/log/"$SIM"-RBS-1.log"
	./Test_1110createSubrackSlot.sh $SIM $ENV $COUNT $i		
 #       ./aOut1170createRbsLocalCell2.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-RBSlocalcell-1.log"

done


./runScripts.sh $SIM $ENV $COUNT 1 | tee -a $SIMDIR"/log/"$SIM"-RBS-1.log"

./1126createAtmPort.sh $SIM $ENV $COUNT
./1180createTNMOs.sh $SIM $ENV $COUNT

#./aOut1170createRbsLocalCell2.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-RBSlocalcell-1.log"

#./aOut1202createCarrier.sh $SIM $ENV $COUNT 



./runScripts.sh $SIM $ENV $COUNT 9 | tee -a $SIMDIR"/log/"$SIM"-RBS-1.log"

#### Transport will be inserted here
#
#if [ "$TRANSPORT" == "YES" ]
#then
#  echo "" 
#  echo "$SIM:RBS TRANSPORT LAYER CREATION STARTED at "`date` | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
#  echo ""  | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
#
#  cd $SIMDIR/bin/
#  ./createRBS_Transport_Data.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
#  cd $SIMDIR/bin/$RBSDIR
#
#  echo "" | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
#  echo "  $SIM: RBS TRANSPORT LAYER CREATION ENDED at "`date` | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
#  echo "" | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
#fi

#cd $SIMDIR/bin
#./stopNEs.sh $SIM '.*RBS.*'  | tee -a $SIMDIR"/log/"$SIM"-RBS-1.log"

echo "//"
echo "//..$SIM:$0 ended at `date`" | tee -a $LOGFILE


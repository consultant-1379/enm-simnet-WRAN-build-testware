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

. ../../dat/$ENV
CURRDIR=$SIMDIR"/bin/OSSRC"
RNCNUM=$(echo $SIM | awk -F"RNC" '{print $3}')
SIMNUM=$(expr $RNCNUM + 0)
cd $SIMDIR/bin/RNCST
./3200createRNC_Direct_Connection_MUB_Crossconnected_high_speed.sh $SIM $ENV $SIMNUM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-OSSRC_data.log"
cd $SIMDIR/bin/RBSST
./3020createRBS_Direct_Connection_MUB_Crossconnected_high_speed.sh $SIM $ENV $SIMNUM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-OSSRC_data.log"
cd $CURRDIR
./setGigaBitEthernet.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-OSSRC_data.log"
./setIpInterface.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-OSSRC_data.log"
./setAal2PathDistribution.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-OSSRC_data.log"

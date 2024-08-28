#/!bin/sh

SIM=$1
ENV=$2
RNCNUM=$3
RBSNUM=$4
. ../dat/$ENV


./createRNCproductdata.sh $SIM $ENV $RNCNUM
./createRBSproductdata.sh $SIM $ENV $RNCNUM $RBSNUM
./setRNC_JAR.sh $SIM $ENV $RNCNUM
./createCounters.sh $SIM $ENV $RNCNUM $RBSNUM
./set_DeviceGroup.sh $SIM $RNCNUM

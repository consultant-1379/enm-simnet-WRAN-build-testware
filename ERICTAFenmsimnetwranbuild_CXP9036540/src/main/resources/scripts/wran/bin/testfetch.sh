#!/bin/sh

SIM=$1
ENV=$2

RncStr=(${SIM//RNC/ })
COUNT=${RncStr[1]}
NodeStr=$(echo $SIM | awk -F"PRBS" '{print $2}'| awk -F"x" '{print $2}')
PRBSNUM=(${NodeStr//-/ })

. ../dat/$ENV
. utilityFunctions.sh

PICOVERSION=`getMimType $COUNT $PICOVERSIONARRAY`


echo "PICOVERSION: $PICOVERSION"
echo "Pico Nodes: $PRBSNUM"

#!/bin/sh

# Created by  : unknown
# Created in  : unknown
##
### VERSION HISTORY
##############
# Ver2        : Moddified for TERE 10.3
# Purpose     : Req id:4652
# Description : a2ea attribute of Aal2Sp MO is set.
# Date        : 06 JUL 2010
# Who         : Fatih ONUR


if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCL130-ST-RNC01 R7-ST-G-N.env 1

HELP

exit
fi



SIMNAME=$1
ENV=$2


if [ "$3" -le 9 ]
then
RNCNAME="RNC0"$3
RNCCOUNT="0"$3
else
RNCNAME="RNC"$3
RNCCOUNT=$3
fi

PWD=`pwd`
source $PWD/../../dat/$ENV


PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`


MOSCRIPT=$0${NOW}".mo"
MMLSCRIPT=$0${NOW}".mml"

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

A2EA=12345

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
echo ' identity 1' >> $MOSCRIPT
echo ' moType Aal2Sp' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 1' >> $MOSCRIPT
echo "    a2ea String "$A2EA  >> $MOSCRIPT
echo ')' >> $MOSCRIPT


COUNT1=1
COUNT2=24
COUNT3=1

if [ "$3" -eq 2 ]
then
COUNTEND=90
else
COUNTEND=32
fi


while [ "$COUNT1" -le "$COUNTEND" ]
do

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
echo ' identity MS-'$COUNT2'-'$COUNT3 >> $MOSCRIPT
echo ' moType AtmPort' >> $MOSCRIPT
echo ' exception none' >> $MOSCRIPT
echo ' nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

COUNT3=`expr $COUNT3 + 1`

REM=`expr $COUNT1 % 8`
if [ "$REM" -eq 0 ]
then
COUNT2=`expr $COUNT2 + 1`
COUNT3=1
fi

COUNT1=`expr $COUNT1 + 1`
done

#echo 'CREATE' >> $MOSCRIPT
#echo '(' >> $MOSCRIPT
#echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
#echo ' identity 1' >> $MOSCRIPT
#echo ' moType Synchronization' >> $MOSCRIPT
#echo ' exception none' >> $MOSCRIPT
#echo ' nrOfAttributes 2' >> $MOSCRIPT
#echo ' syncRefActivity Array Integer 1' >> $MOSCRIPT
#echo ' 1' >> $MOSCRIPT
#echo ' syncRefStatus Array Integer 1' >> $MOSCRIPT
#echo ' 3' >> $MOSCRIPT
#echo ')' >> $MOSCRIPT



#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""

echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT


$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT

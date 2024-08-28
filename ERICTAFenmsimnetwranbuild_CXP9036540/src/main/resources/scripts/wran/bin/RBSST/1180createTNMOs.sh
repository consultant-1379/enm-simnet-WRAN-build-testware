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

CREATE: AtmPort, Aal2Sp, MspgExtended

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

if [ "$3" -eq 0 ]
then
RNCNAME=
fi

PWD=`pwd`
source $PWD/../../dat/$ENV


PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

max=1000000
RANDOM=$((`cat /dev/urandom|od -N1 -An -i` % $max))

MOSCRIPT=$0${NOW}:$$${RANDOM}".mo"
MMLSCRIPT=$0${NOW}:$$${RANDOM}".mml"

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

COUNT=1

while [ "$COUNT" -le 8 ]
do

cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,TransportNetwork=1"
   identity 1-1-$COUNT
   moType AtmPort
   exception none
   nrOfAttributes 0
)

MOSCT

COUNT=`expr $COUNT + 1`
done


cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,TransportNetwork=1"
   identity 1
   moType Aal2Sp
   exception none
   nrOfAttributes 1
     a2ea String $A2EA
)


CREATE
(
  parent "ManagedElement=1,TransportNetwork=1"
   identity 1
   moType MspgExtended
   exception none
   nrOfAttributes 0
)

MOSCT

#echo 'CREATE' >> $MOSCRIPT
#echo '(' >> $MOSCRIPT
#echo '  parent "ManagedElement=1,TransportNetwork=1"' >> $MOSCRIPT
#echo '   identity 1' >> $MOSCRIPT
#echo '   moType Synchronization' >> $MOSCRIPT
#echo '   exception none' >> $MOSCRIPT
#echo '   nrOfAttributes 2' >> $MOSCRIPT
#echo '   syncRefActivity Array Integer 1' >> $MOSCRIPT
#echo '   1' >> $MOSCRIPT
#echo '   syncRefStatus Array Integer 1' >> $MOSCRIPT
#echo '   3' >> $MOSCRIPT
#echo ')' >> $MOSCRIPT



#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""

cat >> $MMLSCRIPT << MMLSCT

.open $SIMNAME 
.selectregexp simne $RBSNES 
.start 
useattributecharacteristics:switch="off";
kertayle:file="$PWD/$MOSCRIPT";

MMLSCT


$NETSIMDIR/$NETSIMVERSION/netsim_shell < $MMLSCRIPT

rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT


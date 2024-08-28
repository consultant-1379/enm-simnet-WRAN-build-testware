#!/bin/sh

####################################
#
# Ver1: Created for R6.2 TERE.
#
####################################

if [ "$#" -ne 3  ]
then
cat<<HELP

Usage: $0 <sim name> <env file> <rnc num>

Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)

CREATE: PlugInUnit

HELP
 exit 1
fi



SIMNAME=$1
ENV=$2

. ../../dat/$ENV

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

COUNT=1

while [ "$COUNT" -le 24 ]
do


cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=$COUNT"
   identity 1
   moType PlugInUnit
   exception none
   nrOfAttributes 0
)

MOSCT

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


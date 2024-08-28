#!/bin/sh

####################################
#
# Ver1: Created for R6.2 TERE.
#
####################################

if [ "$#" -ne 3  ]
then
cat<<HELP

#######################################################################
#                                                                     #
#                             HELP                                    #
#                                                                     #
#######################################################################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)

CREATE :-

SET    :-

DELETE :-

HELP
 exit 1
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

. ../../dat/$ENV

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

VAR=1
while [ "$VAR" -le 3 ]
do

 case "$VAR"
 in 
  1) SLOTID=4;;
  2) SLOTID=5;;
  3) SLOTID=24;;
 esac


cat >> $MOSCRIPT << MOSCT

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=$SLOTID" 
   identity 1 
   moType PlugInUnit 
   exception none 
   nrOfAttributes 0 
) 

MOSCT

VAR=`expr $VAR + 1`
done


cat >> $MOSCRIPT << MOSCT

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1" 
   identity ET-M1 
   moType ExchangeTerminal 
   exception none 
   nrOfAttributes 0 
) 

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1,ExchangeTerminal=ET-M1 
   identity 1 
   moType E1PhysPathTerm 
   exception none 
   nrOfAttributes 0 
) 

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1" 
   identity 1 
   moType TuDeviceGroup 
   exception none 
   nrOfAttributes 0 
) 

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1,TuDeviceGroup=1" 
   identity 1 
   moType TimDeviceSet 
   exception none 
   nrOfAttributes 0 
) 

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1,TuDeviceGroup=1,TimDeviceSet=1" 
   identity 1 
   moType TimDevice 
   exception none 
   nrOfAttributes 0 
) 

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1 
   identity 1 
   moType TimingUnit 
   exception none 
   nrOfAttributes 0 
) 

CREATE 
( 
  parent "ManagedElement=1,Equipment=1,Subrack=1,Slot=4,PlugInUnit=1,TimingUnit=1 
   identity 1 
   moType TuSyncRef 
   exception none 
   nrOfAttributes 0 
) 

MOSCT

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


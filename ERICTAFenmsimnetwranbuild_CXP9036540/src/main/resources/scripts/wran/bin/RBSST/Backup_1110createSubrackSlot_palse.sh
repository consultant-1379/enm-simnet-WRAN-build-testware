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

CREATE: Subrack, (Subrack)Slot

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

if [ "$3" -eq 0 ]
then
RNCNAME=
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

SUBRACKSTART=1
SUBRACKSTOP=4

SUBRACKCOUNT=$SUBRACKSTART

while [ "$SUBRACKCOUNT" -le "$SUBRACKSTOP" ]
do

cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,Equipment=1"
   identity $SUBRACKCOUNT
   moType Subrack
   exception none
   nrOfAttributes 0
	"operationalProductData" Struct
        nrOfElements 5
        "productName" String "1"
        "productNumber" String "2"
        "productRevision" String "3"
        "serialNumber" String "4"
        "productionDate" String "5"

"subrackPosition" String "0"

)

MOSCT

SLOTSTART=1
SLOTSTOP=28
SLOTCOUNT=$SLOTSTART

while [ "$SLOTCOUNT" -le "$SLOTSTOP" ]
do

if [ $SLOTCOUNT == 1 ]; then
cat >> $MOSCRIPT << MOSCT

CREATE
(
  parent "ManagedElement=1,Equipment=1,Subrack=$SUBRACKCOUNT"
   identity $SLOTCOUNT
   moType Slot
   exception none
   nrOfAttributes 0
   "productData" Struct
        nrOfElements 5
        "productName" String " DUL 20 01 "
        "productNumber" String "KDU137533/4"
        "productRevision" String "R2A "
        "serialNumber" String "20111130 "
        "productionDate" String "C825522633 "  
)

MOSCT
else
cat >> $MOSCRIPT << MOSCT
 
CREATE
(
  parent "ManagedElement=1,Equipment=1,Subrack=$SUBRACKCOUNT"
   identity $SLOTCOUNT
   moType Slot
   exception none
   nrOfAttributes 0
)

MOSCT
fi

SLOTCOUNT=`expr $SLOTCOUNT + 1`
done


SUBRACKCOUNT=`expr $SUBRACKCOUNT + 1`
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


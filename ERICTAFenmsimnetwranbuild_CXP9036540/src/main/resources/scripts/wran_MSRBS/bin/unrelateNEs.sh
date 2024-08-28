#!/bin/sh

# Created by : XRANDYA 
##
### VERSION HISTORY
##################################################
# Ver1        : Created for O16B 
# Purpose     : Unrelate NEs for G2 querying 
# Description :
# Date        : 2015-06-01
# Who         : XRANDYA 
##################################################



if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCL145-ST-RNC15 R7-ST-K-N.env 15

HELP

exit 1
fi

################################
# MAIN
################################

SIMNAME=$1
ENV=$2
RNCIDCOUNT=$3
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

if [ "$RNCIDCOUNT" -le 9 ]
then
  RNCNAME="RNC0"$RNCIDCOUNT
  RNCCOUNT="0"$RNCIDCOUNT
else
  RNCNAME="RNC"$RNCIDCOUNT
  RNCCOUNT=$RNCIDCOUNT
fi

if [ "$RNC_NODE_CREATION" != "YES" ]
then
  RNCNAME=""
fi


echo "#//...$0:$SIMNAME script started running at "`date`
echo "#//"


PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:${NOW}:$SIMNAME
MMLSCRIPT=$0:${NOW}:$SIMNAME".mml"

SCRIPTNAME=`basename "$0"`
DELETE_ALL_MO_SCRIPTS="DELETE_ALL_MO_SCRIPTS_${SIMNAME}_${SCRIPTNAME}"

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

#echo ""
#echo "MAKING MO SCRIPT"
#echo ""

NUMOFDG2=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`
COUNT=1
MOFILECOUNT=1

  cat >> $MMLSCRIPT << MMLSCT
  .open $SIMNAME
  .select network
  .stop
  .unrelate
MMLSCT
while [ "$COUNT" -le "$NUMOFDG2" ]
do
  
  if [ "$COUNT" -le 9 ]
   then
    DG2NAME=MSRBS-V20
   else
    DG2NAME=MSRBS-V2
  fi
  DG2NAME1=MSRBS-V2
  MOFILEEXTENSION="__"$MOFILECOUNT".mo"

####################################################################################################

  cat >> $MMLSCRIPT << MMLSCT
  .select $DG2NAME$COUNT
  .rename -auto $RNCNAME$DG2NAME1 $COUNT

MMLSCT
COUNT=`expr $COUNT + 1`
echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts
done


################################################
$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

cat $PWD/$MMLSCRIPT 
#rm $PWD/$MMLSCRIPT
#rm $PWD/$CIDMOSCRIPT
#rm $PWD/$CIDMMLSCRIPT
exit

#############################
#rm $MMLSCRIPT
#. $DELETE_ALL_MO_SCRIPTS
#rm $DELETE_ALL_MO_SCRIPTS

echo "#//...$0:$SIMNAME script ended running at "`date`
echo "#//"


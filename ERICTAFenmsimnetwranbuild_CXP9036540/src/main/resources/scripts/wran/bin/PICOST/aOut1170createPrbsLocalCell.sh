#!/bin/sh

# Created by : eagachi 
##
### VERSION HISTORY
##################################################
# Ver1        : Created for 013B TERE
##################################################



if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCL145-ST-RNC15 R7-ST-K-N.env 15

SETS: NodeBLocalCell and Iub 

HELP

exit 1
fi

################################
# MAIN
################################

SIMNAME=$1
ENV=$2
RNCIDCOUNT=$3

. ../../dat/$ENV
. ../utilityFunctions.sh

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

NUMOFPRBS=`getNumOfPICO $RNCCOUNT $RNCPICOARRAY`

CIDSTART=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`

CELLID=$CIDSTART

COUNT=1
MOFILECOUNT=1

while [ "$COUNT" -le "$NUMOFPRBS" ]
do
  
  if [ "$COUNT" -le 9 ]
   then
    PRBSNAME=PRBS0
   else
    PRBSNAME=PRBS
  fi
  
  MOFILEEXTENSION="__"$MOFILECOUNT".mo"

####################################################################################################


    #echo " :: RBSCOUNT="$RBSCOUNT" RbsLocalCell="$CELLCOUNT

    cat >> $MOSCRIPT$MOFILEEXTENSION << MOSCT
      SET 
       (
        mo "ManagedElement=$RNCNAME$PRBSNAME$COUNT,NodeBFunction=1,NodeBLocalCellGroup=1,NodeBLocalCell=1"
          exception none
          nrOfAttributes 1 
            localCellId Long $CELLID
       )
MOSCT
       
    CELLID=`expr $CELLID + 1`

  cat >> $MOSCRIPT$MOFILEEXTENSION << MOSCT
      SET
      (
   	  mo "ManagedElement=$RNCNAME$PRBSNAME$COUNT,NodeBFunction=1,Iub=1"
   	   exception none
   	   nrOfAttributes 2
   	   rbsId Integer $COUNT
      )
MOSCT


  cat >> $MMLSCRIPT << MMLSCT
  .open $SIMNAME
  .select $RNCNAME$PRBSNAME$COUNT
  .start
  kertayle:file="$PWD/$MOSCRIPT$MOFILEEXTENSION";

MMLSCT

echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts
  
  MOFILECOUNT=`expr $MOFILECOUNT + 1`
  COUNT=`expr $COUNT + 1`
done


################################################
$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

cat $PWD/$MMLSCRIPT 
#rm $PWD/$MMLSCRIPT
exit

#############################
#rm $PWD/$MMLSCRIPT
. $DELETE_ALL_MO_SCRIPTS
#rm $DELETE_ALL_MO_SCRIPTS

echo "#//...$0:$SIMNAME script ended running at "`date`
echo "#//"


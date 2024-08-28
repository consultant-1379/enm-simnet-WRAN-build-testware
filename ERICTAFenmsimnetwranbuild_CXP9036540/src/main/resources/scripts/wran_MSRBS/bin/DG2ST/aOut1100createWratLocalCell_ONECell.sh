#!/bin/sh

# Created by : XRANDYA 
##
### VERSION HISTORY
##################################################
# Ver1        : Created for O16B 
# Purpose     : DG2 data population 
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

CREATE & SETS: WratLocalCell and Iub 

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

NUMOFDG2=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`
COUNT=1
MOFILECOUNT=1

CELLID=`expr $((((( $RNCIDCOUNT - 1 ) * $NUMOFDG2) + $COUNT )))`
#echo "CELLID : $CELLID"

  cat >> $MMLSCRIPT << MMLSCT
  .open $SIMNAME
MMLSCT
while [ "$COUNT" -le "$NUMOFDG2" ]
do
  
  if [ "$COUNT" -le 9 ]
   then
    DG2NAME=MSRBS-V20
   else
    DG2NAME=MSRBS-V2
  fi
  
  MOFILEEXTENSION="__"$MOFILECOUNT".mo"

####################################################################################################

  cat >> $MMLSCRIPT << MMLSCT
  .select $RNCNAME$DG2NAME$COUNT
  .start
useattributecharacteristics:switch="off";
createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT",type="NodeBFunction",name="1";
createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1",type="Iub",name="1";
createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1,Iub=1",type="IubDataStreams",name="1";
createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1,Iub=1",type="NbapCommon",name="1";
createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1,Iub=1",type="NbapDedicated",name="1";

createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1",type="NodeBLocalCellGroup",name="1";
createmo:parentid="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1,NodeBLocalCellGroup=1",type="NodeBLocalCell",name="1";

setmoattribute:mo="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1,Iub=1",attributes="rbsId=$COUNT";
setmoattribute:mo="ManagedElement=$RNCNAME$DG2NAME$COUNT,NodeBFunction=1,NodeBLocalCellGroup=1,NodeBLocalCell=1",attributes="localCellId=$CELLID";
setmoattribute:mo="ManagedElement=$RNCNAME$DG2NAME$COUNT,SystemFunctions=1,BrM=1,BrmBackupManager=1",attributes="backupType (string)=Type|| backupDomain (string)=Domain";
MMLSCT

echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts
  
  MOFILECOUNT=`expr $MOFILECOUNT + 1`
  COUNT=`expr $COUNT + 1`
  CELLID=`expr $CELLID + 1`
	
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


#!/bin/sh


if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>
Example: $0  RNCM125-ST-RNC01 R7-ST-11.0.6-N.env 1
HELP
exit 1
fi
################################
# MAIN
################################
SIMNAME=$1
ENV=$2
RNC=$3

. ../../dat/$ENV
. ../utilityFunctions.sh


if [ "$3" -le 9 ]
then
  RNCNAME=RNC0$RNC
  RNCCOUNT="0"$RNC
else
  RNCNAME=RNC$RNC
  RNCCOUNT=$RNC
fi

if [ "$EXTGSMCELLS_RELATION" == "YES" ]
then

echo "//...$0:$RNCNAME script started running at "`date`
echo "//"

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0${NOW}:$RNCNAME".mo"
MMLSCRIPT=$0${NOW}:$RNCNAME".mml"

#########################################
# 
# Make MO Script
#
#########################################

# Total Numof UtranCell for Each RNC
TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

# CellId for Each Cell within Utran Network
CIDSTART=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`
CID=$CIDSTART

######################################################################################################
# START OF EXTGSMCELL RELATIONS FOR IRATHOM
######################################################################################################

if [ "$RNCCOUNT" -le 41 ]
then

# Total Numof ExtGsmCell for Each RNC
TARGET_TOTALCELLS=300

# NumOf UtranCell will have relation against ExtGsmCell
END_COUNT=`expr $TOTALCELLS - 1`

 # IRATHOM cell range ends at 12039
 if [ "$RNCCOUNT" -eq "41" ] 
 then
    END_COUNT=15
 fi

# NumOf ExtGsmCell Relation per each UtranCell
GSMRELATIONNUM=13

COUNT=1
CELLCOUNT=1
RBSCOUNT=1
VAR=1

while [ "$COUNT" -le "$END_COUNT" ]
do

  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY` # NUMOFCELL for each RBS
  CELLNUM=$NUMOFCELL
  CELLSTOP=`expr $NUMOFCELL + 1`

  if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
  then
    CELLCOUNT=1
    RBSCOUNT=`expr $RBSCOUNT + 1`
  fi

  CREATE_RELATION=YES
  UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`

  ######################################################
  # (1)  Create GsmRelation to ExternalGsmCells 
  ######################################################

  if [ "$CREATE_RELATION" == "YES" ]
  then

      ######################################################################
      #
      # Visit each TargetCell according to necessary number of relations for the current Cell
      #  NUMOFELMOF_CELLGROUP defines number of relations for each current cell
      #
      #######################################################################
      NUMOFELMOF_CELLGROUP=$GSMRELATIONNUM
      SWITCH_TO_NEW_EXTGSMCELL_ID_FOR_NEW_SIM=4993
      
      CELLGROUP=`getGroup $COUNT $NUMOFELMOF_CELLGROUP`

      START_EXTGSMIDCOUNT=`expr $NUMOFELMOF_CELLGROUP \* $CELLGROUP - \( $NUMOFELMOF_CELLGROUP - 1 \) + \( $RNCCOUNT - 1 \) \* $TARGET_TOTALCELLS`
      STOP_EXTGSMIDCOUNT=`expr $START_EXTGSMIDCOUNT + $NUMOFELMOF_CELLGROUP - 1`
      EXTGSMIDCOUNT=$START_EXTGSMIDCOUNT
      START=1
      STOP=$NUMOFELMOF_CELLGROUP

      TARGETCELLCOUNT=$EXTGSMIDCOUNT


      LOC_COUNT=1
      while [ "$LOC_COUNT" -le "$STOP" ]
      do
         UCELLREF='ManagedElement=1,RncFunction=1,ExternalGsmNetwork='$GSMMNC',ExternalGsmCell='$CID

         echo 'DELETE' >> $MOSCRIPT
         echo '(' >> $MOSCRIPT
         echo '  mo "ManagedElement=1,RncFunction=1,UtranCell='$UTRANCELLID',GsmRelation='$LOC_COUNT'"' >> $MOSCRIPT
         echo ')' >> $MOSCRIPT

         VAR=`expr $VAR + 1`
	 LOC_COUNT=`expr $LOC_COUNT + 1`
         TARGETCELLCOUNT=`expr $TARGETCELLCOUNT + 1`
      done


  else
    echo "// DO NOT CREATE ANY GSM-RELATION FOR THIS CELL: "$UTRANCELLID
  fi

  CID=`expr $CID + 1`
  CELLCOUNT=`expr $CELLCOUNT + 1`
  COUNT=`expr $COUNT + 1`
done
fi
######################################################################################################
# END OF EXTGSMCELL RELATIONS FOR IRATHOM
######################################################################################################
######################################################################################################
# START OF EXTGSMCELL RELATIONS FOR OTHER NETWORKS GSMNETWOK: 5, 6, 7
######################################################################################################
######################################################################################################
# END OF EXTGSMCELL RELATIONS FOR OTHER NETWORKS GSMNETWOK: 5, 6, 7
######################################################################################################

echo "//...$0:$RNCNAME MAKING MO SCRIPT ended at "`date` 


fi # END FOR EXTGSMCELLS_RELATION IF/ELSE

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
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT

/netsim/inst/netsim_pipe < $MMLSCRIPT


echo "...$0:RNCNAME script ended at "`date`
echo ""


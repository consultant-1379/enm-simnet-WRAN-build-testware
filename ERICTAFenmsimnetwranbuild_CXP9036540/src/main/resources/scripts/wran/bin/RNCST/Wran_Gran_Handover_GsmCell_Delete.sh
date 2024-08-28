#!/bin/sh


if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################
Usage  : $0 <sim name> <env file> <rnc num>
Example: $0  RNCM115-ST-RNC01 R7-ST-11.0.6-N.env 1
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

FILE=$INPUTFILENAME
FILEDIR=$HOME/simnet/wran//bin/jar

if [ "$3" -le 9 ]
then
  RNCNAME="RNC0"$RNC
  RNCCOUNT="0"$RNC
else
  RNCNAME="RNC"$RNC
  RNCCOUNT=$RNC
fi

echo "//...$0:$RNCNAME script started running at "`date`
echo "//"

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

# *** Note ***
# Assuming ExternalGsmCell input file exist
if [ ! -f "$FILEDIR/$FILE" ]
then
  echo "//File: "$FILEDIR/$FILE" does not exist"
  echo "//Check the file and run again"
  exit
fi

MOSCRIPT=$0${NOW}:$RNCNAME".mo"
MMLSCRIPT=$0${NOW}:$RNCNAME".mml"


#################################################################
###ExternalGsmCell Deletion
###########################
Num Of Cells
###########################
TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
START_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`
COUNT=`expr $START_CUMTOTALCELLS + $TOTALCELLS`
CIDSTART=$START_CUMTOTALCELLS
EXTGSMNETWORK=$GSMMNC
###########################

EXTGSMCELL_ID=$COUNT

while [ "$CIDSTART" -le "$COUNT" ]
do

echo 'DELETE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  mo "ManagedElement=1,RncFunction=1,ExternalGsmNetwork='$EXTGSMNETWORK',ExternalGsmCell='$CIDSTART'"' >> $MOSCRIPT
  echo ')' >> $MOSCRIPT
 CIDSTART=`expr $CIDSTART + 1`
done

################################################################
echo "//...$0:$RNCNAME MAKING MO SCRIPT ended running at "

echo ""
echo "MAKING MML SCRIPT"
echo ""

echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT

 /netsim/inst/netsim_pipe < $MMLSCRIPT

#rm $PWD/$MOSCRIPT
#rm $PWD/$MMLSCRIPT



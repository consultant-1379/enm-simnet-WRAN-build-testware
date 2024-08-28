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
FILEDIR=$HOME/simnet/wran/bin/jar

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

#######################################################
######ExternalGsmNetworks Creation START
#######################################################

echo "//"$RNCNAME" has the following ExternalGsmNetworks"

mnc=$GSMMNC; MCC=$GSMMCC; MNCLENGTH=$GSMMNCLENGTH 

    echo "// :: ExternalGsmNetwork="$mnc" ; mcc="$MCC", mnc="$mnc", mncLength="$MNCLENGTH

    echo 'CREATE' >> $MOSCRIPT
    echo '(' >> $MOSCRIPT
    echo '  parent "ManagedElement=1,RncFunction=1"' >> $MOSCRIPT
    echo ' identity '$GSMMNC >> $MOSCRIPT
    echo ' moType ExternalGsmNetwork' >> $MOSCRIPT
    echo ' exception none' >> $MOSCRIPT
    echo ' nrOfAttributes 3' >> $MOSCRIPT
    echo '   mcc Integer '$MCC >> $MOSCRIPT
    echo '   mnc Integer '$mnc >> $MOSCRIPT
    echo '   mncLength Integer '$MNCLENGTH >> $MOSCRIPT
    echo ')' >> $MOSCRIPT

    COUNT=`expr $COUNT + 1`
###################################################
####ExternalGsmNetworks Creation END
##################################################

##################################################
###ExternalGsmCell Creation START
##################################################
TOTALCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
START_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`
COUNT=`expr $START_CUMTOTALCELLS + $TOTALCELLS`
CIDSTART=$START_CUMTOTALCELLS
EXTGSMNETWORK=$GSMMNC

while [ "$CIDSTART" -le "$COUNT" ]
do

NCC=3
C_SYS_TYPE=2
EXTGSMCELL_ID=$COUNT

LINE=`grep "CI=${CIDSTART};" ${FILEDIR}/$FILE`
CELL_NAME=`echo $LINE| awk -F";" '{print $1}' |  awk -F"=" '{print $2}'`
BCC=`echo $LINE | awk -F";" '{print $8}' |  awk -F"=" '{print $2}'`
BCCHNO=`echo $LINE | awk -F";" '{print $9}' |  awk -F"=" '{print $2}'`
LAC=`echo $LINE | awk -F";" '{print $5}' |  awk -F"=" '{print $2}'`
CID=`echo $LINE | awk -F";" '{print $6}' |  awk -F"=" '{print $2}'`


  echo 'CREATE' >> $MOSCRIPT
  echo '(' >> $MOSCRIPT
  echo '  parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork='$EXTGSMNETWORK'"' >> $MOSCRIPT
  echo ' identity '$CID >> $MOSCRIPT
  echo ' moType ExternalGsmCell' >> $MOSCRIPT
  echo ' exception none' >> $MOSCRIPT
  echo ' nrOfAttributes 3' >> $MOSCRIPT
  echo ' lac Integer '$LAC >> $MOSCRIPT
  echo ' ncc Integer '$NCC >> $MOSCRIPT
  echo ' bcc Integer '$BCC >> $MOSCRIPT
  echo ' bcchFrequency Integer '$BCCHNO >> $MOSCRIPT
  echo ' bandIndicator Integer '$C_SYS_TYPE >> $MOSCRIPT
  echo ' ExternalGsmCellId String "Irathom '$CELL_NAME'"' >> $MOSCRIPT
  echo ' userLabel String "Irathom '$CELL_NAME'"' >> $MOSCRIPT
  echo ' cellIdentity Integer '$CID >> $MOSCRIPT
  echo ')' >> $MOSCRIPT
 CIDSTART=`expr $CIDSTART + 1`
done
################################################################
#####ExternalGsmCell Creation END
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



#!/bin/sh

# Created by  : CHINMAYA
### VERSION HISTORY
##################################################
# Ver1        : Moddified for WRAN TERE 14B
# Purpose     :
# Description :
# Date        : 29 01 2014
# Who         : EAGACHI
##################################################

if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCL130-ST-RNC01 R7-ST-G-N.env 1

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
source $PWD/../../dat/$ENV
source $PWD/../utilityFunctions.sh

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

#echo "//...$0:$SIMNAME script started running at "`date`
#echo "//"


PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:${NOW}:$SIMNAME
MMLSCRIPT=$0:${NOW}:$SIMNAME".mml"

SCRIPTNAME=`basename "$0"`
DELETE_ALL_MO_SCRIPTS="DELETE_ALL_MO_SCRIPTS_${SIMNAME}_${SCRIPTNAME}"

if [ -f $PWD/$MOSCRIPT ]
then
  rm -r  $PWD/$MOSCRIPT
  echo "old "$PWD/$MOSCRIPT" removed"
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


#    echo "************************************"
#    echo "* RNCCOUNT="$RNCCOUNT
#    echo "************************************"

NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY`

COUNT=1
MOFILECOUNT=1

while [ "$COUNT" -le "$NUMOFRBS" ]
do

  if [ "$COUNT" -le 9 ]
   then
    RBSNAME=RBS0
   else
    RBSNAME=RBS
  fi

  MOFILEEXTENSION="__"$MOFILECOUNT".mo"  

 NODENAME=$RNCNAME$RBSNAME$COUNT.mo 

 if [ -f  $JARPATH/$RNCNAME/$NODENAME ];
	then echo "File exist"
	cat $JARPATH/$RNCNAME/$NODENAME > $MOSCRIPT$MOFILEEXTENSION
 else
	echo "File not exist"
	java -jar -Xss50m $JARPATH/wran.jar $RNCIDCOUNT $RNCIDCOUNT 
 fi	

 # echo ""
 # echo "MAKING MML SCRIPT"

  #########################################
  #
  # Make MML Script
  #
  #########################################

  cat >> $MMLSCRIPT << MMLSCT

  .open $SIMNAME
  .select $RNCNAME$RBSNAME$COUNT
  .start
  useattributecharacteristics:switch="off";
  kertayle:file="$PWD/$MOSCRIPT$MOFILEEXTENSION";

MMLSCT


  echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts

  COUNT=`expr $COUNT + 1`
  
  MOFILECOUNT=`expr $MOFILECOUNT + 1`
done

################################################
# $NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT

cat $PWD/$MMLSCRIPT
#rm $PWD/$MMLSCRIPT
exit

#############################


#rm $PWD/$MMLSCRIPT
#. $DELETE_ALL_MO_SCRIPTS
#rm $DELETE_ALL_MO_SCRIPTS

#############################

echo "...script ended at "`date`
echo ""


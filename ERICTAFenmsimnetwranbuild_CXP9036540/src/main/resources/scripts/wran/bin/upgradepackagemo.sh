#!/bin/sh

if [ "$#" -ne 1 ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> 

Example: $0 RNCM180-ST-RNC01 

HELP

exit
fi


SIM=$1




MOSCRIPT=$0:${NOW}:$RNCNAME".mo"
MMLSCRIPT=$0:${NOW}:$RNCNAME".mml"


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


 
# Make MML Script
#
#########################################


echo "//..$0:$SIM $NESNAME_REGEXPR started at `date` "
echo "//"

echo '.open '$SIM >> $MMLSCRIPT
echo '.select network' >> $MMLSCRIPT
echo '.start' >> $MMLSCRIPT
echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,SwManagement=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType UpgradePackage' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 1' >> $MOSCRIPT
echo '   userLabel String UpgradePackage-1' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT

#########################################
# 
# Run MML Script
#
#########################################


/netsim/inst/netsim_pipe < $MMLSCRIPT

rm $PWD/$MMLSCRIPT
rm $PWD/$MOSCRIPT

echo "//..$0:$SIM  ended at `date` "

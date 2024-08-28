#!/bin/sh
SIM=$1
NOW=`date +"%Y_%m_%d_%T:%N"`

MMLSCRIPT=$0:${NOW}:$SIM".mml"


PWD=`pwd`

if [ -f $PWD/$MMLSCRIPT ]
then
rm -r  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi

echo '.open '$SIM >> $MMLSCRIPT
echo '.select network' >> $MMLSCRIPT
echo '.saveandcompress force nopmdata' >> $MMLSCRIPT
/netsim/inst/netsim_shell < $MMLSCRIPT

./Implement_Scanner.sh $SIM >> scannerlog.txt
rm $PWD/$MMLSCRIPT
echo " script ended"



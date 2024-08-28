#!/bin/sh

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV71569-FT-RNC01"
 echo
 exit 1
fi

SIM=$1
MMLSCRIPT=$0"_"$SIM".mml"
echo '.open '$SIM >> $MMLSCRIPT
echo '.select network' >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT


echo 'setswinstallvariables:fileDl=sftp;' >> $MMLSCRIPT
echo 'setswinstallvariables:bandwidth=3072;' >> $MMLSCRIPT

~/inst/netsim_shell < $MMLSCRIPT

rm -rf $MMLSCRIPT

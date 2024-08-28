#!/bin/sh
# Created by  : zchianu
# Created in  : 16 04 2021
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : Updating ControlPlaneTransport attribute in Iublink MO for RNCnode
# Description :
# Date        : 16 04 2021
# Who         : zchianu
###########################################
SIM=$1
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi


#############################################################################
#Fetching the RBS count and RNC number
#############################################################################

RbsStr=$(echo $SIM | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM
RBSMIM=$(echo $SIM | awk -F"RBS" '{print $2}' | awk -F"x" '{print $1}')"-lim"
PWD=`pwd`

count=1
echo "RBSNUM is $RBSNUM"
echo "$RNCNAME"
while [[ "$count" -le "$RBSNUM" ]]
do
MOSCRIPT=$RNCNAME"_ControlPlane.mo"
MMLSCRIPT=$RNCNAME"_ControlPlane.mml"
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ManagedElement=1,RncFunction=1,IubLink=$count"
    // moid = 498
    exception none
    nrOfAttributes 1
    "controlPlaneTransportOption" Struct
        nrOfElements 2
        "atm" Integer 0
        "ipv4" Integer 1
)

MOSC
count=`expr $count + 1`
done
echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
echo " #######Execution of script ended####### "
echo "#####################################################################"

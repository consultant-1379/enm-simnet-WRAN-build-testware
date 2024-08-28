#!/bin/sh

# Created by  : Harish Dunga
# Created in  : 02 05 2017
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To add product data For Rnc Node
# Description :
# Date        : 02 05 2017
# Who         : Harish Dunga
###########################################
SIM=$1
ENV=$2
RNCPRODUCTDATA=$3
#RNCNUM=$3

echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 3 ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <RNC ProductData>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x10-RNC01 CONFIG.env CXP9021776/5:R2AA13"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

RncStr=(${SIM//RNC/ }) 
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

#############################################################################
#Fetching the Product data of RNC node
#############################################################################

RNCMIM=$(echo $SIM | awk -F"RNC" '{print $2}' | awk -F"x" '{print $1}')"-lim"

IFS=";"

for x in $RNCPRODUCTARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$RNCMIM" ]
then
RNCPRODNUMBER=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
RNCPRODVERSION=$(echo $x | awk -F":" '{print $2}')
break

fi

done
RNCPRODNUMBER=$(echo $RNCPRODUCTDATA  | awk -F ":" '{print $1}')
RNCPRODVERSION=$(echo $RNCPRODUCTDATA | awk -F ":" '{print $2}')

if [ "$MIMVERSION" == "" ]
then
echo "No Mim found. Cannot load the product data"
echo "-------------------------------------------------------------------"
echo "# $0 script ended ERRONEOUSLY !!!!"
echo "###################################################################"
exit 1
fi

echo "Mim version of $RNCNAME node : $MIMVERSION"
echo  "RNC product number : $RNCPRODNUMBER"
echo "RNC product version : $RNCPRODVERSION"


#########################################
#
# Make M0 Script
#
#########################################

NOW=`date +"%Y_%m_%d_%T:%N"`
MOSCRIPT=$RNCNAME"_productData.mo"

if [ -s $MOSCRIPT ]
then
echo "Removing old moscripts"
rm -rf $MOSCRIPT
fi

cat > $MOSCRIPT <<EOF
SET
(
    mo "ManagedElement=1,SwManagement=1,UpgradePackage=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 5
        "productNumber" String "$RNCPRODNUMBER"
        "productRevision" String "$RNCPRODVERSION"
        "productName" String "SwVersion"
        "productionDate" String "$NOW"
        "productInfo" String ""	
)
EOF


#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""

MMLSCRIPT=$RNCNAME"_productData.mml"

if [ -s $MMLSCRIPT ]
then
echo "Removing Old mmlscripts"
rm -rf $MMLSCRIPT
fi

echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD/$MOSCRIPT'";' >> $MMLSCRIPT

~/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT

echo "-------------------------------------------------------------------"
echo "# $0 script Ended Execution"
echo "###################################################################"


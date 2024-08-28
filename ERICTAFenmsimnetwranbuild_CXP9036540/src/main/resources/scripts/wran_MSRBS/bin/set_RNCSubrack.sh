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
#RNCNUM=$3

echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <env file>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x10-RNC01 CONFIG.env"
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

#RNCMIM=$(echo $SIM | awk -F"RNC" '{print $2}' | awk -F"x" '{print $1}')"-lim"

#IFS=";"

#for x in $RNCPRODUCTARRAY
#do

#MIMVERSION=$(echo $x | awk -F"," '{print $1}')

#if [ "$MIMVERSION" == "$RNCMIM" ]
#then
#RNCPRODNUMBER=$(echo $x | awk -F"," '{print $2}' | awk -F":" '{print $1}')
#RNCPRODVERSION=$(echo $x | awk -F":" '{print $2}')
#break

#fi

#done

#if [ "$MIMVERSION" == "" ]
#then
#echo "No Mim found. Cannot load the product data"
#echo "-------------------------------------------------------------------"
#echo "# $0 script ended ERRONEOUSLY !!!!"
#echo "###################################################################"
#exit 1
#fi

#echo "Mim version of $RNCNAME node : $MIMVERSION"
#echo  "RNC product number : $RNCPRODNUMBER"
#echo "RNC product version : $RNCPRODVERSION"

#subrack product data
subrackProductName='RNC14B'
subrackProductNumber="E.1.120"
subrackProductRevision="CXP21"
subrackSerialNumber="lienb0635"
subrackProductionDate="5"

# Slot productData fields
slotProdName="RNC14B"
slotProdNumber="ENM14B"
slotSerialNumber="3oQ"
slotProductionDate="''"

declare -a SlotProductRevisions=("CXP123" "CXP124" "3CXP125" "4CXP1222" "5CXPt24" "6CXPe24" "7CXP324" "8CXP124y" "9CXP334" "10CX8P124" "11CX9P124" "12CXP1i024" "13CXP1io924" "14CXPi87124" "15CXPi009124" "16CXPi78124" "17CXP13324" "18CXP12w14" "19CXP12we4" "20CXP111124" "21CXP122224" "22CXP133324" "23CXP124321" "24CXP124123" "25CXP12445" "26CXP124424" "27CXP124553" "28CXP124665")
#########################################
#
# Make M0 Script
#
#########################################

NOW=`date +"%Y_%m_%d_%T:%N"`
MOSCRIPT=$RNCNAME"_SetSubrack.mo"

if [ -s $MOSCRIPT ]
then
echo "Removing old moscripts"
rm -rf $MOSCRIPT
fi
SubrackMo=$RNCNAME"_SetSubrack.mo"
cat > $SubrackMo <<EOF

SET
 (
       mo "ManagedElement=1,Equipment=1,Subrack=MS"
       identity "MS"
       exception none
       nrOfAttributes 4
       "operationalProductData" Struct
       nrOfElements 5
       "productName" String "$subrackProductName"
       "productNumber" String $subrackProductNumber
       "productRevision" String $subrackProductRevision
       "serialNumber" String $subrackSerialNumber
       "productionDate" String $subrackProductionDate
       "administrativeProductData" Struct
       nrOfElements 5
       "productNumber" String $RNCNAME
       "productRevision" String $RNCNAME
       "productName" String $RNCNAME
       "productInfo" String $RNCNAME
       "productionDate" String $RNCNAME
       "userLabel" String "$subrackProductName"
       "subrackPosition" String "$subrackPosition"
 )
EOF

index=0

while [ "$index" -lt "${#SlotProductRevisions[@]}" ]
do
slotProdRevision=${SlotProductRevisions[$index]}
SlotIndex=`expr $index + 1`
cat >> $SubrackMo << MOSC
SET
	(
        mo "ManagedElement=1,Equipment=1,Subrack=MS,Slot=$SlotIndex"
        identity "$SlotIndex"
        exception none
        nrOfAttributes 1
        "productData" Struct
	nrOfElements 5
	"productName" String $slotProdName
	"productNumber" String $slotProdNumber
	"productRevision" String $slotProdRevision
	"serialNumber" String $slotSerialNumber
	"productionDate" String $slotProductionDate
	)

MOSC
index=`expr $index + 1`
done

 



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


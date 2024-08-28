#!/bin/sh
SIM=$1
#RNCNUM=$2

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x40-RNC01"
 echo
 exit
fi

RbsStr=$(echo $SIM | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM

subrackProductName='RBS14B'
subrackProductNumber="E.1.120"
subrackProductRevision="CXP21"
subrackSerialNumber="lienb0635"
subrackProductionDate="5"

# Slot productData fields
slotProdName="RBS14B"
slotProdNumber="ENM14B"
slotSerialNumber="3oQ"
slotProductionDate="''"

declare -a SlotProductRevisions=("CXP123" "CXP124" "3CXP125" "4CXP1222" "5CXPt24" "6CXPe24" "7CXP324" "8CXP124y" "9CXP334" "10CX8P124" "11CX9P124" "12CXP1i024" "13CXP1io924" "14CXPi87124" "15CXPi009124" "16CXPi78124" "17CXP13324" "18CXP12w14" "19CXP12we4" "20CXP111124" "21CXP122224" "22CXP133324" "23CXP124321" "24CXP124123" "25CXP12445" "26CXP124424" "27CXP124553" "28CXP124665")

COUNT=1
while [ $COUNT -le $RBSNUM  ]
do
if [ $COUNT -le 9 ]
then
NODE=$RNCNAME"RBS0"$COUNT".mo"
NODENAME=$RNCNAME"RBS0"$COUNT
else
NODE=$RNCNAME"RBS"$COUNT".mo"
NODENAME=$RNCNAME"RBS"$COUNT
fi

cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/jar/$RNCNAME
SubrackCount=`find -name $NODE |xargs grep -i "motype Subrack" | wc | awk -F" " '{print $1}'`
cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin
subrackRef=1
SubrackMo=$NODENAME"_SetSubrack.mo"

while [ "$subrackRef" -le "$SubrackCount" ]
do
subrackPosition=$subrackRef"B"
    if [  "$subrackRef"  -eq "8" ]
then
 $subrackPosition=""
cat >> $SubrackMo << MOSC
 SET
 (
       mo "ManagedElement=1,Equipment=1,Subrack=$subrackRef"
       identity "$subrackRef"
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
       "productNumber" String $NODENAME
       "productRevision" String $NODENAME
       "productName" String $NODENAME
       "productInfo" String $NODENAME
       "productionDate" String $NODENAME
       "userLabel" String "$subrackProductName"
       "subrackPosition" String "$subrackPosition"
 )
MOSC
 elif [  "$subrackRef"  -eq "9" ]
 then
 cat >> $SubrackMo << MOSC
  SET
 (
      mo "ManagedElement=1,Equipment=1,Subrack=$subrackRef"
      identity "$subrackRef"
      exception none
      nrOfAttributes 4
      "operationalProductData" Struct
      nrOfElements 5
     "productName" String ""
     "productNumber" String $subrackProductNumber
     "productRevision" String $subrackProductRevision
     "serialNumber" String $subrackSerialNumber
     "productionDate" String $subrackProductionDate
     "administrativeProductData" Struct
     nrOfElements 5
     "productNumber" String $NODENAME
     "productRevision" String $NODENAME
     "productName" String ""
     "productInfo" String $NODENAME
     "productionDate" String $NODENAME
     "userLabel" String "$subrackProductName"
     "subrackPosition" String "$subrackPosition"
 )
MOSC
 else
cat >> $SubrackMo << MOSC
SET
(
	mo "ManagedElement=1,Equipment=1,Subrack=$subrackRef"  
        identity "$subrackRef"
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
        "productNumber" String $NODENAME
        "productRevision" String $NODENAME
        "productName" String $NODENAME
        "productInfo" String $NODENAME
        "productionDate" String $NODENAME
        "userLabel" String "$subrackProductName"
        "subrackPosition" String "$subrackPosition"
)
MOSC
fi
index=0

while [ "$index" -lt "${#SlotProductRevisions[@]}" ]
do
slotProdRevision=${SlotProductRevisions[$index]}
SlotIndex=`expr $index + 1`
cat >> $SubrackMo << MOSC
SET
	(
        mo "ManagedElement=1,Equipment=1,Subrack=$subrackRef,Slot=$SlotIndex"
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
SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=$SlotIndex,PlugInUnit=1"
    // moid = 259
    exception none
    nrOfAttributes 2
    "piuType" Ref "ManagedElement=1,SwManagement=1,PiuType=1"
        "unitType" String "DUW"
)

SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=CBU"
    // moid = 2436
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 5
        "productName" String "RBS14B"
        "productNumber" String "ENM14B"
        "productRevision" String "27CXP124553"
        "serialNumber" String "3oQ"
        "productionDate" String ""

)

SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=CBU,PlugInUnit=1"
    // moid = 259
    exception none
    nrOfAttributes 2
    "piuType" Ref "ManagedElement=1,SwManagement=1,PiuType=1"
        "unitType" String "DUW"
)


SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX"
    // moid = 2441
    exception none
    nrOfAttributes 1
    "productData" Struct
        nrOfElements 5
        "productName" String "RBS14B"
        "productNumber" String "ENM14B"
        "productRevision" String "28CXP124665"
        "serialNumber" String "3oQ"
        "productionDate" String ""

)
SET
(
    mo "ManagedElement=1,Equipment=1,Subrack=1,Slot=ET-MFX,PlugInUnit=1"
    // moid = 259
    exception none
    nrOfAttributes 2
    "piuType" Ref "ManagedElement=1,SwManagement=1,PiuType=1"
        "unitType" String "DUW"
)


MOSC

index=`expr $index + 1`
done

subrackRef=`expr $subrackRef + 1`
done

####################################################################################
MMLSCRIPT=$NODENAME"_SetSubrack.mml"
rm -rf $MMLSCRIPT
echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$SubrackMo'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
COUNT=`expr $COUNT + 1`
done

cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/
rm -rf *_SetSubrack.mo
rm -rf *_SetSubrack.mml

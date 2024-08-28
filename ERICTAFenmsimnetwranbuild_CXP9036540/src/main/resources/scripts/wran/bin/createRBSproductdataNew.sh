#!/bin/sh

SIM=$1
#ENV=$2
#RNCNUM=$3
#RBSNUM=$4

IFS=";"
NOW=`date +"%Y_%m_%d_%T:%N"`
RNCNAME="RNC01"



########################################
#Making MOSCRIPT
########################################
cat > $MOSCRIPT <<EOF
CREATE
(
    parent "ManagedElement=1,Equipment=1"
    identity "CABID_7"
    moType Cabinet
    exception none
    nrOfAttributes 11
    "productData" Struct
        nrOfElements 5
        "productionDate" String "$NOW"
        "productName" String ""
        "productNumber" String "CXP9023291"
        "productRevision" String "R13CE09"
        "serialNumber" String ""

    "climateSystem" Integer 0
    "reservedBy" Array Ref 0
    "smokeDetector" Boolean false
    "climateControlMode" Integer 0
    "climateRegulationSystem" Integer 0
)

SET
(
    mo "ManagedElement=1,SwManagement=1,UpgradePackage=1"
    exception none
    nrOfAttributes 1
    "administrativeData" Struct
        nrOfElements 5
        "productNumber" String "CXP9023291"
        "productRevision" String "R13CE09"
        "productName" String "SwVersion"
        "productionDate" String "$NOW"
        "productInfo" String ""	
)
EOF

#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""
MMLSCRIPT=$RNCNAME"RBS_productData.mml"


COUNT=1
while [ $COUNT -le 23  ]
do
echo '.open '$SIM >> $MMLSCRIPT
#echo "$RBSNUM"
if [ $COUNT -le 9 ]
then
echo '.select '$RNCNAME'RBS0'$COUNT >> $MMLSCRIPT
else
echo '.select '$RNCNAME'RBS'$COUNT >> $MMLSCRIPT
fi
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD/$MOSCRIPT'";' >> $MMLSCRIPT
COUNT=`expr $COUNT + 1`
done

#~/inst/netsim_shell < $MMLSCRIPT
#rm -rf $MOSCRIPT
#rm -rf $MMLSCRIPT

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"

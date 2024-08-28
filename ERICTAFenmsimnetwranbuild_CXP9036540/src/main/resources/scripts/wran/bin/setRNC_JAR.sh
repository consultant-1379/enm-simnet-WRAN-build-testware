#!/bin/sh

# Created by  : Harish Dunga
# Created in  : 02 05 2017
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To load RNC jar into the Rnc node
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

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <RNC product data>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RNC01 5K.env CXP9021776:R24BD11"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

RNCMIM=$(echo $SIM | awk -F"RNC" '{print $2}' | awk -F"x" '{print $1}')"-lim"
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM
#############################################################################
#Fetching the MIM version of RNC node
#############################################################################
IFS=";"

for x in $RNCMIMTYPEARRAY
do

MIMVERSION=$(echo $x | awk -F"," '{print $1}')

if [ "$MIMVERSION" == "$RNCMIM" ]
then
RNCMIMTYPE=$(echo $x | awk -F"," '{print $2}')

echo "RNC MIMTYPE :"$RNCMIMTYPE

break

fi

done

#############################################################
# Fetching product data for RNC to set jar

RNCPRODNUMBER=$(echo $RNCPRODUCTDATA  | awk -F ":" '{print $1}')
RNCPRODVERSION=$(echo $RNCPRODUCTDATA | awk -F ":" '{print $2}')

RNCJAR=${RNCPRODNUMBER}_${RNCPRODVERSION}.jar
echo "$RNCJAR"

################################################################################################
#Configuring the JAR path in the RNC
################################################################################################
NETSIMDBDIR=/netsim/netsim_dbdir/simdir/netsim/netsimdir
#JARFILE=RNCST/JAR/$RNCMIMTYPE/CXC1735921_R8CA04.jar
JARFILE=`ls RNCST/JAR/$RNCMIMTYPE/`
JARFile="RNCST/JAR/$RNCMIMTYPE/"$JARFILE
echo "$JARFILE"
if [ "$JARFILE" == ""  ]
then
echo "No Jar file found. Failed to set jar path for $SIM"
echo "-------------------------------------------------------------------"
echo "# $0 script ended ERRONEOUSLY !!!!"
echo "###################################################################"

exit 1
fi
################################################################################################
#Making MMLSCRIPT
################################################################################################
cp -r $JARFile $NETSIMDBDIR/$SIM/$RNCNAME/fs/c/java/
DUMPMMLSCRIPT=$RNCNAME"_JAR.mml"
if [ -s $DUMPMMLSCRIPT ]
then
echo "File is available"
rm -rf $DUMPMMLSCRIPT
fi
MODUMPFILE=$RNCNAME"_JAR.txt"
if [ -s $MODUMPFILE ]
then
echo "File is available"
rm -rf $MODUMPFILE
fi
cat > $DUMPMMLSCRIPT <<EOF
.open $SIM
.select $RNCNAME
.start
createmo:parentid="ManagedElement=1,SwManagement=1",type="LoadModule",name="RncLmPm";
setmoattribute:mo="ManagedElement=1,SwManagement=1,LoadModule=RncLmPm", attributes="loadModuleFilePath=/c/java/$RNCJAR";
setmoattribute:mo="ManagedElement=1,SwManagement=1,LoadModule=RncLmPm", attributes="productData=[,,RncLmPm,,]";
dumpmotree:moid="ManagedElement=1,SwManagement=1,LoadModule=RncLmPm",dotty;
dumpmotree:moid="ManagedElement=1,SwManagement=1,UpgradePackage=1",scope=1,printattrs;
EOF
~/inst/netsim_shell < $DUMPMMLSCRIPT | tee -a $MODUMPFILE

########Setting LoadModule Attributes##############################################

newloadAttribute=$(echo $(find -name $MODUMPFILE |xargs grep -i "{rank = same;") | awk -F"same " '{print $2}' | awk -F" " '{print $1}')
loadAttrList=$(echo $(find -name $MODUMPFILE |xargs grep -i "loadModuleList") | awk -F"=" '{print $2}')
loadattr=$(echo $loadAttrList | awk -F"," '{print $NF}')
if [[ "$loadattr" -eq "$newloadAttribute" ]]
then
LoadAttributes=$loadAttrList
echo "The Attribute already exists"
else
LoadAttributes=$loadAttrList','$newloadAttribute
fi

echo $result
SETLOADATTRIBUTEMML=$RNCNAME"_setLoadModule.mml"
if [ -s $SETLOADATTRIBUTEMML ]
then
echo "File is available"
rm -rf $SETLOADATTRIBUTEMML
fi
cat > $SETLOADATTRIBUTEMML << JAR
.open  $SIM
.select $RNCNAME
.start
setmoattribute:mo="ManagedElement=1,SwManagement=1,UpgradePackage=1", attributes="loadModuleList=[$LoadAttributes]";
JAR
~/inst/netsim_shell < $SETLOADATTRIBUTEMML
rm -rf $DUMPMMLSCRIPT
rm -rf $MODUMPFILE
rm -rf $SETLOADATTRIBUTEMML

echo "-------------------------------------------------------------------"
echo "# $0 script ended Execution"
echo "###################################################################"


#!/bin/sh
#######################################################################################
### Version4    : 21.08
### Revision    : CXP 903 6540-1-12
### Purpose     : changing java download link.
### Description : Changing java download link.
### JIRA        : No jira
### Date        : 16th April 2021
### Author      : zchianu
########################################################################################
#######################################################################################
### Version4    : 21.06
### Revision    : CXP 903 6540-1-7
### Purpose     : changing node template links.
### Description : Changing node Template links.
### JIRA        : NSS-31187
### Date        : 17th Feb 2021
### Author      : zchianu
########################################################################################
#######################################################################################
### Version4    : 20.11
### Revision    : CXP 903 6540-1-6
### Purpose     : To provide support for 2K and RV builds.
### Description : To provide support for 2K and RV builds.
### JIRA        : NSS-31187
### Date        : 27th Jun 2020
### Author      : zsujmad
########################################################################################
#######################################################################################
### Version3    : 20.05
### Revision    : CXP 903 6540-1-5
### Purpose     : Copying logs to simnetRevision folder in sim.
### Description : Copying logs to SimnetRevision folder in sim.
### JIRA        : NSS-29142
### Date        : 21st Feb 2020
### Author      : zyamkan
########################################################################################
###########################################
# Version2    : 20.02
# Revision    : CXP 903 6540-1-3
# Purpose     : clone the base node instead of creating
# Description : To avoid PM issues need to clone the base node
# JIRA        : NSS-26915
# Date        : 10th Dec 2019
# Author      : zyamkan
###########################################
###########################################
# VerSion1    : 1.1
# Revision    : CXP 903 6540-1-1
# Purpose     : Adding support for download node templates automatically
# Author      : zyamkan
###########################################
usage (){

echo "Usage  : $0 <SIM Name> <RNC productData> <RBS ProductData> <NW Type> <mixedmodereq>"

echo "Example: $0 RNCV15439x1-FT-RBSU41000x23-RNC01 CXP9021776/5:R2AA13 CXP9024418/12:R31A96 1.8K YES/NO"
}

########################################################################
#To check commandline arguments#
########################################################################
if [ $# -ne 5 ]
then
usage
exit 1
fi
#######################################################################
#Parameters
#######################################################################
SIMNAME=$1
RNCProductData=$2
RBSProductData=$3
NWType=$4
Mixedmode=$5
#######################################################################
#For networks 1.8k,2k and 15k SWITCHTORV=NO and for other than these SWITCHTORV=YES

if [[ $NWType == "1.8K" || $NWType == "2K" || $NWType == "15K" ]]
then
    switchRV='no'
else
    switchRV='yes'
fi

#######################################################################
setPath=`pwd`
RNCType=`echo "$SIMNAME" | awk -F 'x' '{print $1}' | awk -F 'RNC' '{print $2}'`-lim
RNCNum=`echo "$SIMNAME" | awk -F 'x' '{print $3}' | awk -F '-' '{print $2}' | awk -F 'RNC' '{print $2}'`

if [[ $SIMNAME == *"MSRBS"* ]]
then
    NodeType="MSRBS"
    NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-MSRBS-//g'`
elif [[ $SIMNAME == *"PRBS"* ]]
then
    NodeType="PRBS"
    NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-PRBS//g'`
else
    NodeType="RBS"
    NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-RBS//g'`-lim
fi

if [ $RNCNum -le 9 ]
then
    RNCNumber=`echo "$RNCNum" | awk -F '0' '{print $2}'`
else
    RNCNumber=$RNCNum
fi

#######################################################################

CPPURL="https://netsim.seli.wh.rnd.internal.ericsson.com/tssweb/simulations/cpp9.0/"
COMECIMURL="https://netsim.seli.wh.rnd.internal.ericsson.com/tssweb/simulations/com3.1/"

#######################################################################
######## This is for downloading RNC Base node template ###############
RNCBaseSimName=`curl -s "$CPPURL" | grep "RNC"${RNCType} | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'`

if [ -z "${RNCBaseSimName}" ]
then
    echo "RNC node template ${RNCType} doesn't exists"
else
	RNCTemplate=`echo ${CPPURL}${RNCBaseSimName}`
fi 
#######################################################################
###### This is for downloading RBS/PRBS/MSRBS Base node template ######


if [[ $SIMNAME == *"MSRBS"* ]]
then
    STR=${NodeType}".*V2.*"
    vals=(${NodeVersion//-/ })
    for i in "${vals[@]}"
    do
       STR=$STR$i"."
    done
    RBSBaseSimName=`curl -s "$COMECIMURL" | grep $STR | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'`
elif [[ $SIMNAME == *"PRBS"* ]]
then
    STR1=${NodeType}".*"
    vals=(${NodeVersion//-/ })
    for i in "${vals[@]}"
    do
       STR1=$STR1$i".*"
    done
    RBSBaseSimName=`curl -s "$COMECIMURL" | grep $STR1 | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'`
else
    RBSBaseSimName=`curl -s "$CPPURL" | grep "${NodeType}${NodeVersion}" | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'`
fi

if [ -z "${RBSBaseSimName}" ]
then
    echo "RBS node template ${NodeType} ${NodeVersion} doesn't exists"
else
	if [[ $SIMNAME == *"MSRBS"* ]]
	then
		NodeTemplate=`echo ${COMECIMURL}${RBSBaseSimName}`
	elif [[ $SIMNAME == *"PRBS"* ]]
	then
		NodeTemplate=`echo ${COMECIMURL}${RBSBaseSimName}`
	else
		NodeTemplate=`echo ${CPPURL}${RBSBaseSimName}`
	fi
fi

#######################################################################
##### Installing Java on a server######################################
echo "********************Java installation on a server***************"
rm -rf /netsim/java
mkdir -p /netsim/java
rpm -ev java-1_6_0-ibm-fonts-1.6.0_sr9.3-0.4.1
rpm -ev java-1_6_0-ibm-1.6.0_sr9.3-0.4.1
wget -O jdk-7u79-linux-x64.rpm https://arm1s11-eiffel004.eiffel.gic.ericsson.se:8443/nexus/content/repositories/nss/com/ericsson/nss/java/jdk-7u79-linux-x64/1.0.1/jdk-7u79-linux-x64-1.0.1.rpm
rpm -ivh jdk-7u79-linux-x64.rpm
java -version
echo "********************Completed Java installation***************"
#######################################################################

####Giving permissions to entire folder################################

chmod -R 777 /netsim/enm-simnet-WRAN-build-testware/
#######################################################################
echo "************Creating Ports on a server*****************"
#######################################################################

su netsim -c "./createPort.pl 192.168.100.5"

#######################################################################
#Check NodeType
#######################################################################
cd /netsim/netsimdir

RNCSupport=`echo $RNCTemplate | rev | cut -d "/" -f1 | rev`
RNCSupportWithoutzip=`echo $RNCSupport | cut -d '.' -f1`
NodeSupport=`echo $NodeTemplate | rev | cut -d "/" -f1 | rev`
NodeSupportWithoutzip=`echo $NodeSupport | cut -d '.' -f1`

rm -rf /netsim/netsimdir/${RNCSupport}
rm -rf /netsim/netsimdir/${NodeSupport}

echo "*********************************************"
echo `pwd`

wget $RNCTemplate
wget $NodeTemplate

echo "RNCTemplate is ${RNCSupportWithoutzip}"
echo "child node Template is ${NodeSupportWithoutzip}"

#########################################################################
#Check if node template exist
########################################################################


rm -rf /netsim/netsimdir/${RNCSupportWithoutzip}
rm -rf /netsim/netsimdir/${NodeSupportWithoutzip}

#########################################################################
#extract neType
#########################################################################


echo "***************************************Simulation Details*********************************"
echo "INFO:RNCType=$RNCType"
echo "INFO:RNCTemplate=$RNCTemplate"
echo "INFO:NodeType=$NodeType"
echo "INFO:NodeVersion=$NodeVersion"
echo "INFO:NodeTemplate=$NodeTemplate"
echo "INFO:NWType=$NWType"
echo "INFO:RNCNum=$RNCNum"
echo "INFO:Mixedmode=$Mixedmode"
echo "***************************************Simulation Details*********************************"

chmod 777 /netsim/netsimdir/$RNCSupport
chmod 777 /netsim/netsimdir/$NodeSupport

su netsim -c "echo '.uncompressandopen ${RNCSupport} ${RNCSupportWithoutzip}' | /netsim/inst/netsim_shell"
#RNCType=`echo -e ".open $RNCSupportWithoutzip \n.show simnes" | /netsim/inst/netsim_pipe |  awk '/OK/{f=0;};f{print $2 " " $3 " " $4;};/NE Name/{f=1;}'`

su netsim -c "echo '.uncompressandopen ${NodeSupport} ${NodeSupportWithoutzip}' | /netsim/inst/netsim_shell"
#neType=`echo -e ".open $NodeSupportWithoutzip \n.show simnes" | /netsim/inst/netsim_pipe |  awk '/OK/{f=0;};f{print $2 " " $3 " " $4;};/NE Name/{f=1;}'`

#######################################################################

if [[ $NodeType == "PICO" || $NodeType == "RBS" ]]
then
Path=$setPath/../
cd $Path/dat/
if [[ $NodeType == "PICO" && $NWType == "1.8K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 1.8K_PICO.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 1.8K_PICO.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 1.8K_PICO.env
sed -i '/PICOVERSIONARRAY/c\\PICOVERSIONARRAY="1:24,'$NodeVersion';"' 1.8K_PICO.env
ENV="1.8K_PICO.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 1.8kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NodeType == "PICO" && $NWType == "2K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 2K_PICO.env
sed -i '/RNCSTART/c\\RNCEND='$RNCNumber 2K_PICO.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:111,'$RNCType';"' 2K_PICO.env
sed -i '/PICOVERSIONARRAY/c\\PICOVERSIONARRAY="1:111,'$NodeVersion';"' 2K_PICO.env
ENV="2K_PICO.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 2kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NodeType == "PICO" && $NWType == "15K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 15K_PICO.env
sed -i '/RNCSTART/c\\RNCEND='$RNCNumber 15K_PICO.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 15K_PICO.env
sed -i '/PICOVERSIONARRAY/c\\PICOVERSIONARRAY="1:24,'$NodeVersion';"' 15K_PICO.env
ENV="15K_PICO.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 15kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NodeType == "RBS" && $NWType == "1.8K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 1.8K_RBS.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 1.8K_RBS.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:35,'$RNCType';"' 1.8K_RBS.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:35,'$NodeVersion';"' 1.8K_RBS.env
ENV="1.8K_RBS.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 1.8kconfig.xml config.xml
JAR="wran_DG1.jar"

elif [[ $NodeType == "RBS" && $NWType == "2K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 2K_RBS.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 2K_RBS.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:30,'$RNCType';"' 2K_RBS.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:30,'$NodeVersion';"' 2K_RBS.env
ENV="2K_RBS.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 2kconfig.xml config.xml
JAR="wran_DG1.jar"

elif [[ $NodeType == "RBS" && $NWType == "15K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 15K_RBS.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 15K_RBS.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 15K_RBS.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:24,'$NodeVersion';"' 15K_RBS.env
ENV="15K_RBS.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 15kconfig.xml config.xml
JAR="wran_DG1.jar"

elif [[ $NWType == "60K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 60K_RBS.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 60K_RBS.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 60K_RBS.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:24,'$NodeVersion';"' 60K_RBS.env
ENV="60K_RBS.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 60kconfig.xml config.xml
JAR="wran_DG1.jar"

elif [[ $NodeType == "RBS" && $NWType == "NRM3" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber NRM3.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber NRM3.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' NRM3.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:24,'$NodeVersion';"' NRM3.env
ENV="NRM3.env"
sudo dos2unix $ENV
cd ../bin/jar
cp NRM3config.xml config.xml
JAR="wran_DG1.jar"

elif [[ $NodeType == "RBS" && $NWType == "NRM4" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber NRM4.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber NRM4.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' NRM4.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:24,'$NodeVersion';"' NRM4.env
ENV="NRM4.env"
sudo dos2unix $ENV
cd ../bin/jar
cp NRM4config.xml config.xml
JAR="wran_DG1.jar"

elif [[ $NodeType == "RBS" && $NWType == "LARGERNC5K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber LargeRNC_5k.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber LargeRNC_5k.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' LargeRNC_5k.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:24,'$NodeVersion';"' LargeRNC_5k.env
ENV="LargeRNC_5k.env"
sudo dos2unix $ENV
cd ../bin/jar
cp LargeRNC_5kconfig.xml config.xml
JAR="wran_DG1.jar"

fi
elif [[ $NodeType == "MSRBS" ]]
then
Path=$setPath/../../wran_MSRBS/
cd $Path/dat
if [[ $NWType == "1.8K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 1.8K.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 1.8K.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:32,'$RNCType';"' 1.8K.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:32,'$NodeVersion';"' 1.8K.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode 1.8K.env
fi
ENV="1.8K.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 1.8kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NWType == "2K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 2K.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 2K.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:32,'$RNCType';"' 2K.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:32,'$NodeVersion';"' 2K.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode 2K.env
fi
ENV="2K.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 2kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NWType == "15K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 15K.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 15K.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 15K.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:24,'$NodeVersion';"' 15K.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode 15K.env
fi
ENV="15K.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 15kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NWType == "60K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 60KMSRBS.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 60KMSRBS.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 60KMSRBS.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:24,'$NodeVersion';"' 60KMSRBS.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode 60KMSRBS.env
fi
ENV="60KMSRBS.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 60kconfig.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NWType == "NRM3" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber NRM3_DG2.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber NRM3_DG2.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' NRM3_DG2.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:24,'$NodeVersion';"' NRM3_DG2.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode NRM3_DG2.env
fi
ENV="NRM3_DG2.env"
sudo dos2unix $ENV
cd ../bin/jar
cp NRM3_DG2config.xml config.xml
JAR="wran_DG2.jar"

elif [[ $NWType == "NRM4" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber NRM4_DG2.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber NRM4_DG2.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' NRM4_DG2.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:24,'$NodeVersion';"' NRM4_DG2.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode NRM4_DG2.env
fi
ENV="NRM4_DG2.env"
sudo dos2unix $ENV
cd ../bin/jar
cp NRM4_DG2config.xml config.xml
JAR="wran_DG2.jar"

fi
fi

######################################################################
#Deleting existing logs
######################################################################
cd $Path/log/
rm -rf *.log
cd $Path
#######################################################################
#Capture Logs
#######################################################################
DATE=`date +%F`
TIME=`date +%T`
CURR_DATE=`date +"%Y_%m_%d"`
LOGFILE=$Path/CreateJar.log
#######################################################################

cd $Path/bin/jar

echo "****Running jar to create a RNC folder****"
java -jar $JAR $RNCNumber $RNCNumber > $LOGFILE
chmod -R 777 .
cd $Path/bin
echo "******after jar creation *****"
################################################################################
#Running corresponding features scripts
#############################################################################

echo "******************creating a simulation ****************"
if [[ $NodeType == "MSRBS" ]]
then
sh $setPath/../../wran_MSRBS/bin/createWranSimsParallel.sh $ENV $SIMNAME $RNCProductData $RBSProductData ${NodeSupportWithoutzip}
else
sh $setPath/createWranSimsParallel.sh $ENV $SIMNAME $RNCProductData $RBSProductData
fi
echo "************** copying logs to a separate file *********** "

##################################################################################
#UPDATING IPs
##################################################################################
newPATH=`pwd`

cd $newPATH/../log
TOTAL_LOGFILE=`ls | grep $CURR_DATE`
RNCnum=`echo "$SIMNAME" | awk -F "-" '{print $NF}'`
mv $TOTAL_LOGFILE "$RNCnum"-Build.log
cp "$RNCnum"-Build.log /netsim/netsimdir/$SIMNAME/SimNetRevision/


echo "Running python script for Updating IP values on $SIMNAME : "

cd $newPATH/../../wran/bin/Updating_IPs
chmod 777 *

python new_updateip.py -deploymentType mediumDeployment -release 22.03 -simLTE NO_NW_AVAILABLE -simWRAN $SIMNAME -simCORE NO_NW_AVAILABLE -switchToRv $switchRV -IPV6Per yes -docker no

echo "Completed...IP Details are updated in the Simulation folder"

##################################################################################

#!/bin/sh

usage (){

echo "Usage  : $0 <SIM Name> <NW Type> <mixedmodereq>"

echo "Example: $0 RNCV15439x1-FT-RBSU41000x23-RNC01 1.8K YES/NO"
}

########################################################################
#To check commandline arguments#
########################################################################
if [ $# -ne 3 ]
then
usage
exit 1
fi
#######################################################################
#Parameters
#######################################################################
SIMNAME=$1
NWType=$2
Mixedmode=$3
#######################################################################

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

CPPURL="ftp://ftp.lmera.ericsson.se/project/netsim-ftp/simulations/NEtypes/cpp9.0/"
COMECIMURL="ftp://ftp.lmera.ericsson.se/project/netsim-ftp/simulations/NEtypes/com3.1/"

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
    RBSBaseSimName=`curl -s "$COMECIMURL" | grep ${NodeType}"-V2_"${NodeVersion} | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'`
elif [[ $SIMNAME == *"PRBS"* ]]
then
    RBSBaseSimName=`curl -s "$COMECIMURL" | grep "${NodeType}-${NodeVersion}" | awk '{print $NF}'`
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
####Giving permissions to entire folder################################

chmod -R 777 /netsim/enm-simnet-WRAN-build-testware/
#######################################################################
echo "************Creating Ports on a server*****************"
#######################################################################

#su netsim -c "./createPort.pl 192.168.100.5"

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
Path="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/"
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
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 1.8K_RBS.env
sed -i '/RBSVERSIONARRAY/c\\RBSVERSIONARRAY="1:24,'$NodeVersion';"' 1.8K_RBS.env
ENV="1.8K_RBS.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 1.8kconfig.xml config.xml
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

fi
elif [[ $NodeType == "MSRBS" ]]
then
Path="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/"
cd $Path/dat
if [[ $NWType == "1.8K" ]]
then
sed -i '/RNCSTART/c\\RNCSTART='$RNCNumber 1.8K.env
sed -i '/RNCEND/c\\RNCEND='$RNCNumber 1.8K.env
sed -i '/RNCVERSIONARRAY/c\\RNCVERSIONARRAY="1:24,'$RNCType';"' 1.8K.env
sed -i '/DG2VERSIONARRAY/c\\DG2VERSIONARRAY="1:24,'$NodeVersion';"' 1.8K.env
if [[ $Mixedmode == "YES" ]]
then
sed -i '/MIXEDREQ/c\\MIXEDREQ='$Mixedmode 1.8K.env
fi
ENV="1.8K.env"
sudo dos2unix $ENV
cd ../bin/jar
cp 1.8kconfig.xml config.xml
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
cp 60kKconfig.xml config.xml
JAR="wran_DG2.jar"

fi
fi

#Path=`pwd`
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
#cd $Path/bin

echo "******************creating a simulation ****************"
#./createWranSimsParallel.sh $ENV >/dev/null 2>&1
if [[ $NodeType == "MSRBS" ]]
then
sh /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/bin/createWranSimsParallel.sh $ENV $SIMNAME
else
sh /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/createWranSimsParallel.sh $ENV $SIMNAME
fi
echo "************** copying logs to a separate file *********** "
cd ../log
TOTAL_LOGFILE=`ls | grep $CURR_DATE`
cat $TOTAL_LOGFILE

##################################################################################

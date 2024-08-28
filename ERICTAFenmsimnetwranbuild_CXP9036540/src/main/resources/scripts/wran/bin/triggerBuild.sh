#!/bin/sh

#######################################################################################
### Version1    : 20.11
### Revision    : CXP 903 6540-1-1
### Purpose     : Build Job support for the codebase.
### Description : Job suport and Product Data fetching from ENV file.
### JIRA        : NSS-31187
### Date        : 27th June 2020
### Author      : zsujmad
########################################################################################

if [ "$#" -ne 3 ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <Sim Name> <Network Size> <Mixedmode YES/NO>

Example: $0 RNCV15439x1-FT-RBSU41000x23-RNC01 1.8K NO

HELP

exit 1
fi

SIMNAMES=$1
NETWORKSIZE=$2
MIXEDMODE=$3
PRODUCTDATAFILE="../dat/ProductData.env"

IFS=':' read -r -a SIMULATIONS <<< "$SIMNAMES"

for element in "${SIMULATIONS[@]}"
do
        echo "$element"
done

for SIMNAME in "${SIMULATIONS[@]}"
do
RNCType=`echo "$SIMNAME" | awk -F 'x' '{print $1}' | awk -F 'RNC' '{print $2}'`-lim
RNCNum=`echo "$SIMNAME" | awk -F 'x' '{print $3}' | awk -F '-' '{print $2}' | awk -F 'RNC' '{print $2}'`

if [[ $SIMNAME == *"MSRBS"* ]]
then
    NodeType="MSRBS"
    NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-MSRBS-//g'`
    FILESPATH="/var/nssSingleSimulationBuild/WRAN/$NodeType/" 
    CONFIGPATH="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/bin/jar/"
    ENVPATH="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/dat/"
elif [[ $SIMNAME == *"PRBS"* ]]
then
    NodeType="PRBS"
    NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-PRBS//g'`
    NodeVersion="PICO-"$NodeVersion
    FILESPATH="/var/nssSingleSimulationBuild/WRAN/$NodeType/"
    CONFIGPATH="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/jar/"
    ENVPATH="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/dat/"
else
    NodeType="RBS"
    NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-RBS//g'`-lim
    FILESPATH="/var/nssSingleSimulationBuild/WRAN/$NodeType/"
    CONFIGPATH="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/jar/"
    ENVPATH="/netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/dat/"
fi

cp /var/nssSingleSimulationBuild/*.env $ENVPATH
cp /var/nssSingleSimulationBuild/*.xml $CONFIGPATH

RNCPRODUCTDATA=`cat ${ENVPATH}/ProductData.env | grep $RNCType | cut -d '=' -f 2`
RBSPRODUCTDATA=`cat ${ENVPATH}/ProductData.env | grep $NodeVersion | cut -d '=' -f 2`

echo ">>>>>>>>>>>>>>> All Variables <<<<<<<<<<<<<<"
echo "RNC Version : $RNCType"
echo "RNC Product Data : $RNCPRODUCTDATA"
echo "RNC Number : $RNCNum"
echo "RBS Node Type : $NodeType"
echo "RBS Node Version : $NodeVersion"
echo "RBS Product Data : $RBSPRODUCTDATA"
echo "MixedMode Parameter : $MIXEDMODE"

sh startBuild.sh $SIMNAME $RNCPRODUCTDATA $RBSPRODUCTDATA $NETWORKSIZE $MIXEDMODE
done


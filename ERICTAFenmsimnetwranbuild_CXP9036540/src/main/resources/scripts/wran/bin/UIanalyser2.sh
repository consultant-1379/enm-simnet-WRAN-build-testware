#!/bin/sh
SIM=$1
ENV=$2
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <sim name> <envfile>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10 NRM3_60KG1.env"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh
#############################################################################
#Fetching the Product data of RBS node
#############################################################################

RbsStr=$(echo $SIM | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM
RBSMIM=$(echo $SIM | awk -F"RBS" '{print $2}' | awk -F"x" '{print $1}')"-lim"
PWD=`pwd`



NOW=`date +"%Y_%m_%d_%T:%N"`
pdkdate="$NOW"

COUNT=1

while [ "$COUNT" -le "$RBSNUM"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME'RBS0'$COUNT
else
NODENAME=$RNCNAME'RBS'$COUNT
fi
MOSCRIPT=$NODENAME"_RBSAnalyser.mo"
MMLSCRIPT=$NODENAME"_RBSAnalyser.mml"
cat >> $MOSCRIPT << MOSC
CREATE
(
    parent "ManagedElement=1,NodeBFunction=1"
    // moid = 2621
    identity "1"
    moType UlSpectrumAnalyzer
    exception none
    nrOfAttributes 5
    "ulSpectrumSamplingStatus" Integer 0
    "info" Integer 0
    "UlSpectrumAnalyzerId" String "1"
    "targetAiDevice" String ""
    "samplingType" Integer 0
)
CREATE
(
    parent "ManagedElement=1,IpSystem=1"
    // moid = 439
    identity "1"
    moType IpSec
    exception none
    nrOfAttributes 13
    "IpSecId" String "1"
    "trustedCertInstallErrorMsg" String ""
    "operationalState" Integer 0
    "certEnrollErrorMsg" String ""
    "certEnrollState" Integer 0
    "certExpirWarnTime" Integer 90
    "installedTrustedCertificates" Array Struct 0
    "certificate" Struct
        nrOfElements 7
        "issuer" String ""
        "notValidAfter" String ""
        "notValidBefore" String ""
        "serialNumber" String ""
        "subject" String ""
        "fingerprint" String ""
        "subjectAltName" String ""

    "trustedCertInstallState" Integer 0
    "featureState" Integer 0
    "licenseState" Integer 1
    "userLabel" String ""
    "autoUpdateCertEnrollmentServer" String ""
)

MOSC
echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
COUNT=`expr $COUNT + 1`
done
echo " #######Execution of script ended####### "







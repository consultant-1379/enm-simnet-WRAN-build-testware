#!/bin/sh

usage (){

echo "Usage  : $0 <SIM Name>"

echo "Example: $0 RNCV15439x1-FT-RBSU41000x23-RNC01"
}

########################################################################
#To check commandline arguments#
########################################################################
if [ $# -ne 1 ]
then
usage
exit 1
fi
#######################################################################
#Parameters
#######################################################################
SIMNAME=$1

#######################################################################
####Giving permissions to entire folder################################

chmod -R 777 /var/simnet/enm-simnet-WRAN-build-testware 

cd /var/simnet/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/

if [[ $SIMNAME == *"MSRBS"* ]]
then
        echo "**********************************************"
        echo "For RNC with MSRBS Simulations doesn't have unit tests"
        echo "**********************************************"
elif [[ $SIMNAME == *"PRBS"* ]]
then
        echo "**********************************************"
        echo "For RNC with MSRBS Simulations doesn't have unit tests"
        echo "**********************************************"
else
        echo "***************************************************************"
        echo "Checking Subrack is set or not"
        su netsim -c "./check_hardwareConfiguration.sh $SIMNAME | tee -a ../log/hardwareConfiguration.log"

        echo "***************************************************************"
        echo "Checking rbsId is set or not"
        su netsim -c "./check_rbsId.sh $SIMNAME | tee -a ../log/rbsId.log"
        echo "***************************************************************"

HW_Status=`cat ../log/hardwareConfiguration.log | grep "FAIL" | wc -l`
RBS_Status=`cat ../log/rbsId.log | grep "FAIL" | wc -l`

if [ "$HW_Status" -eq 0 ] && [ "$RBS_Status" -eq 0 ]
then
    exit 0
else
    echo "Please check the logs for failures"
    exit 1
fi
fi

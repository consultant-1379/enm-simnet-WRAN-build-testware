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

#####################################################################

####Giving permissions to entire folder################################

chmod -R 777 /var/simnet/enm-simnet-WRAN-build-testware 

cd /var/simnet/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/unit_tests/

if [[ $SIMNAME == *"MSRBS"* ]]
then
	echo "***************************************************************"
        echo "Checking Relation count on RNC node"
        su netsim -c "./Check_Relations.sh $SIMNAME | tee -a log/WRAN-MSRBS_Relations.log"

        echo "**********************************************"
        echo "checking for checkForNodeBFunction for RNC MSRBS sims"
        su netsim -c "./checkForNodeBFunction.sh $SIMNAME | tee -a log/checkForNodeBFunction.log"

	echo "***************************************************************"
        echo "Checking topology file is correct or not"
        su netsim -c "./check_topology.sh $SIMNAME | tee -a log/checkTopology.log"

	echo "***************************************************************"
        echo "Checking PM file Location on MSRBS node"
        su netsim -c "./pmFileLocation.sh $SIMNAME | tee -a log/pmFileLocation.log"

        echo "**********************************************"
        echo "Checking BrmBackupManager mo on MSRBS node"
        su netsim -c "./BrmBackupManager.sh $SIMNAME | tee -a log/BrmBackupManager.log"
        
        echo "**********************************************"
       NodeB_Status=`cat log/checkForNodeBFunction.log | grep "FAIL" | wc -l`
       topology_status=`cat log/checkTopology.log | grep "FAIL" | wc -l`
       CR_Status=`cat log/WRAN-MSRBS_Relations.log | grep "FAIL" | wc -l`
       PMFileLoc_Status=`cat log/pmFileLocation.log | grep "FAIL" | wc -l`
       BrmBackup_Status=`cat log/BrmBackupManager.log | grep "FAIL" | wc -l`
       if [ "$NodeB_Status" -eq 0 ] && [ "$topology_status" -eq 0 ] && [ "$CR_Status" -eq 0 ] && [ "$PMFileLoc_Status" -eq 0 ]
       then
            exit 0
       else
            echo "Please check the logs for failures"
            exit 1
       fi

elif [[ $SIMNAME == *"PRBS"* ]]
then
        echo "**********************************************"
        echo "For RNC with MSRBS Simulations doesn't have unit tests"
        echo "**********************************************"
else
        echo "***************************************************************"
        echo "Checking Relation count on RNC node"
        su netsim -c "./Check_Relations.sh $SIMNAME | tee -a log/WRAN_Relations.log"

        echo "***************************************************************"
        echo "Checking Subrack is set or not"
        su netsim -c "./check_hardwareConfiguration.sh $SIMNAME | tee -a log/hardwareConfiguration.log"

        echo "***************************************************************"
        echo "Checking rbsId is set or not"
        su netsim -c "./check_rbsId.sh $SIMNAME | tee -a log/rbsId.log"

        echo "**********************************************"
        echo "checking for checkForNodeBFunction for RNC RBS sims"
        su netsim -c "./checkForNodeBFunction.sh $SIMNAME | tee -a log/checkForNodeBFunction.log"
        
	echo "***************************************************************"
        echo "Checking topology file is correct or not"
        su netsim -c "./check_topology.sh $SIMNAME | tee -a log/checkTopology.log"

        echo "***************************************************************"

HW_Status=`cat log/hardwareConfiguration.log | grep "FAIL" | wc -l`
RBS_Status=`cat log/rbsId.log | grep "FAIL" | wc -l`
NodeB_Status=`cat log/checkForNodeBFunction.log | grep "FAIL" | wc -l`
topology_status=`cat log/checkTopology.log | grep "FAIL" | wc -l`
CR_Status=`cat log/WRAN_Relations.log | grep "FAIL" | wc -l`

if [ "$HW_Status" -eq 0 ] && [ "$RBS_Status" -eq 0 ] && [ "$NodeB_Status" -eq 0 ] && [ "$topology_status" -eq 0 ] && [ "$CR_Status" -eq 0 ] 
then
    exit 0
else
    echo "Please check the logs for failures"
    exit 1
fi
fi


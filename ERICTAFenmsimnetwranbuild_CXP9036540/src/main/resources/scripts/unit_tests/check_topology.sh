#!/bin/bash

#File Name=TopologyCheck.sh
SimName=$1


echo "############## Checking if Topology File exists or not ################"
UtranFile="/netsim/netsimdir/$SimName/SimNetRevision/UtranCell.txt/"
RbslocalcelldataFile="/netsim/netsimdir/$SimName/SimNetRevision/RbsLocalCellData.txt"
EUtranCellDataFile="/netsim/netsimdir/$SimName/SimNetRevision/EUtranCellData.txt"

cd /netsim/netsimdir/$SimName/SimNetRevision/

if [ -f /netsim/netsimdir/$SimName/SimNetRevision/UtranCell.txt ]
then
    if [ -s /netsim/netsimdir/$SimName/SimNetRevision/UtranCell.txt ]
    then
         echo "INFO :PASSED Topology  File exists and not empty"
         ######################### Checking if Topology file has any ERRORS ###################
         ######################################################################################
         Catch=`cat /netsim/netsimdir/$SimName/SimNetRevision/UtranCell.txt | grep ";"`
         #echo "Catch is $Catch"
         if [[ -z "$Catch" ]]; then
            echo "INFO : PASSED  UtranCell.txt has no errors"
         else
            echo "INFO : FAILED Check the UtranCell.txt file for $SimName $Catch"  
            exit 1
         fi
    else
	echo "INFO: FAILED UtranCell.txt File exists but empty"
        exit 1
    fi
else
    echo "INFO: FAILED, UtranCell.txt File does not exist"
    exit 1
fi
######################################################################################
echo "############## Checking if RbsLocalCellData File exists or not ################"

cd /netsim/netsimdir/$SimName/SimNetRevision/

if [ -f /netsim/netsimdir/$SimName/SimNetRevision/RbsLocalCellData.txt ]
then
    if [ -s /netsim/netsimdir/$SimName/SimNetRevision/RbsLocalCellData.txt ]
    then
        echo "INFO: PASSED, RbsLocalCellData.txt File exists and not empty"
		######################### Checking if Rbslocalcelldata file has any ERRORS ###################
         ######################################################################################
         Catch=`cat /netsim/netsimdir/$SimName/SimNetRevision/RbsLocalCellData.txt | grep ";"`
         #echo "Catch is $Catch"
         if [[ -z "$Catch" ]]; then
            echo "INFO : PASSED  RbsLocalCellData.txt has no errors"
         else
            echo "INFO : FAILED Check RbsLocalCellData.txt file for $SimName $Catch"  
            exit 1
         fi
    else
        echo "INFO : FAILED RbsLocalCellData.txt File exists but empty"
        exit 1
    fi
else
    echo "INFO: FAILED, RbsLocalCellData.txt File does not exist"
    exit 1
fi
################################################################################

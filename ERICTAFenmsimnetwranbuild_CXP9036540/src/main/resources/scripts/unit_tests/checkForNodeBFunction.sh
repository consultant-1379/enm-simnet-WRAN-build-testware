#!/bin/sh
##########################################################################################################################
# Created by  : Harish Dunga
# Created on  : 07.02.2019
# Purpose     : Check if NodeBFunction is present on WCDMA nodes
###########################################################################################################################
hostServer=`hostname`
echo "Running on the box $hostServer ..."
########## Getting the WCDMA simulations List ####################
echo "Searching for WCDMA Simulations ..."
simulationList=`ls /netsim/netsimdir | grep "RNC.*RNC" | grep -v zip`
if [ -z $simulationList ]
then
   echo "******* There are no WCDMA simulations on the box $hostServer ...! ******"
   exit -1
fi
if [ -e NodeBcheck_Report.txt ]
then
   rm NodeBcheck_Report.txt
fi
simulations=(${simulationList// / })
for simName in ${simulations[@]}
do
   echo "----------------------------------------------------------------------" | tee -a NodeBcheck_Report.txt
   echo "***  Testing the sim $simName  ***"
   ########## Getting the NodeList ###################################
   if [[ $simName == *MSRBS* ]]
   then
      nodeList=`echo netsim | sudo -S -H -u netsim bash -c 'echo -e ".open '$simName' \n .show simnes" | /netsim/inst/netsim_pipe | grep "MSRBS-V2 "' | cut -d" " -f1`
   else
      nodeList=`echo netsim | sudo -S -H -u netsim bash -c 'echo -e ".open '$simName' \n .show simnes" | /netsim/inst/netsim_pipe | grep " RBS "' | cut -d" " -f1`
   fi
   nodes=(${nodeList// / })
   for node in ${nodes[@]}
   do
      node_moDataFile="/netsim/"$node"_dump.txt"
      if [ -e $node_moDataFile ]
      then 
         rm $node_moDataFile
      fi
      echo netsim | sudo -S -H -u netsim bash -c 'echo -e ".open '$simName'\n.select '$node'\n.start\ndumpmotree:moid="1",outputfile=\"'$node_moDataFile'\";" | /netsim/inst/netsim_pipe' 2>&1 >/dev/null
      checkForNodeB=`cat $node_moDataFile | grep "NodeBFunction"`
      if [[ -n $checkForNodeB ]]
       then
         echo "   PASSED: The Node $node has NodeB fragments" | tee -a NodeBcheck_Report.txt
      else
         echo -e '   \033[1mERROR\033[0m: The Node \033[1m'$node'\033[0m has no NodeB fragment'
         echo -e '   ERROR: The Node '$node' has no NodeB fragment' >> NodeBcheck_Report.txt
      fi
    rm $node_moDataFile

    done
done
echo "----------------------------------------------------------------------" | tee -a NodeBcheck_Report.txt

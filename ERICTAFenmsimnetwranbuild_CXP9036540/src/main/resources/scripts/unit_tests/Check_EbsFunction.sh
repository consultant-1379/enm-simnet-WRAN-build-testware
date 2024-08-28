#!/bin/bash

#Version History
###################################################################################################
#Version1       : 23.01
#Created by     : AJAYGANESH ACHYUTHA
#Created on     : 30 NOV 2022
#Revision       : CXP 903 6540-1-18
#Purpose        : For checking the values RcsRem of EBS Support
#Jira Details   : NNS-41460
###################################################################################################
   

SIM=$1

PWD=`pwd`

if [[ $# -ne 1 ]]
then
    echo "ERROR:Invalid Arguments"
    echo "INFO: ./$0 SIMNAME"
    exit 1
fi

if [[ ! $SIM == *"MSRBS"* ]]
then
echo "INFO: EbsFeatures should be checked for MSRBS nodes"
exit
fi

NodeType=MSRBS
NodeVersion=`echo "$SIM" | awk -F 'x' '{print $2}' | sed 's/1-FT-MSRBS-//g' | sed s/-/_/2`
NodeURL="https://netsim.seli.wh.rnd.internal.ericsson.com/tssweb/simulations/com3.1/"
MSRBS_Template=`curl $NodeURL | grep ${NodeType}"_V2_"${NodeVersion} | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'| cut -d "." -f1 `
#wget $NodeURL/$MSRBS_Template
MSRBS_Template_WithoutZIP=`echo $MSRBS_Template | awk -F '.' '{print $1}'`
Nodeversion=`echo "$NodeVersion" | sed 's/[A-Z]//g' | sed 's/-//g' | sed 's/_//g'`
if [[ $Nodeversion -ge 2221 ]]
then
echo "node ver: $Nodeversion"
echo "$MSRBS_Template_WithoutZIP"
su netsim -c "echo -e '.select network \n .start' | ~/inst/netsim_shell -sim $SIM"

CELLTYPE1="RcsRem:NrEtcm" 
CELLTYPE2="RcsRem:NrFtem"
CELLTYPE3="RcsRem:NrPmEvents"

etcmcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
etcmcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
etcmdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "etcm_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

ftemcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
ftemcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
ftemdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "ftem_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`

pmcucp=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_cucp" | awk -F "cucp_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
pmcuup=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_cuup" | awk -F "cuup_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`
pmdu=`ls /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ | grep "pm_event_package_du" | awk -F "du_" '{print $2}' | cut -d "." -f1 | sed -e "s/_/./g"`


NodeList=`su netsim -c "echo -e '.open '$SIM'\n.show simnes' | /netsim/inst/netsim_shell | grep 'MSRBS-V2' | cut -d ' ' -f1"` 
Nodes=(${NodeList// /})
for NodeName in ${Nodes[@]}
do

NrEtcmList=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_mo_ids_by_type(null,\"'${CELLTYPE1}'\").' | /netsim/inst/netsim_shell | tail -n+6 | tr -d  '\n' | tr -d '[:space:]' | sed 's/[][]//g'"`

NrFtemList=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_mo_ids_by_type(null,\"'${CELLTYPE2}'\").' | /netsim/inst/netsim_shell | tail -n+6 | tr -d  '\n' | tr -d '[:space:]' | sed 's/[][]//g'"`

NrPmEventsList=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_mo_ids_by_type(null,\"'${CELLTYPE3}'\").' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '\n' | tr -d '[:space:]' | sed 's/[][]//g'"`

moIds1=(${NrEtcmList//,/ })
moIds2=(${NrFtemList//,/ })
moIds3=(${NrPmEventsList//,/ })

for moId in ${moIds1[@]}
do

  NrEtcmvalue=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_attribute_value(null,'$moId',version).' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '[\"]'"`
  
  NrEtcmvalue1=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_attribute_value(null,'$moId',managedFunction).' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '[\"]'"` 
  #echo $NrEtcmvalue1 $moId
  
if [[ $NrEtcmvalue1 == CUCP ]] 
then 
	if [[ $NrEtcmvalue == $etcmcucp ]]
	then 
	echo "Passed: Version value for NrEtcm Mo of CUCP type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrEtcm Mo of CUCP type is not correct for $NodeName" >> Ebs_result.txt 
	fi
elif [[ $NrEtcmvalue1 == CUUP ]] 
then 
	if [[ $NrEtcmvalue == $etcmcuup ]]
	then 
	echo "Passed: Version value for NrEtcm Mo of CUUP type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrFtem Mo of CUUP type is not correct for $NodeName" >> Ebs_result.txt
	fi
elif [[ $NrEtcmvalue1 == DU ]] 
then 
	if [[ $NrEtcmvalue == $etcmdu ]]
	then 
	echo "Passed: Version value for NrEtcm Mo of DU type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrEtcm Mo of DU type is not correct for $NodeName" >> Ebs_result.txt
	fi
fi
done


for moId in ${moIds2[@]}
do
	NrFtemvalue=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_attribute_value(null,'$moId',version).' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '[\"]'"`
	
	NrFtemvalue1=` su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_attribute_value(null,'$moId',managedFunction).' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '[\"]'"`
	#echo $moId $NrFtemvalue1 $NrFtemvalue
	
if [[ $NrFtemvalue1 == CUCP ]] 
then 
	if [[ $NrFtemvalue == $ftemcucp ]]
	then 
            echo "Passed: Version value for NrFtem Mo of CUCP type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrFtem Mo of CUCP type is not correct for $NodeName" >> Ebs_result.txt
	fi
elif [[ $NrFtemvalue1 == CUUP ]] 
then 
	if [[ $NrFtemvalue == $ftemcuup ]]
	then 
	echo "Passed: Version value for NrFtem Mo of CUUP type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrFtem Mo of CUUP type is not correct for $NodeName" >> Ebs_result.txt
	fi
elif [[ $NrFtemvalue1 == DU ]] 
then 
	if [[ $NrFtemvalue == $ftemdu ]]
	then 
	echo "Passed: Version value for NrFtem Mo of DU Type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrFtem Mo of DU Type is not correct for $NodeName" >> Ebs_result.txt
	fi
fi
done

for moId in ${moIds3[@]}
do
	NrPmEventsvalue=` su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_attribute_value(null,'$moId',version).' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '[\"]'"`
	
	NrPmEventsvalue1=` su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_attribute_value(null,'$moId',managedFunction).' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '[\"]'"`
	#echo $moId $NrPmEventsvalue $NrPmEventsvalue1

if [[ $NrPmEventsvalue1 == CUCP ]] 
then 
	if [[ $NrPmEventsvalue == $pmcucp ]]
	then 
	echo "Passed: Version value for NrPmEvents Mo of CUCP type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Versison value for NrPmEvents Mo of CUCP type  is not correct for $NodeName" >> Ebs_result.txt
	fi
elif [[ $NrPmEventsvalue1 == CUUP ]] 
then 
	if [[ $NrPmEventsvalue == $pmcuup ]]
	then 
	echo "Passed: Version value for NrPmEvents Mo of CUUP type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrPmEvents Mo of CUUP type not correct for $NodeName" >> Ebs_result.txt
	fi
	
elif [[ $NrPmEventsvalue1 == DU ]] 
then 
	if [[ $NrPmEventsvalue == $pmdu ]]
	then 
	echo "Passed: Version value for NrPmEvents Mo of DU type is correct for $NodeName" >> Ebs_result.txt
	else 
	echo "Failed: Version value for NrPmEvents Mo of DU type is not correct for $NodeName" >> Ebs_result.txt
	fi
fi	
done
    
    LIST1=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_mo_ids_by_type(null,\"'${CELLTYPE1}'\").' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '\n' | tr -d '[:space:]' | sed 's/[][]//g'"`
    LIST2=` su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_mo_ids_by_type(null,\"'${CELLTYPE2}'\").' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '\n' | tr -d '[:space:]' | sed 's/[][]//g'"`
    LIST3=`su netsim -c "echo -e '.open '$SIM'\n.select '$NodeName'\ne csmo:get_mo_ids_by_type(null,\"'${CELLTYPE3}'\").' | /netsim/inst/netsim_shell | tail -n+6 | tr -d '\n' | tr -d '[:space:]' | sed 's/[][]//g'"`

NrEtcmMoIds=(${LIST1//,/ })
NrFtemMoIds=(${LIST2//,/ })
NrPmEventsMoIds=(${LIST3//,/ })

NrEtcmLength=${#NrEtcmMoIds[@]}
NrFtemLength=${#NrFtemMoIds[@]}
NrPmEventsLength=${#NrPmEventsMoIds[@]}

#echo " L1=$NrEtcmLength L2=$NrFtemLength L3=$NrPmEventsLength "
if  [[ $NrEtcmLength -eq 3 ]] && [[ $NrFtemLength -eq 3 ]] && [[ $NrPmEventsLength -eq 3 ]] 
then 
    echo "UT is Passed sucessfully for $NodeName as MO Structure exists" >> Ebs_result.txt 
else
    echo " UT is Failed for $NodeName please check whether the MO structure exists or not" >> Ebs_result.txt
fi
done
if [[ -f "Ebs_result.txt" ]]
then
   check =`cat Ebs_result.txt | grep 'Failed'`
   if [[ -z $check ]]
   then
       echo "PASSED: All checks are passed on all Nodes"
       cat Ebs_result.txt
   else
       echo "FAIL: Few Checks are failed on few nodes please check the logs."
       cat Ebs_result.txt
       exit 1
    fi
else
    echo "FAIL: Ebs_result file was not present UT was not run on nodes"
    exit 1
fi
else
    echo "INFO: For 22-Q2-V1 below node versions EBS UT is not needed"
fi

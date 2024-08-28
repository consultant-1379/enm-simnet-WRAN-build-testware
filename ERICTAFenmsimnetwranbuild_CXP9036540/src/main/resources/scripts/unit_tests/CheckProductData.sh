#!/bin/sh

#####################################################
#     File Name     : CheckProductData.sh
#     Version       : 1.01
#     Author        : Mitali Sinha
#     Date          : 24 June 2019
#     JIRA Details  : NSS-25738
#####################################################

SimName=$1

echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .show simnes' | /netsim/inst/netsim_shell | grep -v \">>\" | grep -v \"OK\" | grep -v \"NE\"" > NodeData.txt
cat NodeData.txt | awk '{print $1"_"$3"_"$4}' > NodeData1.txt
for NodeData in `cat NodeData1.txt`
do
NODE=`echo $NodeData | awk -F "_" '{print $1}'`
TYPE=`echo $NodeData | awk -F "_" '{print $2}'`
MIM=`echo $NodeData | awk -F "_" '{print $3}'`
if [ "$TYPE" = "RNC" ]
then
	    PRD=`cat ProductData.env| grep -i $MIM | awk -F "=" {'print $2'}`
	    PrdData=`echo $PRD |awk -F ":" {'print $1'} | tr -d '[:cntrl:]'`
        PrdRev=`echo $PRD |awk -F ":" {'print $2'} | tr -d '[:cntrl:]'`
	id="e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"SwManagement=1\",\"UpgradePackage=1\"])."
elif [ "$TYPE" = "RBS" ]
then
        PRD=`cat ProductData.env| grep -i $MIM | awk -F "=" {'print $2'}`
        PrdData=`echo $PRD |awk -F ":" {'print $1'} | tr -d '[:cntrl:]'`
        PrdRev=`echo $PRD |awk -F ":" {'print $2'} | tr -d '[:cntrl:]'`
	id="e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"SwManagement=1\",\"UpgradePackage=1\"])."
elif [ "$TYPE" = "MSRBS-V2" ]
then
	    PRD=`cat ProductData.env| grep -i $MIM | awk -F "=" {'print $2'}`
        PrdData=`echo $PRD |awk -F ":" {'print $1'} | tr -d '[:cntrl:]'`
        PrdRev=`echo $PRD |awk -F ":" {'print $2'} | tr -d '[:cntrl:]'`
  	id="e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$NODE\",\"ComTop:SystemFunctions=1\",\"RcsSwIM:SwInventory=1\",\"RcsSwIM:SwItem=1\"])."
    id2="e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$NODE\",\"ComTop:SystemFunctions=1\",\"RcsSwIM:SwInventory=1\",\"RcsSwIM:SwVersion=1\"])."
fi

echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .select '$NODE' \n .start \n $id \n e: simdiv:keysearch(productnumber,csmo:get_attribute_value(null,X,administrativeData)).' | /netsim/inst/netsim_shell " > Prd_Data.txt

Prd_data_node=`cat Prd_Data.txt | tail -1 | cut -d '"' -f 2 | tr -d '[:cntrl:]'`

echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .select '$NODE' \n .start \n $id \n e: simdiv:keysearch(productrevision,csmo:get_attribute_value(null,X,administrativeData)).' | /netsim/inst/netsim_shell " > Prd_Rev.txt

Prd_rev_node=`cat Prd_Rev.txt | tail -1 | cut -d '"' -f 2 | tr -d '[:cntrl:]'`

if [[ $id2 != "" ]]
then
    echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .select '$NODE' \n .start \n $id2 \n e: simdiv:keysearch(productnumber,csmo:get_attribute_value(null,X,administrativeData)).' | /netsim/inst/netsim_shell " > Prd_Data2.txt
    Prd_data_version=`cat Prd_Data2.txt | tail -1 | cut -d '"' -f 2 | tr -d '[:cntrl:]'`

    echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SimName' \n .select '$NODE' \n .start \n $id2 \n e: simdiv:keysearch(productrevision,csmo:get_attribute_value(null,X,administrativeData)).' | /netsim/inst/netsim_shell " > Prd_Rev2.txt
    Prd_rev_version=`cat Prd_Rev2.txt | tail -1 | cut -d '"' -f 2 | tr -d '[:cntrl:]'`

fi

if [[ $id2 != "" ]]
then
   if [[ "$Prd_data_node" != "$Prd_data_version" || "$Prd_rev_node" != "$Prd_rev_version" ]]
   then
      echo "INFO: FAILED, Product Data Details Of SwVersion and SwItem on $NODE have different values. They should be set to samevalues"
      #exit 1
      continue;
   fi
fi
if [[ "$Prd_data_node" = "$PrdData" &&  "$Prd_rev_node" = "$PrdRev" ]]
then
	echo "INFO: PASSED , Product Data Details are correct on $NODE"
else 
	echo "INFO: FAILED, Product Data Details are not correct on $NODE, It is $Prd_data_node & $Prd_rev_node , it should be $PrdData & $PrdRev"
        #exit 1
fi

done

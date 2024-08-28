#!/bin/sh

#Version History
###################################################################################################
#Version1       : 20.07
#Created by     : Yamuna Kanchireddygari
#Created on     : 2nd Apr 2020
#Revision       : CXP 903 6540-1-6
#Purpose        : checking fileLocation/outputDirectory Attribute on PmMeasurementCapabilities MO
#Jira Details   : NNS-27983
###################################################################################################

rm NodeData1.txt NodeData.txt

SIM=$1
Path=`pwd`

if [[ $SIM =~ "MSRBS" ]]
then
    fileLocationValue="/c/pm_data/"
    outputDirectoryValue="/c/pm_data/"
else
    echo "*********************************************" >> Result.txt
    echo "There is no fileLocation/Outputdirectory unit test for this simulation $SIM" >> Result.txt
    echo "*********************************************" >> Result.txt
    cat Result.txt
    exit
fi

echo "fileLocationValue = $fileLocationValue" | tee -a Result.txt
echo "outputdirectoryValue = $outputDirectoryValue" | tee -a Result.txt

echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .show simnes' | /netsim/inst/netsim_shell | grep -v \">>\" | grep -v \"OK\" | grep -v \"NE\" | grep \"MSRBS-V2\"" > NodeData.txt

cat NodeData.txt | awk '{print $1}' > NodeData1.txt
IFS=$'\n' read -d '' -r -a node < NodeData1.txt
Length=${#node[@]}

for i in "${node[@]}"
do

     id=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $i \n .start \n e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$i\",\"ComTop:SystemFunctions=1\",\"RcsPm:Pm=1\"]).' | /netsim/inst/netsim_shell | tail -1"`

     fileLocationId=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $i \n e Value=csmo:get_children_by_type(null,$id,\"RcsPm:PmMeasurementCapabilities\"). \n e [Y]=Value. \n e csmo:get_attribute_value(null,Y,fileLocation).' | /netsim/inst/netsim_shell | tail -1 | tr -d '\"'"`

     id1=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $i \n .start \n e X=csmo:ldn_to_mo_id(null,[\"ComTop:ManagedElement=$i\",\"ComTop:SystemFunctions=1\",\"RcsPMEventM:PmEventM=1\",\"RcsPMEventM:EventProducer=Lrat\"]).' | /netsim/inst/netsim_shell | tail -1"`

     outputDirectoryId=`echo netsim | sudo -S -H -u netsim bash -c "echo -e '.open '$SIM' \n .select $i \n e Value=csmo:get_children_by_type(null,$id1,\"RcsPMEventM:FilePullCapabilities\"). \n e [Y]=Value. \n e csmo:get_attribute_value(null,Y,outputDirectory).' | /netsim/inst/netsim_shell | tail -1 | tr -d '\"'"`

    if [[ $fileLocationId == $fileLocationValue ]]
    then
           echo "Info: PASSED on $i fileLocation is $fileLocationId" >> Result.txt
    else
           echo "Info: FAILED on $i fileLoaction is $fileLocationId but it should be $fileLocationValue" >> Result.txt
    fi
    if [[ $outputDirectoryId == $outputDirectoryValue ]]
    then
           echo "Info: PASSED on $i outputDirectory is $outputDirectoryId" >> Result.txt
    else
           echo "Info: FAILED on $i outputDirectory is $outputDirectoryId but it should be $outputDirectoryValue" >> Result.txt
    fi

done

cat Result.txt

if  grep -q FAILED "Result.txt"
then
    echo "******INFO: There are some Failures********"
    exit 903
else
    echo "****** PASSED PMfileLocation/ouputDirectory on $SIM **********"
fi


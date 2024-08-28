#!/bin/sh 

SimName=$1
echo "-----SimName=$SimName-------"
##########Storing Node Names into a text file--NodeData1.txt####################
echo netsim | sudo -S -H -u netsim bash -c 'printf ".open '$SimName' \n .show simnes" | /netsim/inst/netsim_shell | grep -v ">>" | grep -v "OK" | grep -v "NE"' > NodeData.txt
cat NodeData.txt | awk '{print $1}' > NodeData1.txt
###Storing the nodes in an array###
cut -f1 -d ' ' NodeData.txt > NodeData1.txt
IFS=$'\n' read -d '' -r -a node < NodeData1.txt
Length=${#node[@]}
echo "---------node length=$Length---------"
    for i in "${node[@]:1}"
        do

           printf ".open $SimName \n .select $i \n e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"Equipment=1\",\"Subrack=1\"]). \n e Value = csmo:get_attribute_value(null,X,operationalProductData)." | /netsim/inst/netsim_shell > Data_2.txt
           Subrack1=$(cat Data_2.txt | head -8 | tail -1 | awk -F '"' '{print $2}')
            if [[ ${Subrack1} == RBS14B ]]
                 then
                  echo "INFO : PASSED on "$i" Subrack1 is set to RBS14B"
                  else
                  echo "INFO: FAILED on "$i" Subrack1 is not set to RBS14B"
            fi
          printf ".open $SimName \n .select $i \n e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"Equipment=1\",\"Subrack=2\"]). \n e Value = csmo:get_attribute_value(null,X,operationalProductData)." | /netsim/inst/netsim_shell > Data_3.txt
           Subrack2=$(cat Data_3.txt | head -8 | tail -1 | awk -F '"' '{print $2}')
            if [[ ${Subrack2} == RBS14B ]]
                 then
                 echo "INFO : PASSED on "$i" Subrack2 is set to RBS14B"
                  else
                  echo "INFO: FAILED on "$i" Subrack2 is not set to RBS14B"
            fi
           printf ".open $SimName \n .select $i \n e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"Equipment=1\",\"Subrack=3\"]). \n e Value = csmo:get_attribute_value(null,X,operationalProductData)." | /netsim/inst/netsim_shell > Data_4.txt
           Subrack3=$(cat Data_4.txt | head -8 | tail -1 | awk -F '"' '{print $2}')
            if [[ ${Subrack3} == RBS14B ]]
                 then
                 echo "INFO : PASSED on "$i" Subrack3 is set to RBS14B"
                  else
                  echo "INFO: FAILED on "$i" Subrack3 is not set to RBS14B"
            fi
          printf ".open $SimName \n .select $i \n e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"Equipment=1\",\"Subrack=4\"]). \n e Value = csmo:get_attribute_value(null,X,operationalProductData)." | /netsim/inst/netsim_shell > Data_5.txt
           Subrack4=$(cat Data_5.txt | head -8 | tail -1 | awk -F '"' '{print $2}')
            if [[ ${Subrack4} == RBS14B ]]
                 then
                 echo "INFO : PASSED on "$i" Subrack4 is set to RBS14B"
                  else
                  echo "INFO: FAILED on "$i" Subrack4 is not set to RBS14B"
            fi


 done

rm -rf Data_2.txt
rm -rf Data_3.txt
rm -rf Data_4.txt
rm -rf Data_5.txt



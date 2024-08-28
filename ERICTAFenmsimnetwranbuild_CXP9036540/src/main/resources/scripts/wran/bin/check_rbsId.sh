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

           printf ".open $SimName \n .select $i \n e X=csmo:ldn_to_mo_id(null,[\"ManagedElement=1\",\"NodeBFunction=1\",\"Iub=1\"]). \n e Value = csmo:get_attribute_value(null,X,rbsId)." | /netsim/inst/netsim_shell > Data.txt
           Value_on_node=$(cat Data.txt | tail -1)

                        array[$Value_on_node]=$Value_on_node

                          if [[ $i =~ "RBS0" ]]
                          then
                                tmp=$(echo "$i" | awk -F "RBS0" '{print $2}')
                          else
                                tmp=$(echo "$i" | awk -F "RBS" '{print $2}')
                        fi

                 nodenum+=($tmp) 
    done

       for j in "${nodenum[@]}"; do

            if [[ ${nodenum[$j-1]} == ${array[$j]} ]]
            then
                 echo "INFO: PASSED on "${node[$j]}" "
            else
                 echo "INFO: FAILED on "${node[$j]}" "
            fi

        done

rm -rf Data.txt
rm -rf NodeData.txt
rm -rf NodeData1.txt




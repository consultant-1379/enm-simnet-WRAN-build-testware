#!/bin/sh

file=$2
SIM=$1

if [ "$#" -ne 2  ]
then
 echo
 echo "### FAILED: Please give proper inputs .. !!! ###"
 echo
 echo "Usage: $0 <sim name> <UtranCell file>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4340x150-RNC10 RNCV71659x1-FT-RBSU4340x150-RNC10_UtranCell.txt"
 echo
 exit 1
fi

if [ -f $file ]
then
    echo "########## Creating RbsLocalCell data ... ##########"
else
    echo "*********** FAILED: No Input UtranCell data !!! *************"
    echo
    echo "*# Cannot create RbsLocalCell data for the sim $SIM #*"
    exit 1
fi

rm -rf out.txt
while IFS= read line
do
    # display $line or do somthing with $line
    #echo -n $line | tail -c 3
    #echo $line | grep -o .$
  
    var=$(echo $line | awk -F "=" '{print $6}')
    var3=$(echo $line | awk -F'=' '{print $6}'|cut -f 1 -d "-")
    var1=$(echo $var | awk -F'-' '{print $2}')
    var2=$(echo $var | awk -F'-' '{print $3}')
     var4="RBS0"
      var5="RBS"

	    if [ "$var1" -lt 10 ]
    then
        echo "SubNetwork=$var3$var4$var1,MeContext=$var3$var4$var1,ManagedElement=1,NodeBFunction=1,RbsLocalCell=$var2" >> out.txt
    else   
        echo "SubNetwork=$var3$var5$var1,MeContext=$var3$var5$var1,ManagedElement=1,NodeBFunction=1,RbsLocalCell=$var2" >> out.txt
    fi
done< "$file"
cd ~/netsimdir/$SIM/SimNetRevision
if [ -f Rbsutrancell.txt ]
then
echo "true"
rm -rf Rbsutrancell.txt
touch RbsLocalCellData.txt
cp -r /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/out.txt ./RbsLocalCellData.txt
rm out.txt
else
touch RbsLocalCellData.txt
cp -r /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/out.txt ./RbsLocalCellData.txt
fi    
#echo "$line"

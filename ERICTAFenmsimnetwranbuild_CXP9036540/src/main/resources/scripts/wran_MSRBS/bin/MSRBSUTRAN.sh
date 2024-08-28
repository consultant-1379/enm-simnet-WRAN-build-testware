#!/bin/sh

file=$2
SIM=$1
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
     var4="MSRBS-V20"
      var5="MSRBS-V2"

	    if [ " $var1 " -lt " 10 " ]
    then
        echo "SubNetwork=$var3$var4$var1,MeContext=$var3$var4$var1,ManagedElement=1,NodeBFunction=1,NodeBLocalCellGroup=1,RbsLocalCell=$var2" >> out.txt
    else   
        echo "SubNetwork=$var3$var5$var1,MeContext=$var3$var5$var1,ManagedElement=1,NodeBFunction=1,NodeBLocalCellGroup=1,RbsLocalCell=$var2" >> out.txt
    fi
done< "$file"
cd /netsim/netsimdir/$SIM/SimNetRevision
if [ -f RbsLocalCellData.txt ]
then
echo "true"
rm -rf RbsLocalcellData.txt
touch RbsLocalCellData.txt
cp -r /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/bin/out.txt ~/netsimdir/$SIM/SimNetRevision/RbsLocalCellData.txt
else
touch RbsLocalCellData.txt
cp -r /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/bin/out.txt ~/netsimdir/$SIM/SimNetRevision/RbsLocalCellData.txt
fi    
#echo "$line"

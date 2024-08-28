#!/bin/sh

file=$2
SIM=$1
rm -rf out_mixed.txt
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
            echo "SubNetwork=$var3$var4$var1,MeContext=$var3$var4$var1,ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=$var3$var4$var1-1" >> out_mixed.txt
            echo "SubNetwork=$var3$var4$var1,MeContext=$var3$var4$var1,ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=$var3$var4$var1-2" >> out_mixed.txt
            echo "SubNetwork=$var3$var4$var1,MeContext=$var3$var4$var1,ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=$var3$var4$var1-3" >> out_mixed.txt
    else
        echo "SubNetwork=$var3$var5$var1,MeContext=$var3$var5$var1,ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=$var3$var5$var1-1" >> out_mixed.txt
	echo "SubNetwork=$var3$var5$var1,MeContext=$var3$var5$var1,ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=$var3$var5$var1-2" >> out_mixed.txt
	echo "SubNetwork=$var3$var5$var1,MeContext=$var3$var5$var1,ManagedElement=1,ENodeBFunction=1,EUtranCellFDD=$var3$var5$var1-3" >> out_mixed.txt
    fi

done< "$file"
cd ~/netsimdir/$SIM/SimNetRevision
if [ -f EUtranCellData.txt ]
then
echo "true"
rm -rf EUtranCellData.txt
touch EUtranCellData.txt
cp -r ~/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/bin/out_mixed.txt ./EUtranCellData.txt
else
touch EUtranCellData.txt
cp -r ~/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/bin/out_mixed.txt ./EUtranCellData.txt
fi
#echo "$line"


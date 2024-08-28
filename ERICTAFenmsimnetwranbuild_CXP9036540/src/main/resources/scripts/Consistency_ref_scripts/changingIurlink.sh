#!/bin/sh
path=`pwd`
Mofile=$1

count=1
IurLink_Total=`cat $Mofile | grep "moType IurLink" | wc -l`
#IurLink_value=`cat $Mofile | grep -B1 "moType IurLink" | grep -v "\--" | grep -v "moType" |awk -F"identity " '{print $2}'| head -$count | tail -1`
ExternalUtranCell_MO=`cat $path/UtranCelldata.txt | grep "moType ExternalUtranCell" | wc -l`
Value_to_assign=`expr $ExternalUtranCell_MO / $IurLink_Total `

echo " IurLink_total is $IurLink_Total"
echo "ExternalUtranCell_Mo is $ExternalUtranCell_MO"
echo "Value to assign is $Value_to_assign"

i=1
j=1
for i in $( seq 1 $ExternalUtranCell_MO )
do
IurLink_value=`cat $Mofile | grep -B1 "moType IurLink" | grep -v "\--" | grep -v "moType" |awk -F"identity " '{print $2}'| head -$count | tail -1`
#IurLink_value=`cat RNC01_Iurlinkdata.txt | head -$count | tail -1`
parentmo=`cat $path/UtranCelldata.txt | grep "parent " | head -$i | tail -1 | awk -F"parent " '{print $2}'` 
replacestring=`echo $parentmo | cut -d'"' -f2`
sed -i "0,/$parentmo/{s/$parentmo/\"$replacestring,IurLink=$IurLink_value\"/}" $path/UtranCelldata.txt
echo " Parent Mo is $parentmo"
if [[ $j -le $Value_to_assign ]]
then
echo " j value is $j"
#IurLink_value=`cat $Mofile | grep -B1 "moType IurLink" | grep -v "\--" | grep -v "moType" |awk -F"identity " '{print $2}'| head -$count | tail -1`
#sed -i "0,/$parentmo/{s/$parentmo/$parentmo,IurLink=$IurLink_value/}" $path/UtranCelldata.txt
j=`expr $j + 1`
else
count=`expr $count + 1`
echo "count value is $count"
j=1
fi
#IurLink_value=`cat $Mofile | grep -B1 "moType IurLink" | grep -v "\--" | grep -v "moType" |awk -F"identity " '{print $2}'| head -$count | tail -1`
echo "Iurlink value is $IurLink_value"
#sed -i "0,/$parentmo/{s/$parentmo\"/$parentmo,IurLink=$IurLink_value\"/}" $path/UtranCelldata.txt

i=`expr $i + 1`
done







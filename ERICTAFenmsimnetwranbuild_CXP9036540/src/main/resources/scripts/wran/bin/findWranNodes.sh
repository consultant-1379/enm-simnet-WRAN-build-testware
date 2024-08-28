#!/bin/bash
array="1,2,3;"\
"4,5,6;"\
"7,8,9;"
IFS=";"
for x in $array
do
val=$(echo $x | awk -F"," '{print $1}') 
if [ $val -gt 1 ]
then
echo $val
fi
done

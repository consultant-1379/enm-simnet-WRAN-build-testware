#!/bin/sh

##############################################################################
#Author                     :  zchianu
#
#Version                    :  1.1
#
#Purpose                    :  to assign external utran cell value 
##############################################################################


if [ "$#" -ne 2  ]
then
echo
echo "Usage: $0 <ExternalUtranCellIdentity> <parent Mofile>"
echo
echo "Example: $0 RNC01_ExternUtranidentity.txt RNC01.mo"


file=$1
Mofile=$2
count=1

while IFS= read -r line; do

var1=`cat $Mofile | grep "utranCellRef Ref"| head -$count | tail -1`
var2=`echo $var1 | awk -F"ExternalUtranCell" '{print $1}'`ExternalUtranCell=$line

echo "$var1 is var1"
echo "$var2 is var2"
echo "$line is frst value "

sed -i "0,/$var1/{s/$var1/$var2/}" "$Mofile"


echo "sed change done for $line"

cat $Mofile | grep ",ExternalUtranCell" | head -$count | tail -1

count=`expr $count + 1`

done < $file

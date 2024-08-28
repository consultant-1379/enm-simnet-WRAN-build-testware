#!/bin/sh

##############################################################################
#Author                     :  zchianu
#
#Version                    :  1.1
#
#Purpose                    :  To create refs for ExternalUtranCells 
##############################################################################


if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0 <Master Mofile> <Proxymofile>"
 echo
 echo "Example: $0 RNC01.mo RNC02_utranproxies.mo"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

Mofile=$1

Proxyfile=$2

Iurlink_value=`echo $Proxyfile | cut -d"_" -f1 | cut -c4,5`

if [[ $Iurlink_value =~ 0 ]]
then
RNCNUM=`echo $Proxyfile | cut -d"_" -f1 | cut -c5`
RNCNAME=RNC0"$RNCNUM"
else
RNCNUM=$Iurlink_value
RNCNAME=RNC"$RNCNUM"
fi


refcount=`cat $Proxyfile | grep "moType ExternalUtranCell" | wc -l`

totalrefcount=`expr $refcount \* 11`

cat $Mofile | grep -B7 -A3 "utranCellRef Ref ManagedElement=1,RncFunction=1,IurLink=$RNCNUM," | grep -v "\--" | head -$totalrefcount > "$RNCNAME"_ExternUtranReffor_"$Mofile"

cat $Proxyfile | grep -B1 "moType ExternalUtranCell" | grep -v "moType" | grep -v "\--" | awk -F"identity " '{print $2}' > "$RNCNAME"_ExternUtranidentity.txt

count=1

while IFS= read -r line; do

var1=`cat "$RNCNAME"_ExternUtranReffor_"$Mofile" | grep "utranCellRef Ref"| head -$count | tail -1`
var2=`echo $var1 | awk -F"ExternalUtranCell" '{print $1}'`ExternalUtranCell=$line

echo "$var1 is var1"
echo "$var2 is var2"
echo "$line is frst value "

sed -i "s/$var1/$var2/g" "$RNCNAME"_ExternUtranReffor_"$Mofile"


echo "sed change done for $line"

count=`expr $count + 1`

done < $RNCNAME"_ExternUtranidentity.txt


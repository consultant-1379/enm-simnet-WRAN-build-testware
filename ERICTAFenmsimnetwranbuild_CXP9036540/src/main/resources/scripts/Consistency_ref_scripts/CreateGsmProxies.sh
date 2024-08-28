#!/bin/sh

##############################################################################
#Author                     :  zchianu
#
#Version                    :  1.1
#
#Purpose                    :  To create GSM Proxies on RNC node
##############################################################################


####################### this script is used to create GSM proxies(ExternalGsmCell) for all the RNC's present in a network (or NRM) , input file is the gsm handover file given by gsm designer , calculate the cell values and then divide the values from the handover file as needed among all the RNC's in the NRM. For example in NRM5.1 , we have a handover file from gsm with 30k lines , and the network size is 10159 , RNC01 has 1589, RNC02 - 1589, RNC03-7001 , 30k/10k == per cell we can have 3 , 1589 * 3 = 4676  - RNC01  ( Utrancellvalue * avg value ), RNC02 .. 1589 * 3 = 4676, RNC03 .. 7001 *3 = 21k , in this way RNC01 will have 4767 external Gsm cells to be created , next RNC02's ExtrnalGsmCells should be created from 4768 upto next 4767th line, likewise with other RNC. Make sure to delete existing proxies and create new ones #############


if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <GsmHandoverfile>"
 echo
 echo "Example: $0 file.csv"
 echo
 exit 1
fi

file=$1
count=1
######## change the count value for every RNC depending on the calulation ###################
while IFS= read -r line; do
if [ $count -ge 4768 ]
then
echo "Line value above required value, required count met hence exiting"
exit 1
fi
echo "line number is $count"
Total_line=`cat $file | head -$count | tail -1`
userLabel=`echo $Total_line | cut -d";" -f1 | cut -d"=" -f2`
cellIdentity=`echo $Total_line | cut -d";" -f6 | cut -d"=" -f2`
ExternalGsmCellId=`echo $Total_line | cut -d";" -f6 | cut -d"=" -f2`
bcc=`echo $Total_line | cut -d";" -f8 | cut -d"=" -f2`
bcchFrequency=`echo $Total_line | cut -d";" -f9 | cut -d"=" -f2`
lac=`echo $Total_line | cut -d";" -f5 | cut -d"=" -f2`
ncc=`echo $Total_line | cut -d";" -f7 | cut -d"=" -f2`

cat >> createExtenralGsmCell.mo << MOSC
CREATE 
( 
 parent "ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4"
  identity $cellIdentity
  moType ExternalGsmCell 
  exception none 
  nrOfAttributes 12 
  ExternalGsmCellId String "$ExternalGsmCellId" 
  bandIndicator Integer 2
  bcc Integer $bcc
  bcchFrequency Integer $bcchFrequency
  cellIdentity Integer $cellIdentity
  lac Integer $lac
  ncc Integer $ncc
  userLabel String "$userLabel" 
) 

MOSC
count=`expr $count + 1`

done < $file

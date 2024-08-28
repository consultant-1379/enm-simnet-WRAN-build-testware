#!/bin/sh
##############################################################################
#Author                     :  zchianu
#
#Version                    :  1.1
#
#Purpose                    :  To create refs for GSM Proxies in UtranCells
##############################################################################


 ####################### this script creates ref value for gsm proxies that are created after deleting existing proxies , so make sure to check if all the existing gsm relations have externalgsmcellref value set , if not then reuse the externalGsmcell values on that RNC node to all the gsm relations of that RNC node ###########
if [ "$#" -ne 2 ]
then
cat<<HELP
####################
# HELP
####################

Usage  : $0 <Master RNC number> <Proxy ExternalGSMCells mofilename without extension>

Example: $0 RNC01 RNC01_createExternalGsmCell

HELP
exit 1
fi

RNC=$1
GSMPROXIES=$2

identity_values=`cat $RNC.mo | grep -B4 "externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4" | grep "identity" | tr -s " " | cut -d " " -f 3`
UtranCell_values=`cat $RNC.mo | grep -B1 "moType UtranCell" | grep "identity" | tr -s " " | cut -d" " -f 3`
externalgsmcell_values=`cat $GSMPROXIES.mo | grep "identity" | tr -s " " | cut -d " " -f 3`

read -a UtranCell_array <<< $UtranCell_values
echo ${#UtranCell_array[*]}
read -a identity_array <<< $identity_values
echo ${#identity_array[*]}
read -a externalgsmcell_array <<< $externalgsmcell_values
echo ${#externalgsmcell_array[*]}

count1=0
count3=0

for i in "${!externalgsmcell_array[@]}"
do
echo $count1
cat >> ExternalGsmCellRef.mo << MOSC
CREATE
(
 parent "ManagedElement=1,RncFunction=1,UtranCell=${UtranCell_array[$count1]}"
     identity ${identity_array[$count3]}
  moType GsmRelation
  exception none
        nrOfAttributes 1
             externalGsmCellRef Ref ManagedElement=1,RncFunction=1,ExternalGsmNetwork=4,ExternalGsmCell=${externalgsmcell_array[$count3]}
)
MOSC
((count3++))
if ! (( $count3 % 3 ))
then
((count1++))
fi
done

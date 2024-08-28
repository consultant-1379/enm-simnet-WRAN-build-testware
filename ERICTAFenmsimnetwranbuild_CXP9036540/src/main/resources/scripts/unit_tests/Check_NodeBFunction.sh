#!/bin/sh
##########################################################################################################################
# Created by  : zchianu
# Created on  : 30.09.2021
# Purpose     : Check if NodeBFunction is present on WCDMA nodes
###########################################################################################################################


SIM=$1

echo -e '.open '$SIM' \n .show simnes' | /netsim/inst/netsim_shell | grep "MSRBS-V2" | cut -d" " -f1 > NodeName.txt

while read n
do
NODENAME=$n
Value=`echo -e '.open '$SIM' \n .select '$NODENAME' \n .start \n e length(csmo:get_mo_ids_by_type(null, "Wrat:NodeBFunction")).'| /netsim/inst/netsim_shell | tail -1`


if [[ $Value == 0 ]]
then
echo "NodeBfunction is not present on $NODENAME"
elif [[ $Value == 1 ]]
then
echo "$NODENAME is correct"
fi

done < NodeName.txt



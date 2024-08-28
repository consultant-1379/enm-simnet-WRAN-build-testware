#!/bin/sh


rncName="RNC01"
rbs="RBS"
rbsNames=`echo ".selectregexp simne .*$rncName$rbs.*" | /netsim/inst/netsim_pipe -sim RNCV32391x1-FT-PRBS15Ax2-RBSU190x15-RXIx2-RNC01 | grep -i ".select " | awk -F" " '{print $3}'`;

rbsNamesArr=(`echo $rbsNames | sed -e "s/|/ /g"`)

echo $rbsNames

for i in "${rbsNamesArr[@]}"
do
	
	echo $i

done

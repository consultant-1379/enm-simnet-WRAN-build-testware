#!/bin/sh

##############################################################################
#Author                     :  zchianu
#
#Version                    :  1.1
#
#Purpose                    :  To create Utran Proxies on RNC node
##############################################################################


########################## this script is used to create UtranProxies i.e ExternalUtranCells as per the RNC's present in a network############
############## Run this script for every proxy mo file , example if a network has 3 rncs in it ( RNC01,RNC02,RNC03) then to create proxies for RNC01, first run the script with RNC02.mo as parameter this will create RNC02's proxies for RNC01. Next run the script with RNC03.mo as parameter this will create RNC03's proxies for RNC01, later verify and then change the .txt output files to .mo and load them on the node , make sure to first delete exsiting proxies and then populate new one's ###########
#### usage ####

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <RNCfile.mo>"
 echo
 echo "Example: $0 RNC01.mo"
 echo
 exit 1
fi

###################################

Mofile=$1

RNC_value=`echo $Mofile | cut -d"." -f1 | cut -c4,5`

if [[ $RNC_value =~ 0 ]]
then
RNCNUM=`echo $Mofile | cut -d"." -f1 | cut -c5`
RNCNAME=RNC0"$RNCNUM"
else
RNCNUM=$RNC_value
RNCNAME=RNC"$RNCNUM"
fi

echo $RNCNAME

################ Running commands to form the kertayle for ExternalUtranCell from Other MO ##############################

cat $Mofile | grep -A17 -B4 "moType UtranCell" > "$RNCNAME"_utranproxies.txt
sed -i 's/--/)/g' "$RNCNAME"_utranproxies.txt
echo ")" >> "$RNCNAME"_utranproxies.txt
sed -i 's/moType UtranCell/moType ExternalUtranCell/g' "$RNCNAME"_utranproxies.txt
sed -i '/iubLinkRef Ref/d' "$RNCNAME"_utranproxies.txt
sed -i '/serviceAreaRef Ref/d' "$RNCNAME"_utranproxies.txt
sed -i '/uraRef Array Ref/d' "$RNCNAME"_utranproxies.txt
sed -i '/tCell Integer/d' "$RNCNAME"_utranproxies.txt
sed -i 's/locationAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=/lac Integer /g' "$RNCNAME"_utranproxies.txt
sed -i 's/routingAreaRef Ref ManagedElement=1,RncFunction=1,LocationArea=.*,RoutingArea=/rac Integer /g' "$RNCNAME"_utranproxies.txt

############################################################################################################################

UtranCellcount=`cat $Mofile | grep "moType UtranCell" | wc -l`
count=1
while [[ $count -le $UtranCellcount ]]
do
var1=`cat "$RNCNAME"_utranproxies.txt | grep -m$count -A14 -B4 "moType ExternalUtranCell" | grep "cId" | awk -F"Integer " '{print $2}' | tail -1`
var2=`cat "$RNCNAME"_utranproxies.txt | grep -m$count -A14 -B4 "moType ExternalUtranCell" | grep "identity" | awk -F"identity " '{print $2}' | tail -1`
sed -i "s/identity $var2/identity $var1/g" "$RNCNAME"_utranproxies.txt
count=`expr $count + 1`
done

#############################################################################################################################
############ changing parent mo line as needed ###################################
sed -i 's/parent "ManagedElement=1,RncFunction=1"/parent "ManagedElement=1,RncFunction=1,IurLink='$RNCNUM'"/g' "$RNCNAME"_utranproxies.txt

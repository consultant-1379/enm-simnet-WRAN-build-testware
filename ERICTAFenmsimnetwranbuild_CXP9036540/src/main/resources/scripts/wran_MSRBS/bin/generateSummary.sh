#!/bin/sh
# Created by  : Harish Dunga
# Created in  : 13 08 2019
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To create MO Summary and LDN data for RNC
# Description :
# Date        : 13 08 2019
# Who         : Harish Dunga
###########################################
# Ver2        : Modified for ENM
# Purpose     : Removed MO summary support from this script
# Description :
# Date        : 27 01 2020
# Who         : Harish Dunga
###########################################
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2 ]
then
 echo "Please give proper Inputs ...!!"
 echo
 echo "Usage: $0 <sim name> <rnc num>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x10-RNC01 1"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !"
 echo "###################################################################"
 exit 1
fi
SIM=$1
RNCNUM=$2
if [ $RNCNUM -le 9 ]
then
   RNCNAME="RNC0"$RNCNUM
else
   RNCNAME="RNC"$RNCNUM
fi
# Subroutine ###############################################
getLdns() {
MOTYPE=$1
moidlist=`echo -e '.open '$SIM'\n.select '$RNCNAME'\ne csmo:get_mo_ids_by_type(null,"'$MOTYPE'").' | ~/inst/netsim_shell | tail -n+6`
moidstr=`echo $moidlist | tr -d ' '`
moidstr=`echo $moidstr | sed 's/[][]//g'`
echo $moidstr
}
#############################################################
# Main ###
moTypes="UtranCell,Fach,Rach,Pch,Hsdsch,GsmRelation"
moList=(${moTypes//,/ })
#moCountFile="/netsim/netsimdir/"$SIM"/SimNetRevision/Summary_"$SIM".csv"
rncLdnFile="/netsim/netsimdir/"$SIM"/SimNetRevision/LdnData.txt"
if [ -e $rncLdnFile ]
then
   rm $rncLdnFile
fi 
for moType in ${moList[@]}
do
  moIdlist=`getLdns $moType`
  if [[ $moIdlist == *"error"* ]]
  then
    count=0
  else
    moIds=(${moIdlist//,/ })
    count=${#moIds[@]}
    for moId in ${moIds[@]}
    do
       moLdn=`echo -e '.open '$SIM'\n.select '$RNCNAME'\ne csmo:mo_id_to_ldn(null,'$moId').' | ~/inst/netsim_shell | tail -n+6`
       echo $moLdn | sed 's/[][]//g' | sed 's/\"//g' >> $rncLdnFile
    done
  fi
  #echo "$moType=$count" >> $moCountFile
done

#!/bin/sh
# Created by  : Harish Dunga
# Created in  : 27 01 2020
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM
# Purpose     : To create MO Summary for Health Check
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
#############################################################
# Main ###
moCountFile="/netsim/netsimdir/"$SIM"/SimNetRevision/Summary_"$SIM".csv"
MO_DUMP_FILE="/netsim/"$RNCNAME"_moDump.txt"
dumpMML="/netsim/"$RNCNAME"_dump.mml"
if [ -e $moCountFile ]
then
   rm $moCountFile
fi
if [ -e $MO_DUMP_FILE ]
then
   rm $MO_DUMP_FILE
fi
if [ -e $dumpMML ]
then
   rm $dumpMML
fi
echo "RncName,No_of_cells,UtranCellRelations,GSMRelations,EutranFreqRelations,CoverageRelations,TotalRncMos,TotalSimMos,NumOfIpv4Nes,NumOfIpv6Nes,TotalNoOfNodes" >> $moCountFile
cat >> $dumpMML << MML
.open $SIM
.select $RNCNAME
.start
dumpmotree:moid="1",outputfile="$MO_DUMP_FILE";
MML
/netsim/inst/netsim_shell < $dumpMML
rm $dumpMML
###############################################################################################

No_of_cells=`cat $MO_DUMP_FILE | grep "UtranCell=" | grep -vi "External" | wc -l`
UtranCellRelations=`cat $MO_DUMP_FILE | grep "UtranRelation=" | grep -vi "External" | wc -l`
GSMRelations=`cat $MO_DUMP_FILE | grep "GsmRelation=" | wc -l`
EutranFreqRelations=`cat $MO_DUMP_FILE | grep "EutranFreqRelation=" | wc -l`
CoverageRelations=`cat $MO_DUMP_FILE | grep "CoverageRelation=" | wc -l`
TotalRncMos=`cat $MO_DUMP_FILE | grep "=" | wc -l`
TotalSimMos=0
TotalNoOfNodes=`ls /netsim/netsimdir/${SIM}/allsaved/dbs/ | wc -l`
NodeList=`ls /netsim/netsimdir/${SIM}/allsaved/dbs/ | cut -d"_" -f2`
Nodes=(${NodeList// / })

for Node in ${Nodes[@]}
do
   moCount=`echo -e '.open '$SIM'\n.select '$Node'\n.start\ndumpmotree:count;\n' | /netsim/inst/netsim_shell | tail -n+8 | grep -Ev "^$"`
   TotalSimMos=$(expr $moCount + $TotalSimMos )
done
NumOfIpv4Nes=$TotalNoOfNodes
NumOfIpv6Nes=0
echo $RNCNAME','$No_of_cells','$UtranCellRelations','$GSMRelations','$EutranFreqRelations','$CoverageRelations','$TotalRncMos','$TotalSimMos','$NumOfIpv4Nes','$NumOfIpv6Nes','$TotalNoOfNodes >> $moCountFile
rm $MO_DUMP_FILE

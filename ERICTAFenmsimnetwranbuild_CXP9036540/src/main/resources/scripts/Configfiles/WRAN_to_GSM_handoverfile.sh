#!/bin/sh
##### This script is to generate handover csv file with WRAN relations to include in GSM simulations ###########################

usage (){

echo "Usage  : $0 <RNC Mo file generated after running jar> "

echo "Example: $0 RNC04 RNC05 RNC06 ....."

}

########################################################################
#To check commandline arguments#
########################################################################
if [ $# -le 1 ]
then
usage
exit 1
fi
########################################################################
rowid=1
pcid=1
#Mofile=$1
for Mofile in "$@"
do
echo Mofile is $Mofile
RNCNUM=`echo "${Mofile: -2}"`
echo "RNc num is $RNCNUM"
################# gathering all the required attributes from the Mo file and storing them in separate file ###########################
cat $Mofile.mo | grep -B1 "moType UtranCell" | grep -v moType | awk -F"identity " '{print$2}' | sed -e '/^$/d' >> Cell_ID_$Mofile.txt
#cat $Mofile2.mo | grep -B1 "moType UtranCell" | grep -v moType | awk -F"identity " '{print$2}' | sed -e '/^$/d' >> Cell_ID.txt
#cat $Mofile3.mo | grep -B1 "moType UtranCell" | grep -v moType | awk -F"identity " '{print$2}' | sed -e '/^$/d' >> Cell_ID.txt
#TotalCellidCount=`cat Cell_ID_$Mofile.txt | wc -l`
#rowid=1
scr=1
#pcid=1
#####################################################################################################
while IFS= read -r cell_id;
do
echo " ****************** entering the values in Handover file from $Mofile ******************************"
CID=`cat $Mofile.mo | grep -A5 "identity $cell_id" | tail -1 | awk -F"Integer " '{print $2}'`
LAC_RAC=`cat $Mofile.mo | grep -A8 "identity $cell_id" | tail -1 | awk -F"RoutingArea=" '{print$2}'`
ARFCNVDL=`cat $Mofile.mo | grep -A12 "identity $cell_id" | tail -1 | awk -F"Integer " '{print $2}'`
UARFCNUL=`cat $Mofile.mo | grep -A13 "identity $cell_id" | tail -1 | awk -F"Integer " '{print $2}'`
#while [[ $rowid -le $TotalCellidCount ]]
#do
while [[ $scr -le 511 ]]
do
while [[ $pcid -le 511 ]]
do
echo "ROWID=$rowid;SCR=$scr;EXTUCFDDID=$cell_id;MUCID=$cell_id;USERLABEL=$cell_id;LAC=$LAC_RAC;PCID=$pcid;CID=$CID;RAC=$LAC_RAC;ARFCNVDL=$ARFCNVDL;RNCID=$RNCNUM;UARFCNUL=$UARFCNUL" >> WRANtoGRAN_handover.csv
rowid=`expr $rowid + 1`
scr=`expr $scr + 1`
pcid=`expr $pcid + 1`
if [[ $scr -gt 511 ]]
then
scr=0
fi
if [[ $pcid -gt 511 ]]
then
pcid=0
fi
break;
done 
break;
done
#break;
#done
done < Cell_ID_$Mofile.txt
done

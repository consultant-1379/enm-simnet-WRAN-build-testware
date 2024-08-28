#!/bin/bash


START=1
END=109

REPORTFILENAME="rbs6KReportForO16-ST-16B-50K.txt_new"
if [ -f $REPORTFILENAME ]
then
  rm $REPORTFILENAME
  echo "Existing $REPORTFILENAME deleted!!!"
fi

SIMNAME="RNCV53878-ST-RNC01"
ENV="O16B-ST-50K-DG2.env"

COUNT=$START
while [ "$COUNT" -le $END ]
do

  ./aOut1241_Rbs6k_createCabinet_Mix.sh $SIMNAME $ENV $COUNT >> $REPORTFILENAME

  COUNT=`expr $COUNT + 1`
done



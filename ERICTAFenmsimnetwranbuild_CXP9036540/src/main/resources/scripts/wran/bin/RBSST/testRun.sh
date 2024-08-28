#!/bin/bash


START=1
END=109

REPORTFILENAME="rbs6KReportForO14-ST-14B-50K.txt"
if [ -f $REPORTFILENAME ]
then
  rm $REPORTFILENAME
  echo "Existing $REPORTFILENAME deleted!!!"
fi

SIMNAME="RNCS1100-ST-RNC01"
ENV="O14-ST-14B-50K.env"

COUNT=$START
while [ "$COUNT" -le $END ]
do

  ./test_aOut1240createCabinet.sh $SIMNAME $ENV $COUNT >> $REPORTFILENAME

  COUNT=`expr $COUNT + 1`
done



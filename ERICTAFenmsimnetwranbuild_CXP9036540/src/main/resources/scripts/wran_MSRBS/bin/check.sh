#!/bin/sh
NUMOFDG2=100
RNCNAME="RNC01"
SIM=$1
NODESNAME=""
MMLSCRIPT=$0:${NOW}:$SIM".mml"
DENAME=""
counterLimit=`expr $NUMOFDG2 / 25`
echo $counterLimit
counter=1
dg2count=1
         while [[ $counter -lt $(($counterLimit + 1)) ]];
        do
                dg2countlimit=`expr $(($counter * 25)) + 1`
                #echo $dg2countlimit
                while [[ $dg2count -lt $dg2countlimit ]];
                 do

                 if [ "$dg2count" -le 9 ]
                then
                DG2NAME="MSRBS_V20"$dg2count
                else
                DG2NAME="MSRBS_V2"$dg2count
                fi
                NODESNAME+=$RNCNAME$DG2NAME" "
               #echo The inside counter is $dg2count
              dg2count=`expr $dg2count + 1`
        done
		 echo $NODESNAME
		echo "out of inside counter"
                echo '.open '$SIM >> $MMLSCRIPT
                echo '.select '$NODESNAME >> $MMLSCRIPT
                echo '.start -parallel' >> $MMLSCRIPT
                 echo '.stop'  >> $MMLSCRIPT
		NODESNAME=""
		counter=`expr $counter + 1`
done



#!/bin/sh

LIST=`ls -ltr /netsim/netsimdir/ |egrep 'RNC' | tr -s " " | cut -d " " -f 9 | grep -iv "zip"`

        for SIM in $LIST ; do
                echo $SIM
#.open ${SIM}
RNCNAME=`echo ${SIM} |  awk -F"-" '{print $NF}'`

#MOSCRIPT=$RNCNAME"setIpAttribute.mo"
MMLSCRIPT=$RNCNAME"setIpAttribute.mml"

if [ -f $PWD/$MMLSCRIPT ]
then
rm -r  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi


neType="PRBS"

COUNT=1



rbsNames=(`echo ".selectregexp simne .*$RNCNAME$neType.*" | /netsim/inst/netsim_pipe -sim $SIM | grep -i ".select " | awk -F" " '{print $3}' | sed -e "s/|/ /g"`);

for i in "${rbsNames[@]}"
do
	echo "Making MO script for "$i
        #MeContextMO=`echo "SubNetwork=ONRM_ROOT_MO_R,SubNetwork=$RNCNAME,MeContext=$i"`
        #echo $MeContextMO

       # IpAddress=`echo ".show started" | /netsim/inst/netsim_pipe | grep $i | awk -F" " '{print $2}'`
       # echo $IpAddress
	
#	MOSCRIPT=$i"setIpAttribute.mo"
#
#	if [ -f $PWD/$MOSCRIPT ]
#	then
#		rm -r  $PWD/$MOSCRIPT
#		echo "old "$PWD/$MOSCRIPT " removed"
#	fi

	



echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$i >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT

cat >> $MMLSCRIPT << MMLSCT
createmo:parentid="ManagedElement=$i,NodeBFunction=1",type="Iub",name="1";
setmoattribute:mo="ManagedElement=$i,NodeBFunction=1,Iub=1",attributes="rbsId=$COUNT";
setmoattribute:mo="ManagedElement=$i,SystemFunctions=1,Pm=1,PmMeasurementCapabilities=1",attributes="fileLocation=/c/pm_data/";

MMLSCT

echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT

#if [ "$SKIP_VERIFY_KERTAYLE" == "YES" ]
#then
#  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT
#else
#  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
#fi

COUNT=`expr $COUNT + 1`


done

#########################################
#
# Make MML Script
#
#########################################
#echo '.open '$SIM >> $MMLSCRIPT
#echo '.selectnocallback network' >> $MMLSCRIPT
#echo '.start ' >> $MMLSCRIPT
#echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT

#if [ "$SKIP_VERIFY_KERTAYLE" == "YES" ]
#then
#  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT
#else
#  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
#fi

/netsim/inst/netsim_pipe < $MMLSCRIPT

#rm $PWD/$MMLSCRIPT



done





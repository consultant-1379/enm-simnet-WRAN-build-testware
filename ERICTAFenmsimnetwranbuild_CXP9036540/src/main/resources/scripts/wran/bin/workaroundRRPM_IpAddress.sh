#!/bin/sh

LIST=`ls -ltr /netsim/netsimdir/ |egrep 'RNC' | tr -s " " | cut -d " " -f 8 | grep -iv "zip"`

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


neType="RBS"

rbsNames=(`echo ".selectregexp simne .*$RNCNAME$neType.*" | /netsim/inst/netsim_pipe -sim $SIM | grep -i ".select " | awk -F" " '{print $3}' | sed -e "s/|/ /g"`);

for i in "${rbsNames[@]}"
do
	echo "Making MO script for "$i
        #MeContextMO=`echo "SubNetwork=ONRM_ROOT_MO_R,SubNetwork=$RNCNAME,MeContext=$i"`
        #echo $MeContextMO

        IpAddress=`echo ".show started" | /netsim/inst/netsim_pipe | grep $i | awk -F" " '{print $2}'`
        echo $IpAddress
	
	MOSCRIPT=$i"setIpAttribute.mo"

	if [ -f $PWD/$MOSCRIPT ]
	then
		rm -r  $PWD/$MOSCRIPT
		echo "old "$PWD/$MOSCRIPT " removed"
	fi

	
        echo 'SET' >> $MOSCRIPT
	echo '(' >> $MOSCRIPT
	echo '  mo "ManagedElement=1,IpOam=1,Ip=1,IpHostLink=1"' >> $MOSCRIPT
	echo '   identity 1' >> $MOSCRIPT
	echo '   exception none' >> $MOSCRIPT
	echo '   nrOfAttributes 2' >> $MOSCRIPT
	echo '   ipAddress String '$IpAddress >> $MOSCRIPT
	echo '   ipv4Addresses Array String 1 '$IpAddress >> $MOSCRIPT
	echo ')' >> $MOSCRIPT

	 echo 'SET' >> $MOSCRIPT
        echo '(' >> $MOSCRIPT
        echo '  mo "ManagedElement=1,IpOam=1,Ip=1,IpRoutingTable=1"' >> $MOSCRIPT
        echo '   identity 1' >> $MOSCRIPT
        echo '   exception none' >> $MOSCRIPT
        echo '   nrOfAttributes 1' >> $MOSCRIPT
        echo '   "staticRoutes" Array Struct 1' >> $MOSCRIPT
	echo '   nrOfElements 6' >> $MOSCRIPT
	echo '   "indexOfStaticRoute" Integer 1' >> $MOSCRIPT
	echo '   "ipAddress" String '$IpAddress >> $MOSCRIPT
	echo '   "networkMask" String "255.255.255.0"' >> $MOSCRIPT
	echo '    "nextHopIpAddr" String "10.4.0.75"' >> $MOSCRIPT
	echo '     "redistribute" Boolean true' >> $MOSCRIPT
	echo '     "routeMetric" Integer 10' >> $MOSCRIPT
        echo ')' >> $MOSCRIPT



echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$i >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT

if [ "$SKIP_VERIFY_KERTAYLE" == "YES" ]
then
  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'",skip_verify=skip;' >> $MMLSCRIPT
else
  echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
fi




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





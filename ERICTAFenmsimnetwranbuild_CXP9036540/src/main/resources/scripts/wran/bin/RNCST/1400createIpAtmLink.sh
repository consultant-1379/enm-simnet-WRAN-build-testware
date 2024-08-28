#!/bin/sh


if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <env file> <rnc num>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)"
 echo
 exit 1
fi




SIMNAME=$1
ENV=$2


if [ "$3" -le 9 ]
then
RNCNAME="RNC0"$3
RNCCOUNT="0"$3
else
RNCNAME="RNC"$3
RNCCOUNT=$3
fi

PWD=`pwd`
source $PWD/../../dat/$ENV
source $PWD/../utilityFunctions.sh



PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`


MOSCRIPT=$0${NOW}".mo"
MMLSCRIPT=$0${NOW}".mml"

if [ -f $PWD/$MOSCRIPT ]
then
rm -r  $PWD/$MOSCRIPT
echo "old "$PWD/$MOSCRIPT " removed"
fi


if [ -f $PWD/$MMLSCRIPT ]
then
rm -r  $PWD/$MMLSCRIPT
echo "old "$PWD/$MMLSCRIPT " removed"
fi



#########################################
# 
# Make MO Script
#
#########################################

echo ""
echo "MAKING MO SCRIPT"
echo ""


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType Ip' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1,Ip=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType EthernetLink' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1,Ip=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType IpAtmLink' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1,Ip=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType IpRoutingTable' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType Ospf' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1,Ospf=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType OspfInterface' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT

echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1,Ospf=1"' >> $MOSCRIPT
echo '   identity 1' >> $MOSCRIPT
echo '   moType OspfArea' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
echo ')' >> $MOSCRIPT


NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

RBSCOUNT=1
while [ "$RBSCOUNT" -le "$NUMOFRBS" ]
do

VAR=1
while [ "$VAR" -le 2 ]
do 

 case "$VAR"
 in
  1) ID='"ManagedElement=1,TransportNetwork=1,Aal5TpVccTp=b'$RBSCOUNT'-x1"';;
  2) ID='"ManagedElement=1,TransportNetwork=1,Aal5TpVccTp=b'$RBSCOUNT'-x2"';;
 esac


echo 'CREATE' >> $MOSCRIPT
echo '(' >> $MOSCRIPT
echo '  parent "ManagedElement=1,IpOam=1,Ip=1"' >> $MOSCRIPT
echo '   identity '$RBSCOUNT'-'$VAR >> $MOSCRIPT
echo '   moType IpAtmLink' >> $MOSCRIPT
echo '   exception none' >> $MOSCRIPT
echo '   nrOfAttributes 0' >> $MOSCRIPT
#echo '   aal5TpVccTpId Ref '$ID >> $MOSCRIPT
echo ')' >> $MOSCRIPT

VAR=`expr $VAR + 1`
done

RBSCOUNT=`expr $RBSCOUNT + 1`
done


#########################################
#
# Make MML Script
#
#########################################

echo ""
echo "MAKING MML SCRIPT"
echo ""


echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$RNCNAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT




$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $MMLSCRIPT



#rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT






































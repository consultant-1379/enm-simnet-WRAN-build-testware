#!/bin/sh
if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: RNCV10304x1-FT-RBSU4630x23-RNC01"
 echo
 exit 1
fi

SIMNAME=$1
RbsStr=$(echo $SIMNAME | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
NUMOFRBS=(${RbsStr//-/ })
RncStr=(${SIMNAME//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM
echo "RNCNAME: $RNCNAME"
MMLSCRIPT=$SIMNAME"_externalNodeB.mml"
PWD=`pwd`

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

COUNT=1

while [ "$COUNT" -le "$NUMOFRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME"RBS0"$COUNT
else
NODENAME=$RNCNAME"RBS"$COUNT
fi
MOSCRIPT=$NODENAME"_External_Node.mo"
cat >> $MOSCRIPT << MOSC
CREATE
(   
       parent "ManagedElement=1,Equipment=1"
         identity 1
         moType ExternalNode
         exception none
      
)
MOSC
echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
~/inst/netsim_shell < $MMLSCRIPT
rm $PWD/$MOSCRIPT
rm $PWD/$MMLSCRIPT
COUNT=`expr $COUNT + 1`
done

#/bin/sh
echo "###################################################################"
echo "# $0 script started Execution"
echo "-------------------------------------------------------------------"

if [ "$#" -ne 2  ]
then
 echo
 echo "#************* Please give inputs correctly **********************#"
 echo
 echo "Usage: $0 <sim name> <envfile>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10 CONFIG.env"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

SIM=$1
ENV=$2

. ../../dat/$ENV
CURRDIR=$SIMDIR"/bin/OSSRC"
RNCNUM=$(echo $SIM | awk -F"RNC" '{print $3}')
NODE="RNC"$RNCNUM
NODELIST=$(echo -e '.open '$SIM'\n.show simnes' | /netsim/inst/netsim_shell | grep " RBS" | cut -d" " -f1)
NODES=(${NODELIST// / })
NUMOFNODES=${#NODES[@]}
COUNT=1
MOSCRIPT=$CURRDIR"/setDistAl2.mo"
if [ -e $MOSCRIPT ]
then
   rm $MOSCRIPT
fi
while [ $COUNT -le $NUMOFNODES ]
do
ID1="b"$COUNT"a1"
ID2="b"$COUNT"a2"
ID3="b"$COUNT"a3"
ID4="b"$COUNT"a4"
ID5="b"$COUNT"a5"
ID6="b"$COUNT"a6"
ID7="b"$COUNT"a7"
ID8="b"$COUNT"a8"
cat >> $MOSCRIPT << MOSC
SET
(
    mo "ManagedElement=1,TransportNetwork=1,Aal2Sp=1,Aal2Ap=$COUNT,Aal2PathDistributionUnit=1"
    exception none
    nrOfAttributes 1
    "aal2PathVccTpList" Array Ref 8
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID1
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID2
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID3
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID4
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID5
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID6
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID7
       ManagedElement=1,TransportNetwork=1,Aal2PathVccTp=$ID8
)
MOSC
COUNT=`expr $COUNT + 1`
done
echo -e '.open '$SIM'\n.select '$NODE'\n.start\nkertayle:file="'$MOSCRIPT'";' | /netsim/inst/netsim_shell
rm $MOSCRIPT

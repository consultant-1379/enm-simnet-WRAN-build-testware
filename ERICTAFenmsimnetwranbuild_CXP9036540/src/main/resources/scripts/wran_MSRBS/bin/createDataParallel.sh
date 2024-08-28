#!/bin/sh 

# Created by  : Fatih ONUR
# Created in  : 07 04 2011
##
### VERSION HISTORY
###########################################
# Ver5        : Modified for ENM
# Purpose     : Updating ControlPlaneTransport attribute in Iublink MO for RNCnode
# Description :
# Date        : 16 04 2021
# Who         : zchianu
################################################
####################################################################
# Version4    : LTE 19.17
# Revision    : CXP 903 6540-1-2
# Purpose     : Adding OAMAccesspoint Support for MSRBS nodes in RNC sims
# Description : creates IPV4Address MO and IPV6Address MO on 
#               the 80:20 for RV and 100:00 for MT
# Jira        : NSS-27634
# Date        : NOV 2019
# Who         : zyamkan
####################################################################
###########################################
# Ver1        : Moddified for TERE 11.2
# Purpose     : To create sims faster
# Description :
# Date        : 07 04 2011
# Who         : Fatih ONUR
###########################################
# Ver2        : Moddified for TERE 13A
# Purpose     : Node add/remove modularity added
# Description :
# Date        : 07 08 2012
# Who         : Fatih ONUR
###########################################
##########################################3
# Ver3        : Modified for DG2 node
# Purpose     : To include DG2 also in the sim design 
# Description : Along with RNC,RBS,RXI PICO is also include for SIM design 
# Date        : 2015.06.01
#Who	      : XRANDYA

if [ "$#" -ne 5  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <count> <env file> <RNC ProductData> <MSRBS ProductData>

Example: $0 RNCS1100-ST-RNC10 10 O13-ST-13A-40K.env CXP9021776/5:R2AA13 CXP9024418/12:R31A96

HELP

exit
fi

SIM=$1
COUNT=$2
ENV=$3
RNCPRODUCTDATA=$4
MSRBSPRODUCTDATA=$5

# Initilize the allBGP 
echo "" &
allBGP=$!
PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

echo "//"
echo "//..$SIM:$0 start at `date`" 

./makingmo.sh  | tee -a $SIMDIR"/log/"$SIM"-makingmo.log"

############### Assign Ips as per VM from freeips log ##################################

./AssignRNCip.sh $SIM | tee -a $SIMDIR"/log/"$SIM"-RNCAssignIp.log"

#######################################################################

if [ "$RADIO" != "YES" ]
then
  echo "//----$SIM:No Radio Layer Data populated!!"
fi

if [ $TRANSPORT == "YES" ] && [ $RESTORE_NE_DB_FOR_NO_TRANSPORT == "YES" ]
then
   echo -e ".select network \n .stop -parallel \n .restorenedatabase /netsim/netsimdir/$SIM/saved/dbs/noTransportConfigForSim" | /netsim/inst/netsim_pipe -sim $SIM -ne network
fi

if [ "$RNC_NODE_CREATION" == "YES" ] && [ "$RNC_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
 || ([ "$UPDATE" == "YES" ] && [ "$RNC_NODE_CREATION" == "NO" ] && [ "$RNC_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ])
then
 ./createRNCdata.sh $SIM $ENV $COUNT &

  createRNCdataBGP=$!
  allBGP=`echo $allBGP" "$createRNCdataBGP`
else
echo "else part in rnc"
  if [ "$RADIO" == "YES" ]; then echo "//-----$SIM:No RNC radio data populated!!"; fi
fi


wait $allBGP
allBGP=""

#### DG2 NODES
#
if [ "$DG2_NODE_CREATION" == "YES" ] && [ "$DG2_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
 || ([ "$UPDATE" == "YES" ] && [ "$DG2_NODE_CREATION" == "NO" ] && [ "$DG2_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ])
then
  NUMOFDG2=`getNumOfDG2 $COUNT $RNCDG2ARRAY`
  if [ $NUMOFDG2 -ne 0 ]
  then
    ./createDG2data.sh $SIM $ENV $COUNT &
    createDG2dataBGP=$!
    allBGP=`echo $allBGP" "$createDG2dataBGP`
  fi
 wait $allBGP
else
  if [ "$RADIO" == "YES" ]; then echo "//-----$SIM:No DG2 radio data populated!!";  fi
fi

#####End of DG2 data

############PICO NODES CREATION#######################

if [ "$PICO_NODE_CREATION" == "YES" ] && [ "$PICO_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
 || ([ "$UPDATE" == "YES" ] && [ "$PICO_NODE_CREATION" == "NO" ] && [ "$PICO_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ])
then
  NUMOFPICO=`getNumOfPICO $COUNT $RNCPICOARRAY`

  if [ $NUMOFPICO -ne 0 ]
  then
    ./createPICOdata.sh $SIM $ENV $COUNT &
    createPICOdataBGP=$!
    allBGP=`echo $allBGP" "$createPICOdataBGP`
  fi
else
  if [ "$RADIO" == "YES" ]; then echo "//-----$SIM:No PICO radio data populated!!";  fi
fi

##########END OF PICO NODE CREATION#####################

allBGP=""
#### Transport will be inserted here
#
if [ "$TRANSPORT" == "YES" ]
then
  #############################
  # START:RNC TRANSPORT LAYER
  #############################
  TRANSPORT_SCRIPT_ID=`getItemFromArray $COUNT $RNCTRANSPORTARRAY`

  if [ ! -z "$TRANSPORT_SCRIPT_ID" ] && [ $TRANSPORT_SCRIPT_ID -ne 0 ]
  then
    echo ""
    echo "$SIM: RNC TRANSPORT LAYER CREATION STARTED at "`date` | tee -a $SIMDIR"/log/"$SIM"-RNC-Transport.log"
    echo "" | tee -a $SIMDIR"/log/"$SIM"-RNC-Transport.log"

    cd $SIMDIR/bin/
    (./createRNC_Transport_Data.sh $SIM $ENV $COUNT  2>&1 | tee -a $SIMDIR"/log/"$SIM"-RNC-Transport.log")&
    BGP=$!
    allBGP=$allBGP" "$BGP
  else
    echo "//----$SIM:No RNC_Transport_Data populated!!"
  fi

  # END:RNC TRANSPORT LAYER
  #############################
  #echo "//...waiting for Transport Layer Data to be populated...`date`"
  wait $allBGP
else
  echo "//----$SIM:No Transport Layer Data populated!!"
fi
########################################
#Unrelate NEs for G2 querying
########################################
if [ "$G2Query" == "YES" ]
then
allBGP=""
  cd $SIMDIR/bin/
    ./unrelateNEs.sh $SIM $ENV $COUNT 
    BGP=$!
    allBGP=$allBGP" "$BGP
wait $allBGP
fi
 
#########################################
if [ "$SAVE_DATABASE_FOR_FULL_NETWORK_RECOVERY" == "YES" ]
then
  ./saveNetworkDB.sh $SIM fullNetworkConfigRecoveryForSim
fi

cd $SIMDIR/bin
if [ "$SAVE_AND_COMPRESS_SIMS" == "YES" ]
then
  ./filepull.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-FilePull.log"
  ./setRNC_JAR.sh $SIM $ENV $RNCPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ProductData.log"
  ./createRNCproductdata.sh $SIM $ENV $RNCPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ProductData.log"
  ./ControlPlaneMo.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ControlPlaneMO.log"
#./set_Cipher.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Cipher.log"
   sleep 5s
  ./createDG2Product.sh $SIM $ENV $COUNT $MSRBSPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ProductData.log"
  #./set_RNCSubrack.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-RNCSubrack.log"
  ./UtranCellDataFile.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-Utranfile.log"
  ./createCounters.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Transport.log"
  ./set_RNCSubrack.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-RNCSubrack.log"
  ./set_OAMAccessPoint.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-OAMAccess.log"
  ./generateSummary.sh $SIM $COUNT 2>&1
  ./generateHealthCheckSummary.sh $SIM $COUNT 2>&1
 if [ "$MIXEDREQ" == "YES" ]
 then
  perl mixedModeDg2.pl $SIM $COUNT $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-LratMixedMode.log"
  ./mixedmodegrat.sh $SIM $COUNT $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-GratMixedMode.log"
 fi
 ./Dg2_Cipher.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Cipher.log"
 ./saveAndCompressSimulation.sh $SIM $ENV NO
 ./Implement_Scanner.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Scanner.log"
fi

if [ "$SAVE_DATABASE_FOR_NO_TRANSPORT" == "YES" ] && [ "$RADIO" == "YES" ] 
then
  ./saveNetworkDB.sh $SIM noTransportConfigForSim
fi


if [ "$UPLOAD_TO_FTP" == "YES" ]
then
  ./ftp.sh $SIM $ENV 
fi


echo "//"
echo "//..$SIM:$0 end at `date`" 

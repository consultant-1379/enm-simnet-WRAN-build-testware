#!/bin/sh 

# Created by  : Fatih ONUR
# Created in  : 07 04 2011
##
### VERSION HISTORY
###########################################
# Ver4        : Modified for ENM
# Purpose     : Updating ControlPlaneTransport attribute in Iublink MO for RNCnode
# Description :
# Date        : 16 04 2021
# Who         : zchianu
###########################################
##################################################################################
# Version     : 3
# Revision    : CXP 903 6540-1-1
# Author      : zchianu
# JIRA        : NSS-27832
# Description : Updating Ciphers for RNC and RBS nodes .
# Date        : 07 November 2019
####################################################################################
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




if [ "$#" -ne 5  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <count> <env file> <RNC ProductData> <RBS ProductData>

Example: $0 RNCS1100-ST-RNC10 10 O13-ST-13A-40K.env CXP9021776/5:R2AA13 CXP9024418/12:R31A96

HELP

exit
fi

SIM=$1
COUNT=$2
ENV=$3
RNCPRODUCTDATA=$4
RBSPRODUCTDATA=$5

# Initilize the allBGP 
echo "" &
allBGP=$!
PWD=`pwd`

source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh



#LOGFILE=$SIMDIR/log/${PROJECT}_$NOW.log


echo "//"
echo "//..$SIM:$0 start at `date`" 

./makingmo.sh  | tee -a $SIMDIR"/log/"$SIM"-makingmo.log"

############### Assign Ips as per VM from freeips log ##################################

./AssignIp_AsperVM.sh $SIM | tee -a $SIMDIR"/log/"$SIM"-FinalAssignIp.log"

#######################################################################

if [ "$RADIO" != "YES" ]
then
  echo "//----$SIM:No Radio Layer Data populated!!"
fi

if [ $TRANSPORT == "YES" ] && [ $RESTORE_NE_DB_FOR_NO_TRANSPORT == "YES" ]
then
   echo -e ".select network \n .stop -parallel \n .restorenedatabase /netsim/netsimdir/$SIM/saved/dbs/noTransportConfigForSim" | /netsim/inst/netsim_pipe -sim $SIM -ne network
fi



  if [ "$RBS_NODE_DATA_CREATION" == "YES" ] && [ "$RADIO" == "YES" ]
  then
     ( ./startSimulations.sh $SIM 2>&1 ) &
     wait $!
     EXIT_CODE=$?
     echo "$SIM:EXIT_CODE=$EXIT_CODE"
     if [[ $EXIT_CODE -ne 0 ]]
     then
         echo "$SIM:..\"starting\" error occured on `date`"
         #echo "$SIM:..exiting due to \"starting\" error on `date`"
         #exit 123
     fi
  fi

#### RXI NODES
#
if [ "$RXI_NODE_CREATION" == "YES" ] && [ "$RXI_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
 || ([ "$UPDATE" == "YES" ] && [ "$RXI_NODE_CREATION" == "NO" ] && [ "$RXI_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ])
then
  NUMOFRXI=`getItemFromArray $COUNT $NUMOFRXIARRAY`
  if [ $NUMOFRXI -ne 0 ]
  then
    ./createRXIdata.sh $SIM $ENV $COUNT &
    createRXIdataBGP=$!
    allBGP=`echo $allBGP" "$createRXIdataBGP`
  fi
else
  if [ "$RADIO" == "YES" ]; then echo "//-----$SIM:No RXI radio data populated!!";  fi
fi

#### PICO NODES
#
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


#### RBS NODES
#
if [ "$RBS_NODE_CREATION" == "YES" ] && [ "$RBS_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
 || ([ "$UPDATE" == "YES" ] && [ "$RBS_NODE_CREATION" == "NO" ] && [ "$RBS_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ])
then
  ./createRBSdata.sh $SIM $ENV $COUNT &
  createRBSdataBGP=$!
  allBGP=`echo $allBGP" "$createRBSdataBGP`
else
  if [ "$RADIO" == "YES" ]; then echo "//-----$SIM:No RBS radio data populated!!"; fi
fi


#### RNC NODES
#
#if [ "$RNC_NODE_CREATION" == "YES" ] && [ "$RNC_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
#  || ([ "$UPDATE" == "YES" ] && [ "$RNC_NODE_CREATION" == "NO" ])
#then
#  echo "RNCTEST=pass"
#fi
if [ "$RNC_NODE_CREATION" == "YES" ] && [ "$RNC_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ] \
 || ([ "$UPDATE" == "YES" ] && [ "$RNC_NODE_CREATION" == "NO" ] && [ "$RNC_NODE_DATA_CREATION" != "NO" ] && [ "$RADIO" == "YES" ])
then
 ./createRNCdata.sh $SIM $ENV $COUNT &
  createRNCdataBGP=$!
  allBGP=`echo $allBGP" "$createRNCdataBGP`
else
  if [ "$RADIO" == "YES" ]; then echo "//-----$SIM:No RNC radio data populated!!"; fi
fi


wait $allBGP
allBGP=""


if [ "$SAVE_DATABASE_FOR_NO_TRANSPORT" == "YES" ] && [ "$RADIO" == "YES" ] 
then
  ./saveNetworkDB.sh $SIM noTransportConfigForSim
fi


#### Transport will be inserted here
#
if [ "$TRANSPORT" == "YES" ]
then

  #############################
  # START:RNC TRANSPORT LAYER
  #############################
  TRANSPORT_SCRIPT_ID=`getItemFromArray $COUNT $RNCTRANSPORTARRAY`
  #echo "TRANSPORT_SCRIPT_ID="$TRANSPORT_SCRIPT_ID
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

  #############################
  # START:RBS TRANSPORT LAYER
  #############################
  TRANSPORT_SCRIPT_ID=`getItemsFromArray $COUNT $RBSTRANSPORTARRAY`
  #echo "RBS TRANSPORT_SCRIPT_ID="$TRANSPORT_SCRIPT_ID
  if [ ! -z "$TRANSPORT_SCRIPT_ID" ] && [ "$TRANSPORT_SCRIPT_ID" != "0" ]
  then
    echo ""
    echo "$SIM:RBS TRANSPORT LAYER CREATION STARTED at "`date` | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"
    echo ""  | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log"

    cd $SIMDIR/bin/
    (./createRBS_Transport_Data.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-RBS-Transport.log")&
    BGP=$!
    allBGP=$allBGP" "$BGP
  else
    echo "//----$SIM:No RBS_Transport_Data populated!!"
  fi

  # END:RBS TRANSPORT LAYER
  #############################

  #############################
  # START:RXI TRANSPORT LAYER
  #############################
  TRANSPORT_SCRIPT_ID=`getItemFromArray $COUNT $RXITRANSPORTARRAY`
  #echo "TRANSPORT_SCRIPT_ID="$TRANSPORT_SCRIPT_ID
  if [ ! -z "$TRANSPORT_SCRIPT_ID" ] && [ $TRANSPORT_SCRIPT_ID -ne 0 ]
  then
    echo ""
    echo "$SIM:RXI TRANSPORT LAYER CREATION STARTED at "`date` | tee -a $SIMDIR"/log/"$SIM"-RXI-Transport.log"
    echo ""  | tee -a $SIMDIR"/log/"$SIM"-RXI-Transport.log"

    cd $SIMDIR/bin/
    (./createRXI_Transport_Data.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-RXI-Transport.log")&
    BGP=$!
    allBGP=$allBGP" "$BGP
  else
    echo "//----$SIM:No RXI_Transport_Data populated!!"
  fi

  # END:RXI TRANSPORT LAYER
  #############################

  #echo "//...waiting for Transport Layer Data to be populated...`date`"
  wait $allBGP

else
  echo "//----$SIM:No Transport Layer Data populated!!"
fi


if [ "$SAVE_DATABASE_FOR_FULL_NETWORK_RECOVERY" == "YES" ]
then
  ./saveNetworkDB.sh $SIM fullNetworkConfigRecoveryForSim
fi

cd $SIMDIR/bin/RBSST/
./createCabinet.sh $SIM $ENV $COUNT   | tee -a $SIMDIR"/log/"$SIM"-RBS-1.log"
echo "************************************"
echo "deleting .mo's and .mml's from ~/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/RBSST directory."
echo "***********************************************************"
cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/RBSST
rm -rf *.mo
rm -rf *.mml
rm -rf DELETE_ALL_MO_SCRIPTS_RNCV*



cd $SIMDIR/bin

./setRNC_JAR.sh $SIM $ENV $RNCPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ProductData.log"
./createRNCproductdata.sh $SIM $ENV $RNCPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ProductData.log"
./ControlPlaneMo.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ControlPlaneMO.log"
#./set_RNCSubrack.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-RNCSubrack.log"

if [ "$RBS_NODE_CREATION" == "YES" ]
then
  ./externalnode.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ExternalNode.log"
  ./createRBSproductdata.sh $SIM $ENV $RBSPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-ProductData.log"
  ./set_DeviceGroup.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-DeviceGroup.log"
  ./set_subrackProduct.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Subrackproduct.log"
  ./SecondSwInventory.sh $SIM $ENV $RBSPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-SecondlevelProductData.log"
  ./UIanalyser2.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-UIanalyser.log"
  ./rbsid.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-rbsid.log"
fi
./createCounters.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-TransportCounters.log"
./setSftp.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-SHMsetup.log"
#./set_Cipher.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Cipher.log"
./Updated_Cipher.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Cipher.log"
sleep 5s
./Utrancelldatafile.sh $SIM $ENV $COUNT | tee -a $SIMDIR"/log/"$SIM"-Utranfile.log"
./set_RNCSubrack.sh $SIM $ENV 2>&1 | tee -a $SIMDIR"/log/"$SIM"-RNCSubrack.log"
./generateSummary.sh $SIM $COUNT 2>&1
./generateHealthCheckSummary.sh $SIM $COUNT 2>&1
#if [-f output.txt ]
#then
#./rbslocal.sh $SIM output.txt | tee -a $SIMDIR"/log/"$SIM"-rbsutranfile.log"
#else
#echo "no input file"| tee -a $SIMDIR"/log/"$SIM"-rbsutranfile.log"
#fi
if [ "$PICO_NODE_CREATION" == "YES" ]
then
  ./createPICOproductData.sh $SIM $ENV $COUNT $RBSPRODUCTDATA 2>&1 | tee -a $SIMDIR"/log/"$SIM"-PicoProduct.log"
  ./setPicoPmFilelocation.sh $SIM $ENV $COUNT 2>&1 | tee -a $SIMDIR"/log/"$SIM"-PicoPmLocation.log"
  ./Utrancelldatafile_PICO.sh $SIM $ENV $COUNT 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Utrancellfile.log"
fi

if [ "$MIXEDMODEREQ" == "YES" ]
then
./mixedmodepico.pl $SIM $COUNT 2>&1 | tee -a $SIMDIR"/log/"$SIM"-PicoMixedmode.log"
fi


if [ "$SAVE_AND_COMPRESS_SIMS" == "YES" ]
then
  ./saveAndCompressSimulation.sh $SIM $ENV NO
  ./Implement_Scanner.sh $SIM 2>&1 | tee -a $SIMDIR"/log/"$SIM"-Scanner.log"
fi


if [ "$UPLOAD_TO_FTP" == "YES" ]
then
  ./ftp.sh $SIM $ENV 
fi



echo "//"
echo "//..$SIM:$0 end at `date`" 






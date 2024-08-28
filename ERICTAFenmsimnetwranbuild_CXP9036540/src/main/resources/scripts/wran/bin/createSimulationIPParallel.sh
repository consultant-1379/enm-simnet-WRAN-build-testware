#!/bin/sh


##########################################3
# Ver3        : Modified for PICO node
# Purpose     : To include PICO also in the sim design
# Description : Along with RNC,RBS,RXI PICO is also include for SIM design
# Date        : 2013.08.06
# Who         : EAGACHI



if [ "$#" -ne 5 ]
then
 echo "This will create a simulation and the NEs as defined in the env file"
 echo
 echo "Usage: $0 <sim name> <count> <env file> <RNC ProductData> <RBS ProductData> "
 echo
 echo "Example: $0 RNCS1100-ST-RNC10 10 O13-ST-13A-40K.env CXP9021776/5:R2AA13 CXP9024418/12:R31A96"
 echo
 exit 1
fi


SIM=$1
RNCCOUNT=$2
ENV=$3
RNCPRODUCTDATA=$4
RBSPRODUCTDATA=$5

PWD=`pwd`
source $PWD/../dat/$ENV
source $PWD/utilityFunctions.sh

if [ "$RNCCOUNT" -le 9 ]
then
  RNCNAME="RNC0"$RNCCOUNT
else
  RNCNAME="RNC"$RNCCOUNT
fi

SCRIPTNAME=`basename "$0"`

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MMLSCRIPT=$0:${NOW}:$SIM".mml"

if [ -f $PWD/$MMLSCRIPT ]
then
  rm -r  $PWD/$MMLSCRIPT
  echo "old $MMLSCRIPT  removed"
fi

#LOGFILE=$LOG
echo "//..$0:$RNCNAME started at `date`" #| tee -a $LOGFILE
echo "//"


if [ $UPDATE == "NO" ]
then

	OFFSET_FOR_RNC=`getStartIP $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY $RNCPICOARRAY`
	NUMOFRBS=`getNumOfRBS $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`

	echo "//...$SIM is being created..."
        createSim $SIM >> $MMLSCRIPT
	#/netsim/inst/netsim_pipe < $MMLSCRIPT
	#rm $PWD/$MMLSCRIPT
	#exit

  CmdResult=`cat $MMLSCRIPT | /netsim/inst/netsim_pipe | tail -n 1`
  rm $PWD/$MMLSCRIPT

  if [ "$CmdResult" == "OK" ]
  then
     echo "//...$SIM created successfully."
  else
     echo -e "  //----$SIM:ERROR!!\n"\
           "  //-----No new simulation is created\n"\
           "  //----...exiting!! on `date`\n"\
           "  //----See the output\n"\
           "  //----ERROR: \"$CmdResult\"\n"\
           "  //----SOLUTION: Please make sure that no any gui is open! Rerrun the ## $SCRIPTNAME ## script."
       exit 123
  fi

	if [ "$RNC_NODE_CREATION" == "YES" ]
	then
		RNCVERSION=`getMimType $RNCCOUNT $RNCVERSIONARRAY`
		createRNCip $SIM $PORT $RNCCOUNT $RNCVERSION $OFFSET_FOR_RNC >> $MMLSCRIPT
                createRNCip $SIM $PORT $RNCCOUNT $RNCVERSION $OFFSET_FOR_RNC >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/log/rncip.log
	else
		echo " For:$SIM no RNCNODE is created"
	fi

	######RBS CREATION#####

	if [ "$RBS_NODE_CREATION" == "YES" ]
	then
		OFFSET_FOR_RBS=`expr $OFFSET_FOR_RNC + 1`
		RBSVERSION=`getMimType $RNCCOUNT $RBSVERSIONARRAY`
		createNodeip $SIM $PORT RBS $NUMOFRBS $RBSVERSION $OFFSET_FOR_RBS >> $MMLSCRIPT
	       createNodeip $SIM $PORT RBS $NUMOFRBS $RBSVERSION $OFFSET_FOR_RBS >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/log/rbsip.log
       else
		
		echo " For:$SIM no RBSNODES are created "
	fi

	######RXI CREATION#####

	if [ "$RXI_NODE_CREATION" == "YES" ]
	then
		NUMOFRXI=`getItemFromArray $RNCCOUNT $NUMOFRXIARRAY`
		if [ $NUMOFRXI -ne 0 ]
		then
			OFFSET_FOR_RXI=`expr $OFFSET_FOR_RNC + 1 + $NUMOFRBS`
			RXIVERSION=`getMimType $RNCCOUNT $RXIVERSIONARRAY`
			createNodeip $SIM $PORT RXI $NUMOFRXI $RXIVERSION $OFFSET_FOR_RXI >> $MMLSCRIPT
		else
			echo " For:$SIM no RXINODES are created"
		fi
	else
		NUMOFRXI=0
		echo " For:$SIM no RXINODES are created"
	fi

        ######PICO CREATION#####

        if [ "$PICO_NODE_CREATION" == "YES" ]
        then

                NUMOFPICO=`getNumOfPICO $RNCCOUNT $RNCPICOARRAY`
                echo "no of pico is $NUMOFPICO"
                if [ "$NUMOFPICO" != 0 ]
                then
                        OFFSET_FOR_PICO=`expr $OFFSET_FOR_RNC + 1 + $NUMOFRXI + $NUMOFRBS`
                        PICOVERSION=`getMimType $RNCCOUNT $PICOVERSIONARRAY`
echo "CreateNodeIp $SIM $pRBS_PORT PRBS $NUMOFPICO $PICOVERSION $OFFSET_FOR_PICO" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/log/TEST.log
                        createNodeip $SIM $pRBS_PORT PRBS $NUMOFPICO $PICOVERSION $OFFSET_FOR_PICO >> $MMLSCRIPT
                else
                        echo " For:$SIM no PRBSNODES are created"
                fi
        else
                echo " For:$SIM no PRBSNODES are created"
        fi
  

  relateNEs $SIM $RNCNAME >> $MMLSCRIPT

  #
  ## Pass MML commands into netsim_pipe to run
  #
  /netsim/inst/netsim_pipe < $MMLSCRIPT
  rm $PWD/$MMLSCRIPT
fi


if [ "$RXI_NODE_DATA_CREATION" == "NO" -a "$RBS_NODE_DATA_CREATION" == "NO" -a "$RNC_NODE_DATA_CREATION" == "NO" -a "$PICO_NODE_DATA_CREATION" == "NO" ]
then
  echo "//...$SIM:No any data created/updated!!"

  if [ "$SAVE_AND_COMPRESS_SIMS" == "YES" ]
  then

   if [ "STOP_ALL_SIMS" == "YES" ]
   then
     ./saveAndCompressSimulation.sh $SIM $ENV STOP
    else
     ./saveAndCompressSimulation.sh $SIM $ENV NOSTOP
   fi
  fi


else
  (./createDataParallel.sh $SIM $RNCCOUNT $ENV $RNCPRODUCTDATA $RBSPRODUCTDATA 2>&1 ) 
fi


echo "//" 
echo "//..$0:$RNCNAME ended at `date`" 


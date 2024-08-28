#!/bin/bash 

# Created by  : Fatih ONUR
# Created in  : 18.04.2011
##
### VERSION HISTORY
# Ver1        : Created for faster sim creation
# Purpose     :
# Description :
# Date        : 18 APR 2011
# Who         : Fatih ONUR
##########################################3
# Ver2        : Modified for faster sim creation
# Purpose     : New parelel mechanism added 
# Description : As many as scripts can be created concurrently
# Date        : 2013.03.01
# Who         : Fatih ONUR

##########################################3
# Ver3        : Modified for PICO node
# Purpose     : To include PICO also in the sim design 
# Description : Along with RNC,RBS,RXI PICO is also include for SIM design 
# Date        : 2013.08.06
# Who         : EAGACHI




if [ "$#" -ne 4 ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <env file> <Sim Name> <RNC ProductData> <RBS ProductData>

Example: $0 O13-ST-13A-50K.env RNCV15439x1-FT-RBSU41000x23-RNC01 CXP9021776/5:R2AA13 CXP9024418/12:R31A96

DESCRP : This will create a new simulation and the NEs as defined  in the env file
HELP

exit 1
fi


################################
# Assign variables
################################

ENV=$1
SIMNAME=$2
RNCPRODUCTDATA=$3
RBSPRODUCTDATA=$4
DATE=`date +%H%M%S`
PWD=`pwd`
#CURR=`pwd`
#################################
# fetching free ip's and storing in a file
#################################
if [ -f "availableip.txt" ]
then
echo "removing already existing availableip text file"
rm -rf availableip.txt
touch availableip.txt
echo "Gathering freeips on the server in availableip.txt file"
./Get_Freeip.sh
else
touch availableip.txt
echo "Gathering freeips on the server in availableip.txt file"
./Get_Freeip.sh
fi


##############################
# Check env file exists
##############################

if [ ! -f ../dat/$ENV ]
then
 echo "The configuration file $ENV does not exist."
 exit 1
fi


#########################################
# Check that the user does not assume he
# can control where to put simulations
#########################################

if [ -n "$NETSIMDIR" ]; then
    # *** Note *** 
    # Assuming simulations are stored in default dir $HOME/netsimdir
    echo "Use of NETSIMDIR other than the default is currently not"
    echo "supported (current value: $NETSIMDIR)"
    echo "SimGen assumes that simulations are saved in $HOME/netsimdir."
    exit 1
fi


################################
# Source env file
################################

NOW=`date +"%Y_%m_%d_%T:%N"`
PWD=`pwd`
source $PWD/../dat/$ENV
#LOGFILE=$SIMDIR/log/${PROJECT}_$NOW.log
LOGFILE=$SIMDIR/log/$NOW.log
LOGFILE=`echo $LOGFILE | sed "s/root/netsim/g"`
source $PWD/utilityFunctions.sh


getSimname() # RNCnumber 
{
     if [ "$1" -le 9 ]
     then
	 echo "$SIMBASE"-RNC0"$1"
     else
	 echo "$SIMBASE"-RNC"$1"
     fi
}


checkExistingSimulation() #Simname
{
 if [ -f "$HOME/netsimdir/$1.zip" ]; then
     # *** Note *** 
     # Assuming simulations are stored in default dir $HOME/netsimdir
     echo "Simulation $HOME/netsimdir/$1.zip"
     echo "already exists. Delete it and run again."
     exit 2
 fi
}

getSimNamingConvention()
{
	COUNT=$1

	RNCVERSION=`getMimType $COUNT $RNCVERSIONARRAY`
        RBSVERSION=`getMimType $COUNT $RBSVERSIONARRAY`
        RXIVERSION=`getMimType $COUNT $RXIVERSIONARRAY`
        PICOVERSION=`getMimType $COUNT $PICOVERSIONARRAY`

        NUMOFRXI=`getItemFromArray $COUNT $NUMOFRXIARRAY`
        NUMOFRBS=`getNumOfRBS $COUNT $RNCRBSARRAY $RBSCELLARRAY`
        NUMOFPICO=`getNumOfPICO $COUNT $RNCPICOARRAY`

    if [ "$NEW_SIM_NAMING_CONVETION" == "YES" ] 
    then
	
		SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-ST"
		SIMBASE="${SIMBASE}-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x${NUMOFRBS}"

		if [ "$NUMOFRXI" -ne "0" ]
		then
			SIMBASE="${SIMBASE}-RXI"$(echo $RXIVERSION | awk -F"-" '{print $1}')"x${NUMOFRXI}"
		fi

		if [ "$NUMOFPICO" -ne "0" ]
		then
			SIMBASE="${SIMBASE}-PICO"$(echo $PICOVERSION | awk -F"-" '{print $1}')"x${NUMOFPICO}"
		fi
	  	  
		SIM=$SIMBASE"-RNC"`printf "%03d" "$COUNT"`  
		  
   # else
		#SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"-ST"
		
	#	SIM=$SIMBASE"-RNC"`printf "%02d" "$COUNT"`
		
    fi
if [ "$DELIVERYTYPE" == "ENM" ]
then
    if [ "$PICO_NODE_CREATION" == "YES" ] && [ "$RBS_NODE_CREATION" == "YES" ] && [ "$RXI_NODE_CREATION" == "YES" ]
    then
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-PRBS"$(echo $PICOVERSION | awk -F"-" '{print $1}')"x"$NUMOFPICO"-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x"$NUMOFRBS"-RXI"$RXIVERSION"x2"
    elif [ "$PICO_NODE_CREATION" == "YES" ] && [ "$RBS_NODE_CREATION" == "YES" ] && [ "$RXI_NODE_CREATION" != "YES" ]
    then
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-PRBS"$(echo $PICOVERSION | awk -F"-" '{print $1}')"x"$NUMOFPICO"-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x"$NUMOFRBS
    elif [ "$PICO_NODE_CREATION" == "YES" ] && [ "$RBS_NODE_CREATION" != "YES" ] && [ "$RXI_NODE_CREATION" == "YES" ]
    then
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-PRBS"$(echo $PICOVERSION | awk -F"-" '{print $1}')"x"$NUMOFPICO"-RXI"$RXIVERSION"x2"
    elif [ "$PICO_NODE_CREATION" == "YES" ] && [ "$RBS_NODE_CREATION" != "YES" ] && [ "$RXI_NODE_CREATION" != "YES" ]
    then
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-PRBS"$(echo $PICOVERSION | awk -F"-" '{print $1}')"x"$NUMOFPICO
    elif [ "$PICO_NODE_CREATION" != "YES" ] && [ "$RBS_NODE_CREATION" == "YES" ] && [ "$RXI_NODE_CREATION" == "YES" ]
    then
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x"$NUMOFRBS"-RXI"$RXIVERSION"x2"
    elif [ "$PICO_NODE_CREATION" != "YES" ] && [ "$RBS_NODE_CREATION" == "YES" ] && [ "$RXI_NODE_CREATION" != "YES" ]
    then
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x"$NUMOFRBS
    else
        SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-RXI"$RXIVERSION"x2"
    fi
    if [ "$COUNT" -le 9 ]
    then
        SIM=$SIMBASE"-RNC0"$COUNT
    else
        SIM=$SIMBASE"-RNC"$COUNT
    fi
else
    if [ "$NAMING_CONVENTION" == "FT" ]
    then
	if [ "$NUMOFPICO" != 0 -a ! -z "$PICOVERSION" ]
        then
                SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-PRBS"$(echo $PICOVERSION | awk -F"-" '{print $1}')"x"$NUMOFPICO"-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x"$NUMOFRBS"-RXI"$RXIVERSION"x2"
        else
                SIMBASE="RNC"$(echo $RNCVERSION | awk -F"-" '{print $1}')"x1-FT-RBS"$(echo $RBSVERSION | awk -F"-" '{print $1}')"x"$NUMOFRBS"-RXI"$RXIVERSION"x2"
        fi	
        if [ "$COUNT" -le 9 ]
        then
            SIM=$SIMBASE"-RNC0"$COUNT
        else
            SIM=$SIMBASE"-RNC"$COUNT
        fi

   fi
fi
	echo $SIM
	
}


#
## catch control-c keyboard interrupts
#
control_c()
{
  echo -en "\n*** Ouch! Exiting ***\n"
  /bin/ps -eaf | grep "$ENV" | grep -v grep | awk '{print $2}' | xargs kill -9
  exit $?
}

################################
# Main program
################################

# trap keyboard interrupt (control-c)
trap control_c SIGINT


# Initilize the allBGP
echo "" &
allBGP=$!

PWD=`pwd`

rm -rf $SIMDIR/log/*.log

rm -rf $PWD/*.mml

rm -rf $PWD/RNCST/*.mo
rm -rf $PWD/RNCST/*.mml

rm -rf $PWD/RBST/*.mo
rm -rf $PWD/RBST/*.mml

rm -rf $PWD/RXIST/*.mo
rm -rf $PWD/RXIST/*.mml

#rm -rf $PWD/PICOST/*.mo
#rm -rf $PWD/PICOST/*.mml
rm -rf PIDS.log
echo " "


echo "$0: started `date`" | tee -a $LOGFILE
echo "$0: started `date`" > PIDS.log

# Just check the first simulation
checkExistingSimulation `getSimname $RNCSTART`


  #MAX_CONCURRENT_NUM_OF_JOBS=20  # comes from ENV file 
  CURRENT_NUM_OF_JOBS=0
  TOTAL_NUM_OF_JOBS=`expr $RNCEND - $RNCSTART + 1`
  TOTAL_NUM_OF_JOBS_COMPLETED=0
  TOTAL_NUM_OF_JOBS_LEFT=0
  EXIT_CODES=''
  FINISHED_JOBS=''
  PIDS=''
  BGP_OUTPUT_ARRAY=()

  COUNT=$RNCSTART
  if [ $TOTAL_NUM_OF_JOBS -ge $MAX_CONCURRENT_NUM_OF_JOBS ]
  then
    STOP=`expr $COUNT + $MAX_CONCURRENT_NUM_OF_JOBS - 1`
    TOTAL_NUM_OF_JOBS_LEFT=`expr $TOTAL_NUM_OF_JOBS - $MAX_CONCURRENT_NUM_OF_JOBS`
  else
    STOP=$RNCEND 
    TOTAL_NUM_OF_JOBS_LEFT=$TOTAL_NUM_OF_JOBS
  fi

  while [ "$COUNT" -le "$STOP" ]
  do
    
	SIM=`getSimNamingConvention $COUNT`

   echo " ***************************" >> $LOGFILE
   echo " *      $SIM               *" >> $LOGFILE
   echo " ***************************" >> $LOGFILE   
 if [ $SIM == $SIMNAME ]
 then
 #( ./createSimulationIPParallel.sh $SIM $COUNT $ENV 2>&1 ) | tee -a $LOGFILE & 
   (su netsim -c "./createSimulationIPParallel.sh $SIM $COUNT $ENV $RNCPRODUCTDATA $RBSPRODUCTDATA" ) >> $LOGFILE 2>&1 &
 else
 echo "**************************************************************" >> $LOGFILE
 echo " Please check the simname that you have provided and numof nodes in a  sim" >> $LOGFILE
 echo "**************************************************************" >> $LOGFILE
 exit 3
 fi
 #sleep $(($RANDOM / 10000)) &
   createSimulationIPParallelBGP=$!
   PIDS="$PIDS $createSimulationIPParallelBGP" 
   allBGP="$allBGP $createSimulationIPParallelBGP"
#   echo "...$COUNT=$SIM PID=$createSimulationIPParallelBGP is running" | tee -a PIDS.log
   BGP_OUTPUT="$COUNT=$SIM PID=$createSimulationIPParallelBGP" 
   BGP_OUTPUT_ARRAY[createSimulationIPParallelBGP]=$BGP_OUTPUT

 #sleep 1
   CURRENT_NUM_OF_JOBS=`expr $CURRENT_NUM_OF_JOBS + 1`
   COUNT=`expr $COUNT + 1`
  done
rm -rf $PWD/port.mml
setup_iiop_port $PORT >> port.mml
setup_netconf_port $pRBS_PORT >> port.mml
#$NETSIMDIR/$NETSIMVERSION/netsim_pipe < port.mml

if [ $TOTAL_NUM_OF_JOBS_LEFT -ne 0 ]
then

  while true
  do

    #set $PIDS > /dev/null
    set -- $PIDS 
    for PID in "$@"
    do
      shift
      if kill -0 "$PID" 2>/dev/null; then
         #echo "---$PID is still running" | tee -a PIDS.log
        # echo "---${BGP_OUTPUT_ARRAY[$PID]} is running" |  tee -a PIDS.log
         set -- "$@" "$PID"
      else
         wait "$PID"   
         EXIT_CODE=$?
         EXIT_CODES="$EXIT_CODES $EXIT_CODE"
         if [ $EXIT_CODE -ne 0 ]
         then
             echo "***WARNING: ${BGP_OUTPUT_ARRAY[$PID]} throw an error!!! See log files!!!"  
         fi
     
         echo "+++`date`" 
         CURRENT_NUM_OF_JOBS=$(($CURRENT_NUM_OF_JOBS - 1))
         TOTAL_NUM_OF_JOBS_COMPLETED=$(($TOTAL_NUM_OF_JOBS_COMPLETED + 1))
         TOTAL_NUM_OF_JOBS_LEFT=$(($TOTAL_NUM_OF_JOBS - $TOTAL_NUM_OF_JOBS_COMPLETED))
              
         echo "+++COMPLETED_JOB:"${BGP_OUTPUT_ARRAY[$PID]}
         echo "+++CURRENT_NUM_OF_JOBS="$CURRENT_NUM_OF_JOBS | tee -a PIDS.log
         echo "+++TOTAL_NUM_OF_JOBS_COMPLETED="$TOTAL_NUM_OF_JOBS_COMPLETED | tee -a PIDS.log
         echo "+++TOTAL_NUM_OF_JOBS_LEFT="$TOTAL_NUM_OF_JOBS_LEFT | tee -a PIDS.log

         TOTAL_EXECUTED_NUM_OF_JOBS=`expr $CURRENT_NUM_OF_JOBS + $TOTAL_NUM_OF_JOBS_COMPLETED`
       
         if [ $CURRENT_NUM_OF_JOBS -le $MAX_CONCURRENT_NUM_OF_JOBS ]\
            &&\
            [ $TOTAL_EXECUTED_NUM_OF_JOBS -lt $TOTAL_NUM_OF_JOBS ]
         then

			SIM=`getSimNamingConvention $COUNT`

            echo " ***************************" >> $LOGFILE
            echo " *      $SIM               *" >> $LOGFILE
            echo " ***************************" >> $LOGFILE

            #( ./createSimulationIPParallel.sh $SIM $COUNT $ENV 2>&1 ) | tee -a $LOGFILE &
            #( ./createSimulationIPParallel.sh $SIM $COUNT $ENV ) >> $LOGFILE 2>&1 &
            #sleep $(($RANDOM / 10000)) &
            createSimulationIPParallelBGP=$!
            PID=$createSimulationIPParallelBGP
            PIDS="$PIDS $createSimulationIPParallelBGP"
            allBGP="$allBGP $createSimulationIPParallelBGP"
            
           # echo "...$COUNT=$SIM PID=$createSimulationIPParallelBGP is running" | tee -a PIDS.log
            BGP_OUTPUT="$COUNT=$SIM PID=$createSimulationIPParallelBGP" 
            BGP_OUTPUT_ARRAY[createSimulationIPParallelBGP]=$BGP_OUTPUT
         
            CURRENT_NUM_OF_JOBS=$(($CURRENT_NUM_OF_JOBS + 1)) 
            COUNT=`expr $COUNT + 1`
            echo "+++CURRENT_NUM_OF_JOBS="$CURRENT_NUM_OF_JOBS | tee -a PIDS.log
            set -- "$@" "$PID"
          fi  
        fi

        if [ $TOTAL_NUM_OF_JOBS_COMPLETED -eq $TOTAL_NUM_OF_JOBS ]
        then
           break 2
        fi
        sleep 10
      done

      PIDS=`echo "$@"`
    done
fi
echo ""
su netsim -c "wait $allBGP"
echo "---PLEASE WAIT UNTIL ALL SCRIPTS ARE FINISHED SUCCESFULLY----" 

#echo "******Running Unit tests*********"
#su netsim -c "./check_hardwareConfiguration.sh $SIM | tee -a ../log/hardwareConfiguration.log"
#su netsim -c "./check_rbsId.sh $SIM | tee -a ../log/rbsId.log"
#echo "******Running Unit tests are completed*********"

echo ""| tee -a $LOGFILE
echo " ***************************************" | tee -a $LOGFILE
echo " *    SIMS CREATIONS ARE COMPLETED     *" | tee -a $LOGFILE
echo " ***************************************" | tee -a $LOGFILE
echo ""| tee -a $LOGFILE
echo "$0: ended at `date`" | tee -a $LOGFILE


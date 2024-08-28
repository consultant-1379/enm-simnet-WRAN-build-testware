#!/bin/sh 


##########################################3
# Ver3        : Modified for PICO node
# Purpose     : To include PICO also in the sim design
# Description : Along with RNC,RBS,RXI PICO is also include for SIM design
# Date        : 2013.08.06
# Who         : EAGACHI

##########################################3
# Ver4        : Modified for DG2 node
# Purpose     : To include DG2 also in the sim design 
# Description : Along with RNC,RBS,RXI,PICO DG2 is also include for SIM design
# Date        : 2015.06.01
#Who	      : XRANDYA

##########################################3
# Ver5        : Modified for DG2 node
# Purpose     : To include PICO also in the sim design
# Description : Along with RNC,RBS,RXI,PICO DG2 is also include for SIM design
# Date        : 2015.06.15
#Who	      : XSOUSOU
###########################################
# Version6    : 20.02
# Revision    : CXP 903 6540-1-3
# Purpose     : clone the base node instead of creating
# Description : To avoid PM issues need to clone the base node
# JIRA        : NSS-26915
# Date        : 10th Dec 2019
# Author      : zyamkan
###########################################

if [ "$#" -ne 6 ]
then
 echo "This will create a simulation and the NEs as defined in the env file"
 echo
 echo "Usage: $0 <sim name> <count> <env file> <RNC ProductData> <MSRBS ProductData> <MSRBS NodeTemplate Name>"
 echo
 echo "Example: $0 RNCS1100-ST-RNC10 10 O13-ST-13A-40K.env CXP9021776/5:R2AA13 CXP9024418/12:R31A96 MSRBS_V2_19-Q4_V1_CXP9024418_6-R79A10"
 echo
 exit 1
fi


SIM=$1
RNCCOUNT=$2
ENV=$3
RNCPRODUCTDATA=$4
MSRBSPRODUCTDATA=$5
BaseSimName=$6
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

echo "//..$0:$RNCNAME started at `date`" 
echo "//"


if [ $UPDATE == "NO" ]
then

	OFFSET_FOR_RNC=`getStartIP $RNCCOUNT $RNCDG2ARRAY $RNCPICOARRAY`
	NUMOFDG2=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`
	echo "//...$SIM is being created...  *$OFFSET_FOR_RNC*"

	createSim $SIM $BaseSimName >> $MMLSCRIPT

  CmdResult=`cat $MMLSCRIPT | /netsim/inst/netsim_pipe | tail -n1`
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
	else
		echo " For:$SIM no RNCNODE is created"
	fi
 
        ######DG2 CREATION#####

        if [ "$DG2_NODE_CREATION" == "YES" ]
        then

                NUMOFDG2=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`

                if [ "$NUMOFDG2" != 0 ]
                then
                        OFFSET_FOR_DG2=`expr $OFFSET_FOR_RNC + 1`			
                        DG2VERSION=`getMimType $RNCCOUNT $DG2VERSIONARRAY`
			createNodeipDG2 $SIM $pRBS_PORT MSRBS-V2 $NUMOFDG2 $DG2VERSION $OFFSET_FOR_DG2 | /netsim/inst/netsim_shell >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
			startDG2Nodes $SIM
                        echo " *******************************************************************************" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                        echo " ****************** PmUnit test are checking on RNC MSRBS nodes ****************" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                        echo " *******************************************************************************" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                        echo shroot | sudo -S -H -u root bash -c "perl PmUnitTest.pl ${SIM}"
                        CmdResult=`cat /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/Pmlogs.txt | grep -i failed | wc -l`
                        if [ "$CmdResult" == "0" ]
                        then
                          echo "Pm Data is proper on the RadioNodes" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                        else
                          echo "Pm Data is not properly loaded on RadioNodes" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                          echo "Please check the PM data on nodes with the respective MIB file" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                          echo "We are exiting from Sim Build " >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                          exit 123
                        fi
			echo " ******************End of PM unit script execution *****************************" >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
                else
                        echo " For:$SIM no DG2NODES are created"
                fi
        else
                echo " For:$SIM no DG2NODES are created"
        fi

	 ######PICO CREATION#####

	if [ "$PICO_NODE_CREATION" == "YES" ]
        then

                NUMOFPICO=`getNumOfPICO $RNCCOUNT $RNCPICOARRAY`
                echo "no of pico is $NUMOFPICO"
                if [ "$NUMOFPICO" != 0 ]
                then
                        OFFSET_FOR_PICO=`expr $OFFSET_FOR_RNC + 1 + $NUMOFDG2`
                        PICOVERSION=`getMimType $RNCCOUNT $PICOVERSIONARRAY`
                        createNodeip $SIM $pRBS_PORT PRBS $NUMOFPICO $PICOVERSION $OFFSET_FOR_PICO >> $MMLSCRIPT
			createNodeip $SIM $pRBS_PORT PRBS $NUMOFPICO $PICOVERSION $OFFSET_FOR_PICO >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/pico.log
                else
                        echo " For:$SIM no PRBSNODES are created"
                fi
        else
                echo " For:$SIM no PRBSNODES are created"
        fi


  relateNEs $SIM $RNCNAME >> $MMLSCRIPT
NodesList=`echo -e ".open $SIM \n .show simnes" | /netsim/inst/netsim_shell | grep "LTE MSRBS-V2" | cut -d" " -f1`
for Node in ${NodesList[@]}
do
        echo -e ".open ${SIM} \n .select ${Node} \n .start \n setmoattribute:mo=\"ManagedElement=${Node}\", attributes = \"managedElementId(string )=$RNCNAME${Node}\"; \n .restart \n .stop" | /netsim/inst/netsim_shell >> /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran_MSRBS/log/msrbsip.log
done

echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$RNCNAME'MSRBS-V201'>> $MMLSCRIPT
echo '.start'>> $MMLSCRIPT
NODESNAME=""
counterLimit=`expr $NUMOFDG2 / 20`
echo $counterLimit
counter=1
dg2count=1

while [[ $counter -lt $(($counterLimit + 1)) ]];
        do
                dg2countlimit=`expr $(($counter * 20)) + 1`
              
                while [[ $dg2count -lt $dg2countlimit ]];
                 do 

                 if [ "$dg2count" -le 9 ]
                then
                DG2NAME="MSRBS-V20"$dg2count
                else
                DG2NAME="MSRBS-V2"$dg2count
                fi
                NODESNAME+=$RNCNAME$DG2NAME" "
               dg2count=`expr $dg2count + 1`
        done
                echo '.select '$NODESNAME >> $MMLSCRIPT
                echo '.start -parallel' >> $MMLSCRIPT
                 echo '.stop'  >> $MMLSCRIPT
		NODESNAME=""
		counter=`expr $counter + 1`
done

echo '.set nodeserverload MSRBS-V2' $DG2VERSION '8'>> $MMLSCRIPT 
echo '.select network'>> $MMLSCRIPT
echo '.start'>> $MMLSCRIPT
  
  #
  #
  ## Pass MML commands into netsim_pipe to run
  #
  /netsim/inst/netsim_pipe < $MMLSCRIPT
  rm $PWD/$MMLSCRIPT
fi

#if ["$RNC_NODE_DATA_CREATION" == "NO" -a "$DG2_NODE_DATA_CREATION" == "NO" ]
if [ "$RNC_NODE_DATA_CREATION" == "NO" -a  "$DG2_NODE_DATA_CREATION" == "NO"  -a  "$PICO_NODE_DATA_CREATION" == "NO"]
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
#echo "/data PARALLEL"
  (./createDataParallel.sh $SIM $RNCCOUNT $ENV $RNCPRODUCTDATA $MSRBSPRODUCTDATA 2>&1 ) 
fi


echo "//" 
echo "//..$0:$RNCNAME ended at `date`" 
   

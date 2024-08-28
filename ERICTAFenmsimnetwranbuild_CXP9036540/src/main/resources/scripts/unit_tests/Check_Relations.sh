#!/bin/sh 

SimName=$1 
echo "-----SimName=$SimName-------" 
NODENAME=`echo netsim | sudo -S -H -u netsim bash -c 'printf ".open '$SimName' \n .show simnes" | /netsim/inst/netsim_shell| grep -v ">>" | grep -v "OK"| grep -v "NE"| head -1 | cut -d" " -f1'`
echo "################### Checking relations on $NODENAME ######################"

#################################################
#checking UtranRelations count on RNC node
#################################################

UtranRelation_count=`echo -e '.open '$SimName' \n .select '$NODENAME' \n .start \n e: length(csmo:get_mo_ids_by_type(null,"UtranRelation")).' | /netsim/inst/netsim_shell | tail -1`
if [[ $UtranRelation_count -ne 0 ]]
then
echo " PASSED: UtranRelation Count on $NODENAME is $UtranRelation_count "
else
echo " FAILED: No UtranRelations on $NODENAME , please correct "
fi

##################################################
#checking EutranFreqRelation count on RNC node
##################################################

EutranFreqRelation_count=`echo -e '.open '$SimName' \n .select '$NODENAME' \n .start \n e: length(csmo:get_mo_ids_by_type(null,"EutranFreqRelation")).' | /netsim/inst/netsim_shell | tail -1`
if [[ $EutranFreqRelation_count -ne 0 ]]
then
echo " PASSED: EutranFreqRelations Count on $NODENAME is $EutranFreqRelation_count "
else
echo " FAILED: No EutranFreqRelations on $NODENAME , please correct "
fi

#################################################
#checking GSM relations count on RNC node
#################################################

GsmRelations_count=`echo -e '.open '$SimName' \n .select '$NODENAME' \n .start \n e: length(csmo:get_mo_ids_by_type(null,"GsmRelation")).' | /netsim/inst/netsim_shell | tail -1`
if [[ $GsmRelations_count -ne 0 ]]
then
echo " PASSED: GsmRelations Count on $NODENAME is $GsmRelations_count "
else
echo " FAILED: No GsmRelations on $NODENAME , please correct "
fi

#################################################
#checking Coverage relations count on RNC node
#################################################

CoverageRelations_count=`echo -e '.open '$SimName' \n .select '$NODENAME' \n .start \n e: length(csmo:get_mo_ids_by_type(null,"GsmRelation")).' | /netsim/inst/netsim_shell | tail -1`
if [[ $CoverageRelations_count -ne 0 ]]
then
echo " PASSED: CoverageRelations Count on $NODENAME is $CoverageRelations_count "
else
echo " FAILED: No CoverageRelations on $NODENAME , please correct "
fi

##################################################
#END OF THE SCRIPT
##################################################


#!/bin/sh
# Created by  : Anusha Chitram
# Created in  : 14 04 2021
##
### VERSION HISTORY
###########################################
# Ver1        : Modified for ENM RV
# Purpose     : To Display the Relation counts before NRM build
# Description : After the config file ( jar ) execution ,the relations values are extracted from the MO files to check if the requirement                is met
# Date        : 14 004 2019
# Who         : zchianu
###########################################
Path=$1

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <path where parent(RNC) Mo files are present> "
 echo
 echo "Example: $0 /netsim/path_to_Mofiles/ "
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi
echo "#################################################################################################################################"
echo "NOTE : Only parent MO files need to be given in the path else the counts will be very huge , RBS or MSRBS mo files are not needed."
echo "#################################################################################################################################"
echo "Path of Mo files is $Path"
echo "################################################################################################################################"
UtranCell_Count=`grep -nr "moType UtranCell" $Path | wc -l`
UtranRelation_Count=`grep -nr "moType UtranRelation" $Path | wc -l`
EutranRelation_Count=`grep -nr "moType EutranFreqRelation" $Path | wc -l`
GsmRelation_Count=`grep -nr "moType GsmRelation" $Path | wc -l`
CoverageRelation_Count=`grep -nr "moType CoverageRelation" $Path | wc -l`

##########################################################################

echo -e "Below are the Relation Counts obtained from the Mo files in $Path path \n"
echo "Values are given combining all the data from RNC mo files which are needed for NRM builds"
echo "################################################################################################################################"
echo -e "\n Total UtranCell count is $UtranCell_Count"
echo -e "\n Total Utran Relations Count is $UtranRelation_Count"
echo -e "\n Total Eutran Relations Count is $EutranRelation_Count"
echo -e "\n Total Gsm Relations count is $GsmRelation_Count"
echo -e "\n Total Coverage Relations count is $CoverageRelation_Count\n"
echo "################################################################################################################################"
echo -e "\nAll the required counts obtained, if the counts are not as needed for NRM, kindly make the changes in config.xml file and generate the Mo file again"
echo "################################################################################################################################" 


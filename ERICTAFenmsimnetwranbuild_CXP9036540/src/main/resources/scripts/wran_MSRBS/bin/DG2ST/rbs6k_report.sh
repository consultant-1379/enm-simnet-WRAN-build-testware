#!/bin/sh
# Created in  : 2011.03.11
##
### VERSION HISTORY
##############################################
# Ver1        : Created for WRAN TERE 16B
# Purpose     : cabinetId created
# Description : 
# Date        : 2015.07.10
# Who         : Ranjita Dyasnur

if [ "$#" -ne 3  ]
then
cat<<HELP

####################
# HELP
####################

Usage  : $0 <sim name> <env file> <rnc num>

Example: $0 RNCM1115-ST-RNC01 O12-ST-12.0.7-N.env 1

HELP

exit 1
fi

SIMNAME=$1
ENV=$2

. ../utilityFunctions.sh
. ../../dat/$ENV

if [ "$3" -le 9 ]
then
RNCNAME="RNC0"$3
RNCCOUNT="0"$3
else
RNCNAME="RNC"$3
RNCCOUNT=$3
fi

if [ "$3" -eq 0 ]
then
RNCNAME=
fi

if [ "$RNC_NODE_CREATION" != "YES" ]
then
  RNCNAME=""
fi

#echo "//...$0:$SIMNAME script started running at "`date`
#echo "//"

PWD=`pwd`
NOW=`date +"%Y_%m_%d_%T:%N"`

MOSCRIPT=$0:${NOW}:$SIMNAME
MMLSCRIPT=$0:${NOW}:$SIMNAME".mml"

SCRIPTNAME=`basename "$0"`
DELETE_ALL_MO_SCRIPTS="DELETE_ALL_MO_SCRIPTS_${SIMNAME}_${SCRIPTNAME}"


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

#echo ""
#echo "MAKING MO SCRIPT"
#echo ""

    NUMOFRBS=`getNumOfDG2 $RNCCOUNT $RNCDG2ARRAY`
	
    ###########################
    # Percantage of RBS with 3 sectors and 2 carriers for 6 cells RBS only
    ###########################
    GROUP_A_PERC_A_=50
    CELLTYPE=6
    FLIP="FALSE"
	#echo "$RNCCOUNT:1 $CELLTYPE:2 $RNCDG2ARRAY:3 $DG2CELLARRAY:4"
    NUMOFRBS_FOR_CELLTYPE=`getNumOfRBSofCellType $RNCCOUNT $CELLTYPE $RNCDG2ARRAY $DG2CELLARRAY`
    NUMOF_RBS_THREE_SEC_PER_RNC=`expr \( $NUMOFRBS_FOR_CELLTYPE \* $GROUP_A_PERC_A_ \) / 100`
    #
    #echo "************************************"
    #echo "* RNCCOUNT="$RNCCOUNT
    #echo "************************************"

    ###########################
    # cabinetId types/sharings 
    ###########################
    UNIQUE=1
    DOUBLE=2
    TRIPLE=3
    MULTICABINET=1
 
    ###########################
    # cabinetId sharing percantage per RNC
    ###########################
    GROUP_A_PERC_A=20 #Unique
    GROUP_A_PERC_B=50 #Double
    GROUP_A_PERC_C=20 #Triple
    GROUP_A_PERC_D=10 #Multi Cabinet

    ###########################
    # Total number of RBS6K cabinetId per RNC
    ###########################
    GROUP_B_PERC_A=50

    ###########################
    # MixedMode set true for double and triple percantage per RNC
    ###########################
    GROUP_C_PERC_A=35 #Num of nodes mixedmode set true percentage
    NUMOF_RBS6K_PER_RNC=`expr \( $NUMOFRBS \* $GROUP_B_PERC_A \) / 100`
   
    ###########################
    # In order to get evenly dividable numbers we increase the total number nearest biggest evenly divedable number 
    ###########################
    NUMOF_RBS6K_cabinetId_DOUBLE=`expr  \( $NUMOF_RBS6K_PER_RNC \* $GROUP_A_PERC_B \) / 100`
    MOD=`expr $NUMOF_RBS6K_cabinetId_DOUBLE % $DOUBLE`
    if [ "$MOD" -ne 0 ] 
    then 
      NUMOF_RBS6K_cabinetId_DOUBLE=`expr $NUMOF_RBS6K_cabinetId_DOUBLE + \( $DOUBLE - $MOD \)` 
    fi
    NUMOF_RBS6K_cabinetId_DOUBLE_MIXEDMODE_TRUE=`expr \( $NUMOF_RBS6K_cabinetId_DOUBLE \* $GROUP_C_PERC_A \) / 100`
    #echo "NUMOF_RBS6K_cabinetId_DOUBLE_MIXEDMODE_TRUE="$NUMOF_RBS6K_cabinetId_DOUBLE_MIXEDMODE_TRUE


    NUMOF_RBS6K_cabinetId_TRIPLE=`expr \( $NUMOF_RBS6K_PER_RNC \* $GROUP_A_PERC_C \) / 100`
    MOD=`expr $NUMOF_RBS6K_cabinetId_TRIPLE % $TRIPLE`
    if [ "$MOD" -ne 0 ]
    then
      NUMOF_RBS6K_cabinetId_TRIPLE=`expr $NUMOF_RBS6K_cabinetId_TRIPLE + \( $TRIPLE - $MOD \)`
    fi
    NUMOF_RBS6K_cabinetId_TRIPLE_MIXEDMODE_TRUE=`expr \( $NUMOF_RBS6K_cabinetId_TRIPLE \* $GROUP_C_PERC_A \) / 100`
    #echo "NUMOF_RBS6K_cabinetId_TRIPLE_MIXEDMODE_TRUE="$NUMOF_RBS6K_cabinetId_TRIPLE_MIXEDMODE_TRUE

    #MultiCabinet 
    NUMOF_RBS6K_MULTI_CABINET=`expr \( $NUMOF_RBS6K_PER_RNC \* $GROUP_A_PERC_D \) / 100`
    MOD=`expr $NUMOF_RBS6K_MULTI_CABINET % $MULTICABINET`
    if [ "$MOD" -ne 0 ]
    then
      NUMOF_RBS6K_MULTI_CABINET=`expr $NUMOF_RBS6K_MULTI_CABINET + \( $MULTICABINET - $MOD \)`
    fi
    NUMOF_RBS6K_MULTI_CABINET_TRUE=`expr \( $NUMOF_RBS6K_MULTI_CABINET \* $GROUP_C_PERC_A \) / 100`

    #MultiCabinet

    ###########################
    # remainder of total numofrbs6k after subtracking triple and doubles is unique
    ###########################
    NUMOF_RBS6K_cabinetId_UNIQUE=`expr $NUMOF_RBS6K_PER_RNC - \( $NUMOF_RBS6K_cabinetId_DOUBLE + $NUMOF_RBS6K_cabinetId_TRIPLE + $NUMOF_RBS6K_MULTI_CABINET \)`
    #echo "NUMBER OF cabinetId!!!!!!!="$NUMOF_RBS6K_cabinetId_UNIQUE

    ###########################
    # Range of IDs of cabinetId for each unique, double, triple
    ###########################
    ID_cabinetId_UNIQUE_RANGE=`expr $NUMOF_RBS6K_cabinetId_UNIQUE / $UNIQUE`
    #echo "ID_cabinetId_UNIQUE_RANGE="$ID_cabinetId_UNIQUE_RANGE
    ID_cabinetId_DOUBLE_RANGE=`expr $NUMOF_RBS6K_cabinetId_DOUBLE / $DOUBLE` 
    ID_cabinetId_TRIPLE_RANGE=`expr $NUMOF_RBS6K_cabinetId_TRIPLE / $TRIPLE`
    ID_cabinetId_MULTI_RANGE=`expr $NUMOF_RBS6K_MULTI_CABINET \* 4`
    ID_cabinetIdS_TOTAL_RANGE=`expr $ID_cabinetId_UNIQUE_RANGE + $ID_cabinetId_DOUBLE_RANGE + $ID_cabinetId_TRIPLE_RANGE + $ID_cabinetId_MULTI_RANGE`
   # echo "ID_cabinetIdS_TOTAL_RANGE******="$ID_cabinetIdS_TOTAL_RANGE
   
    

  # ID_cabinetIdS_TOTAL_RANGE=20
  if [ "$RNCCOUNT" -le 53 ] 
  then
    ID_cabinetId_UNIQUE_START=`expr $RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
  fi


  # ID_cabinetIdS_TOTAL_RANGE=18
  if [ "$RNCCOUNT" -ge 54 ] && [ "$RNCCOUNT" -le 94 ] 
  then
    TEMP_NUMOFRNC=53
    TEMP_ID_cabinetIdS_TOTAL_RANGE=20
    TEMP_RNCCOUNT=`expr $RNCCOUNT - $TEMP_NUMOFRNC`
    TEMP_RANGE=`expr $TEMP_NUMOFRNC \* $TEMP_ID_cabinetIdS_TOTAL_RANGE`
    #echo "TEMP_RANGE="$TEMP_RANGE

    ID_cabinetId_UNIQUE_START=`expr $TEMP_RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
    ID_cabinetId_UNIQUE_START=`expr $ID_cabinetId_UNIQUE_START + $TEMP_RANGE`
  fi


  # ID_cabinetIdS_TOTAL_RANGE=51
  if [ "$RNCCOUNT" -ge 95 ] && [ "$RNCCOUNT" -le 103 ]
  then
    TEMP_NUMOFRNC_A=53
    TEMP_ID_cabinetIdS_TOTAL_RANGE_A=20

    TEMP_NUMOFRNC_B=41
    TEMP_ID_cabinetIdS_TOTAL_RANGE_B=18

    TEMP_RANGE_A=`expr $TEMP_NUMOFRNC_A \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_A`
    TEMP_RANGE_B=`expr $TEMP_NUMOFRNC_B \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_B`

    TEMP_RNCCOUNT=`expr $RNCCOUNT - $TEMP_NUMOFRNC_A - $TEMP_NUMOFRNC_B`

    ID_cabinetId_UNIQUE_START=`expr $TEMP_RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
    ID_cabinetId_UNIQUE_START=`expr $ID_cabinetId_UNIQUE_START + $TEMP_RANGE_A + $TEMP_RANGE_B`
  fi


  # ID_cabinetIdS_TOTAL_RANGE=73
  if [ "$RNCCOUNT" -eq 104 ]
  then
    TEMP_NUMOFRNC_A=53
    TEMP_ID_cabinetIdS_TOTAL_RANGE_A=20

    TEMP_NUMOFRNC_B=41
    TEMP_ID_cabinetIdS_TOTAL_RANGE_B=18

    TEMP_NUMOFRNC_C=9
    TEMP_ID_cabinetIdS_TOTAL_RANGE_C=51

    TEMP_RANGE_A=`expr $TEMP_NUMOFRNC_A \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_A`
    TEMP_RANGE_B=`expr $TEMP_NUMOFRNC_B \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_B`
    TEMP_RANGE_C=`expr $TEMP_NUMOFRNC_C \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_C`

    TEMP_RNCCOUNT=`expr $RNCCOUNT - $TEMP_NUMOFRNC_A - $TEMP_NUMOFRNC_B - $TEMP_NUMOFRNC_C`

    ID_cabinetId_UNIQUE_START=`expr $TEMP_RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
    ID_cabinetId_UNIQUE_START=`expr $ID_cabinetId_UNIQUE_START + $TEMP_RANGE_A + $TEMP_RANGE_B + $TEMP_RANGE_C`
  fi

  # ID_cabinetIdS_TOTAL_RANGE=96
  if [ "$RNCCOUNT" -eq 105 ]
  then
    TEMP_NUMOFRNC_A=53
    TEMP_ID_cabinetIdS_TOTAL_RANGE_A=20

    TEMP_NUMOFRNC_B=41
    TEMP_ID_cabinetIdS_TOTAL_RANGE_B=18

    TEMP_NUMOFRNC_C=9
    TEMP_ID_cabinetIdS_TOTAL_RANGE_C=51

    TEMP_NUMOFRNC_D=1
    TEMP_ID_cabinetIdS_TOTAL_RANGE_D=73

    TEMP_RANGE_A=`expr $TEMP_NUMOFRNC_A \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_A`
    TEMP_RANGE_B=`expr $TEMP_NUMOFRNC_B \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_B`
    TEMP_RANGE_C=`expr $TEMP_NUMOFRNC_C \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_C`
    TEMP_RANGE_D=`expr $TEMP_NUMOFRNC_D \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_D`

    TEMP_RNCCOUNT=`expr $RNCCOUNT - $TEMP_NUMOFRNC_A - $TEMP_NUMOFRNC_B - $TEMP_NUMOFRNC_C - $TEMP_NUMOFRNC_D`

    ID_cabinetId_UNIQUE_START=`expr $TEMP_RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
    ID_cabinetId_UNIQUE_START=`expr $ID_cabinetId_UNIQUE_START + $TEMP_RANGE_A + $TEMP_RANGE_B + $TEMP_RANGE_C + $TEMP_NUMOFRNC_Di`
  fi

    # ID_cabinetIdS_TOTAL_RANGE=119
  if [ "$RNCCOUNT" -eq 106 ]
  then
    TEMP_NUMOFRNC_A=53
    TEMP_ID_cabinetIdS_TOTAL_RANGE_A=20

    TEMP_NUMOFRNC_B=41
    TEMP_ID_cabinetIdS_TOTAL_RANGE_B=18

    TEMP_NUMOFRNC_C=9
    TEMP_ID_cabinetIdS_TOTAL_RANGE_C=51

    TEMP_NUMOFRNC_D=1
    TEMP_ID_cabinetIdS_TOTAL_RANGE_D=73

    TEMP_NUMOFRNC_E=1
    TEMP_ID_cabinetIdS_TOTAL_RANGE_E=96    

    TEMP_RANGE_A=`expr $TEMP_NUMOFRNC_A \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_A`
    TEMP_RANGE_B=`expr $TEMP_NUMOFRNC_B \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_B`
    TEMP_RANGE_C=`expr $TEMP_NUMOFRNC_C \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_C`
    TEMP_RANGE_D=`expr $TEMP_NUMOFRNC_D \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_D`
    TEMP_RANGE_E=`expr $TEMP_NUMOFRNC_E \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_E`

    TEMP_RNCCOUNT=`expr $RNCCOUNT - $TEMP_NUMOFRNC_A - $TEMP_NUMOFRNC_B - $TEMP_NUMOFRNC_C - $TEMP_NUMOFRNC_D - $TEMP_NUMOFRNC_E`

    ID_cabinetId_UNIQUE_START=`expr $TEMP_RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
    ID_cabinetId_UNIQUE_START=`expr $ID_cabinetId_UNIQUE_START + $TEMP_RANGE_A + $TEMP_RANGE_B + $TEMP_RANGE_C + $TEMP_NUMOFRNC_D + $TEMP_NUMOFRNC_D + $TEMP_NUMOFRNC_E`
  fi

  # ID_cabinetIdS_TOTAL_RANGE=?
  if [ "$RNCCOUNT" -ge 107 ]
  then
    TEMP_NUMOFRNC_A=52
    TEMP_ID_cabinetIdS_TOTAL_RANGE_A=20

    TEMP_NUMOFRNC_B=25
    TEMP_ID_cabinetIdS_TOTAL_RANGE_B=18

    TEMP_NUMOFRNC_C=5
    TEMP_ID_cabinetIdS_TOTAL_RANGE_C=51

    TEMP_NUMOFRNC_D=1
    TEMP_ID_cabinetIdS_TOTAL_RANGE_D=73

    TEMP_NUMOFRNC_E=1
    TEMP_ID_cabinetIdS_TOTAL_RANGE_E=96

    TEMP_NUMOFRNC_F=1
    TEMP_ID_cabinetIdS_TOTAL_RANGE_F=119

    TEMP_RANGE_A=`expr $TEMP_NUMOFRNC_A \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_A`
    TEMP_RANGE_B=`expr $TEMP_NUMOFRNC_B \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_B`
    TEMP_RANGE_C=`expr $TEMP_NUMOFRNC_C \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_C`
    TEMP_RANGE_D=`expr $TEMP_NUMOFRNC_D \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_D`
    TEMP_RANGE_E=`expr $TEMP_NUMOFRNC_E \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_E`
    TEMP_RANGE_F=`expr $TEMP_NUMOFRNC_F \* $TEMP_ID_cabinetIdS_TOTAL_RANGE_F`

    TEMP_RNCCOUNT=`expr $RNCCOUNT - $TEMP_NUMOFRNC_D - $TEMP_NUMOFRNC_A - $TEMP_NUMOFRNC_B - $TEMP_NUMOFRNC_C - $TEMP_NUMOFRNC_D - $TEMP_NUMOFRNC_E - $TEMP_NUMOFRNC_F`

    ID_cabinetId_UNIQUE_START=`expr $TEMP_RNCCOUNT \* $ID_cabinetIdS_TOTAL_RANGE - \( $ID_cabinetIdS_TOTAL_RANGE - 1 \)`
    ID_cabinetId_UNIQUE_START=`expr $ID_cabinetId_UNIQUE_START + $TEMP_RANGE_A + $TEMP_RANGE_B + $TEMP_RANGE_C + $TEMP_RANGE_D + + $TEMP_NUMOFRNC_E + $TEMP_NUMOFRNC_F`
  fi

 
    cabinetId_UNIQUE_START=1
    cabinetId_UNIQUE_END=`expr $cabinetId_UNIQUE_START + $NUMOF_RBS6K_cabinetId_UNIQUE - 1`

    #echo "cabinetId_UNIQUE_START="$cabinetId_UNIQUE_START
    #echo "cabinetId_UNIQUE_END="$cabinetId_UNIQUE_END

    cabinetId_DOUBLE_START=`expr $cabinetId_UNIQUE_END + 1`
    cabinetId_DOUBLE_END=`expr $cabinetId_DOUBLE_START + $NUMOF_RBS6K_cabinetId_DOUBLE - 1`

    #echo "cabinetId_DOUBLE_START="$cabinetId_DOUBLE_START
    #echo "cabinetId_DOUBLE_END="$cabinetId_DOUBLE_END

    cabinetId_TRIPLE_START=`expr $cabinetId_DOUBLE_END + 1`
    cabinetId_TRIPLE_END=`expr $cabinetId_TRIPLE_START + $NUMOF_RBS6K_cabinetId_TRIPLE - 1`

    #echo "cabinetId_TRIPLE_START="$cabinetId_TRIPLE_START
    #echo "cabinetId_TRIPLE_END="$cabinetId_TRIPLE_END

    MULTICABINET_START=`expr $cabinetId_TRIPLE_END + 1`
    MULTICABINET_END=`expr $MULTICABINET_START + $NUMOF_RBS6K_MULTI_CABINET - 1`


COUNT=1
RBSCOUNT=1
MOFILECOUNT=1
SIXCELLRBSCOUNT=1
CELLCOUNT=1
STOP=$NUMOF_RBS6K_PER_RNC
#STOP=$NUMOF_RBS6K_cabinetId_UNIQUE
ID=$ID_cabinetId_UNIQUE_START
#echo "ID_cabinetId_UNIQUE_START="$ID_cabinetId_UNIQUE_START
INCREMENT=1
while [ "$COUNT" -le "$STOP" ]
do

  if [ "$COUNT" -le 9 ]
   then
    RBSNAME=MSRBS-V20
   else
    RBSNAME=MSRBS-V2
  fi


  CELLCOUNT=1

  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCDG2ARRAY $DG2CELLARRAY`
  MOFILEEXTENSION="__"$MOFILECOUNT".mo"


  case "$NUMOFCELL"
  in
    1) NUMOFSECTOR=1; NUMOFCARRIER=1;;
    3) NUMOFSECTOR=1; NUMOFCARRIER=3;;
    6) NUMOFSECTOR=3; NUMOFCARRIER=2;;
    9) NUMOFSECTOR=3; NUMOFCARRIER=3;;
 #  12) NUMOFSECTOR=6; NUMOFCARRIER=2;;
  esac

  if [ "$NUMOFCELL" -eq 6 ] && [ "$FLIP" == "TRUE" ];
  then
	FLIP="FALSE"
  elif [ "$NUMOFCELL" -eq 6 ];then
          NUMOFSECTOR=6; NUMOFCARRIER=1;
	FLIP="TRUE"
  fi


    MIXEDMODE=FALSE

    if [ "$RBSCOUNT" -ge "$cabinetId_UNIQUE_START" ] && [  "$RBSCOUNT" -le "$cabinetId_UNIQUE_END" ]
    then
      TEMP_EXCESS=0
      TEMP_COUNTER=`expr $RBSCOUNT - $TEMP_EXCESS`
      DIVISOR=$UNIQUE
      TYPE="UNIQUE"
    fi

    if [ "$RBSCOUNT" -ge "$cabinetId_DOUBLE_START" ] && [  "$RBSCOUNT" -le "$cabinetId_DOUBLE_END" ]
    then
      TEMP_EXCESS=$NUMOF_RBS6K_cabinetId_UNIQUE
      TEMP_COUNTER=`expr $RBSCOUNT - $TEMP_EXCESS`
      DIVISOR=$DOUBLE
      TYPE="DOUBLE"
      UNTIL_SET_MIXEDMODE_TRUE=`expr $cabinetId_DOUBLE_START + $NUMOF_RBS6K_cabinetId_DOUBLE_MIXEDMODE_TRUE`
      if [ "$RBSCOUNT" -lt "$UNTIL_SET_MIXEDMODE_TRUE" ]
      then
        MIXEDMODE=TRUE
      fi
    fi

    if [ "$RBSCOUNT" -ge "$cabinetId_TRIPLE_START" ] && [  "$RBSCOUNT" -le "$cabinetId_TRIPLE_END" ]
    then
      TEMP_EXCESS=`expr $NUMOF_RBS6K_cabinetId_UNIQUE + $NUMOF_RBS6K_cabinetId_DOUBLE`
      TEMP_COUNTER=`expr $RBSCOUNT - $TEMP_EXCESS`
      DIVISOR=$TRIPLE
      TYPE="TRIPLE"
      UNTIL_SET_MIXEDMODE_TRUE=`expr $cabinetId_TRIPLE_START + $NUMOF_RBS6K_cabinetId_TRIPLE_MIXEDMODE_TRUE`
      if [ "$RBSCOUNT" -lt "$UNTIL_SET_MIXEDMODE_TRUE" ]
      then
        MIXEDMODE=TRUE
      fi
    fi

    if [ "$RBSCOUNT" -ge "$MULTICABINET_START" ] && [  "$RBSCOUNT" -le "$MULTICABINET_END" ]
    then
      TEMP_EXCESS=`expr $NUMOF_RBS6K_cabinetId_UNIQUE + $NUMOF_RBS6K_cabinetId_DOUBLE + $NUMOF_RBS6K_cabinetId_TRIPLE`
      TEMP_COUNTER=`expr $RBSCOUNT - $TEMP_EXCESS`
      DIVISOR=$MULTICABINET
      TYPE="MULTICABINENT"
      UNTIL_SET_MIXEDMODE_TRUE=`expr $MULTICABINET_START + $NUMOF_RBS6K_MULTI_CABINET_TRUE`
      #echo "!!!!!!!!!UNTIL_SET_MIXEDMODE_TRUE="$UNTIL_SET_MIXEDMODE_TRUE
      if [ "$RBSCOUNT" -lt "$UNTIL_SET_MIXEDMODE_TRUE" ]
      then
        MIXEDMODE=TRUE
      fi
   fi



  CABID="CABID_"$ID
  echo "$RNCNAME$RBSNAME$COUNT $TYPE ID=$CABID MIXEDMODE="$MIXEDMODE


   if [ $RNCCOUNT -ge $RNC_START_FOR_CLASSIC_RBS ] && [ $RNCCOUNT -le $RNC_STOP_FOR_CLASSIC_RBS ]
  then
     if [ $RBSCOUNT -eq 1 ]
     then
      # echo "  No mixed mode can be set for "$RNCNAME
       echo "" 
     fi
fi
    XCOUNT=1
   while [ "$XCOUNT" -le "$NUMOFSECTOR" ]
    do

 
      XCOUNT=`expr $XCOUNT + 1`
    done
 

  MOD=`expr $TEMP_COUNTER % $DIVISOR`
  if [ "$MOD" -eq 0 ]; then ID=`expr $ID + $INCREMENT` ; fi

  #echo ""
  #echo "MAKING MML SCRIPT"

  #########################################
  #
  # Make MML Script
  #
  #########################################


echo "rm $PWD/$MOSCRIPT$MOFILEEXTENSION " >> $DELETE_ALL_MO_SCRIPTS # Script to clean up all the generated MO scripts


  RBSCOUNT=`expr $RBSCOUNT + 1`
  COUNT=`expr $COUNT + 1`
  MOFILECOUNT=`expr $MOFILECOUNT + 1`
done


################################################


#cat $PWD/$MMLSCRIPT
#rm $PWD/$MMLSCRIPT
exit

#############################


rm $PWD/$MMLSCRIPT
. $DELETE_ALL_MO_SCRIPTS
rm $DELETE_ALL_MO_SCRIPTS


echo "//...$0:$SIMNAME script ended running at "`date`
echo "//"


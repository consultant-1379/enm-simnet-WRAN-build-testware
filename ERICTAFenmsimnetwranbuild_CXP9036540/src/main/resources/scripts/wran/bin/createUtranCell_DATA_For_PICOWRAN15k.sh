#!/bin/sh

# Created by  : Fatih ONUR
# Created in  : 2010.12.10
##
### VERSION HISTORY
##################################################
# Ver1        : Created for WRAN 12.0 sims
# Purpose     : 
# Description : 
# Date        : 10 08 2011
# Who         : Fatih ONUR
##################################################
# Ver2        : Created for WRAN 13A sims
# Purpose     :
# Description : Cell and LA updated
# Date        : 22 08 2012
# Who         : Reshma
##################################################



if [ "$#" -ne 2 ]
then
cat<<HELP

Usage: $0 <start_rnc_num> <end_rnc_num>

Example: $0 1 1

DESCRPTN: Creates UtranCell attrubutes report for WRAN to GRAN IRATHOM

HELP
 exit 1
fi

################################
# CONFIGURATION VARIABLES
################################

######RNC Distribution#############
# [ TYPE=1, NUMOFRC=52, NUMOFRBS=75] ; [..] ; [..] ; [..]
###################################
RNCRBSARRAY="1,11,12;"\
"2,1,2;"

#"1,2,17;"\

#"2,1,15;"\
#"3,1,10;"\
#"4,1,12;"\
#"5,1,10;"\
#"6,3,5;"\
#"7,1,2;"\
#"8,1,8;"


#######RBS CELL Distribution###################
# TYPE1[ TOTALNUMOFCELLS,NUMOFRBS-CELLNUM,NUMOFRBS-CELLNUM,...] ; TYPE2[..] ; TYPE3[..] ; TYPE4[..]
###############################################

RBSCELLARRAY="12,12-1,0-2,0-3,0-6,0-9,0-12;"\
"2,2-1,0-2,0-3,0-6,0-9,0-12;"

#RBSCELLARRAY="77,2-1,5-3,10-6,0-9,0-12;"\
#"75,0-1,5-3,10-6,0-9,0-12;"\
#"75,0-1,5-3,10-6,0-9,0-12;"\
#"32,2-1,10-3,0-6,0-9,0-12;"\
#"30,0-1,10-3,0-6,0-9,0-12;"\
#"15,0-1,5-3,0-6,0-9,0-12;"\
#"6,0-1,2-3,0-6,0-9,0-12;"\
#"18,3-1,5-3,0-6,0-9,0-12;"


################################
# FUNCTIONS
################################

#
# calculates  group
#   eg. COUNT=5 NUMOFELM=3; GROUP-1= 1,2,3  GROUP-2= 4,5,6... so 5 is under group-2
#
getGroup() # COUNT NUMOFELM
{
COUNT=$1
NUMOFELM=$2

MOD=`expr $COUNT % $NUMOFELM`
DIV=`expr $COUNT / $NUMOFELM`

if [ "$MOD" -eq 0 ]
then
  GROUP=$DIV
else
  GROUP=`expr $DIV + 1`
fi

echo $GROUP
}
####GetLASTART############################
getLAStart() # RNCCOUNT SHARE RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
SHARE=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

NUMOFLAS=0
TOTALNUMOFLAS=0

COUNT=1
while [ "$COUNT" -le $RNCCOUNT ]
do
  NUMOFCELLS=`getTotalCells $COUNT $RNCRBSARRAY $RBSCELLARRAY`
  NUMOFLAS=`getGroup $NUMOFCELLS $SHARE`
  TOTALNUMOFLAS=`expr $TOTALNUMOFLAS + $NUMOFLAS`

  COUNT=`expr $COUNT + 1`
done

echo $(($TOTALNUMOFLAS + 1 - $NUMOFLAS))

}


#GETLA###############

getLA() # CELLCOUNT SHARE LASTART TOTALCELLS RNCCOUNT
{
CELLCOUNT=$1
SHARE=$2
LASTART=$3
TOTALRBSCELLS=$4
RNCCOUNT=$5

COUNT=`expr $CELLCOUNT - \( $TOTALRBSCELLS \* \( $RNCCOUNT - 1 \) \)`

INC=`getGroup $COUNT $SHARE`
LACOUNT=`expr $LASTART + $INC - 1`
#echo $LACOUNT

}


#
## get total cumulative num of cells up to specified cell count and rnc
#
getCumulativeTotalCells() # RNCCOUNT $COUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
COUNT=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

NUMOFRNC=0
CUM=0
IFS=";"

for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  TYPE=$(echo $x | awk -F"," '{print $1}')
  TOTALRBSCELLS=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $1}'`
  NUMOFRBS=`echo $x | awk -F"," '{print $3}'`
  CURRENT_NUMOFRNC=$(echo $x | awk -F"," '{print $2}')

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then

    PRE_NUMOFRNC=`expr $NUMOFRNC - $(echo $x | awk -F"," '{print $2}')`
    DIFF=`expr $RNCCOUNT - $PRE_NUMOFRNC`
    CUM=`expr $CUM + $DIFF \* $TOTALRBSCELLS`
    CUM=`expr $CUM - \( $TOTALRBSCELLS - $COUNT \)`

    echo $CUM
    break
  else
    CUM=`expr $CUM + $CURRENT_NUMOFRNC \* $TOTALRBSCELLS`
  fi

done;
}

#
# get total num of cell per each RBS
#
getNumOfCell() # RNCCOUNT RBSCOUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
RBSCOUNT=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

NUMOFRNC=0
IFS=";"

for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    RBSCELLARRAYATR=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}'`

    IFS=","
    bar=( $RBSCELLARRAYATR )
    TOTALSUBNUMOFRBS=0

    for (( i=1; i<${#bar[@]}; i++ )); do
      SUBNUMOFRBS=`echo ${bar[$i]} | awk -F "-" '{print $1}'`
      TOTALSUBNUMOFRBS=`expr $SUBNUMOFRBS + $TOTALSUBNUMOFRBS`

      if [ "$RBSCOUNT" -le "$TOTALSUBNUMOFRBS" ]
      then
        NUMOFCELL=`echo ${bar[$i]} | awk -F "-" '{print $2}'`
        break
      fi
    done;
    echo $NUMOFCELL
    break
  fi
done;
}

# Add leading zeros
zero() { # number, length
    # Need to remove leading 0, might cause the value to be 
    # interpreted as octal
    case "$1" in
	0) 
	    N="$1"
	    ;;
	0*)
	    N=`echo "$1"| cut -c2-`
	    ;;
	*) 
	    N="$1"
	    ;;
    esac
    case "$2" in
	2) 
         printf "%.2d" "$N"
	 ;;
	3) 
         printf "%.3d" "$N"
	 ;;
	*) 
         printf "%d" "$N"
	 ;;
    esac
}

rbs_name() # rncnumber rbsnumber
{
    echo "`rnc_name $1`RBS`zero $2 2`"
}
rxi_name() # rncnumber rxinumber
{
    echo "`rnc_name $1`RXI`zero $2 2`"
}
rnc_name() # rncnumber
{
    echo "RNC`zero $1 2`"
}
 
cell_name() # rncnumber rbsnumber cellnumber
{
    case  "$CELLNAME" in
	gsm) 
	   echo "`zero $1 2``zero $2 3`_$3"
	   ;;

	*)
           echo "`rnc_name $1`-$2-$3"
	   ;;
    esac
}

#
## get total numb of cells for defined num of RBS
#
getTotalCells() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{

RNCCOUNT=$1
RNCRBSARRAY=$2
RBSCELLARRAY=$3

NUMOFRNC=0
IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    TOTALRBSCELLS=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $1}'`
    NUMOFRBS=`echo $x | awk -F"," '{print $3}'`

    #echo "RNCCOUNT="$RNCCOUNT
    #echo "NUMOFRBS="$NUMOFRBS
    #echo "NUMOFRNC="$NUMOFRNC
    #echo "TYPE="$TYPE
    #echo "TOTALCELLS="$TOTALCELLS
    echo $TOTALRBSCELLS
    break
  fi
done;
}

#
#### IRATHOM ATTRIBUTES FOR WRAN TO WRAN
#  
MCC=46
MNC=6
EXTMNC=7
MNCLENGTH=2


################################
# MAIN
################################

#echo "#...script started running at "`date`
#echo "#"

#########################################
# CREATE REPORT FOR IRATHOM
#########################################

#echo "#"
#echo "#CREATING A REPORT FOR IRATHOM (supported by qfatonu)"
#echo "#"

#echo "###################################"
#echo "# STANDARD PLMNIDENDITY ATTRIBUTES"
#echo "###################################"
#echo "MCC=$MCC;MNC=$MNC;MNCLENGTH=$MNCLENGTH"
#echo ""

RNCSTART=$1
RNCEND=$2
RCOUNT=$RNCSTART
LacId=1


#########Need to be update the following variables based#########
#########on <areasDist> tag from "config.xml"####################
####Sample distribution    
#<areasDist>
#<value startRnc="1" endRnc="23" share="21"></value>
#<value startRnc="24" endRnc="55" share="31"></value>
#</areasDist>

#################################################################
RNCSTART_GRP1=1
RNCEND_GRP1=23
GROUP1_NUMELM=95

RNCSTART_GRP2=24
RNCEND_GRP2=55
GROUP2_NUMELM=111
#############End of updating values##############################

while [ "$RCOUNT" -le "$RNCEND" ]
do

RNC=$RCOUNT

if [ "$RNC" -le 9 ]
then
  RNCNAME="RNC0"$RNC
  RNCCOUNT="0"$RNC
else
  RNCNAME="RNC"$RNC
  RNCCOUNT=$RNC
fi

################################
# ENVIRONMENT VALUES
################################

COUNT=1
RBSCOUNT=1
CELLCOUNT=1

NUMOFELMG1=0
NUMOFELMG2=0
TOTALRBSCELLS=`getTotalCells $RNCCOUNT $RNCRBSARRAY $RBSCELLARRAY`
PICOCELLS=0

TOTALCELLS=$TOTALRBSCELLS

# Num of cell has sharing same LA/RA
SHARE=95

##

START_CUMTOTALCELLS=`getCumulativeTotalCells $RNCCOUNT 1 $RNCRBSARRAY $RBSCELLARRAY`

CID=$START_CUMTOTALCELLS

#echo "###################################"
#echo "# "$RNCNAME
#echo "###################################"

while [ "$COUNT" -le "$TOTALCELLS" ]
do

  SA=$CID

#####LA,RA Values###################

if [ "$RNC" -le "$RNCEND_GRP1" ]
then
    if [ "$NUMOFELMG1" -lt "$GROUP1_NUMELM" ]
    then
        NUMOFELMG1=`expr $NUMOFELMG1 + 1`
    else
        NUMOFELMG1=1
        LacId=`expr $LacId + 1`
    fi
elif [[ "$RNC" -ge "$RNCSTART_GRP2" && "$RNC" -le "$RNCEND_GRP2" ]]
then
    if [ "$NUMOFELMG2" -lt "$GROUP2_NUMELM" ]
    then
       	NUMOFELMG2=`expr $NUMOFELMG2  + 1`
    else
       	NUMOFELMG2=1
       	LacId=`expr $LacId + 1`
    fi
fi

LA=$LacId
RES=`expr $LA % 255`
if [ "$RES" == 0 ]
then
	RA=255
else
	RA=$RES
fi
##############################


  NUMOFCELL=`getNumOfCell $RNCCOUNT $RBSCOUNT $RNCRBSARRAY $RBSCELLARRAY`
  CELLSTOP=`expr $NUMOFCELL + 1`

  if [ "$CELLCOUNT" -eq "$CELLSTOP" ]
  then
    CELLCOUNT=1
    RBSCOUNT=`expr $RBSCOUNT + 1`
  fi

  UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`
  UARFCNDL=`expr \( 10562 + \( $RNCCOUNT % \( 10838 - 10562 \) \) \)`

  PRIMSCRCODE=`expr $COUNT % 512`
  PRIMARYCPICHPOWER=300
  QRXLEVMIN=-115
  QQUALMIN=-24
  SRATSEARCH=4
  MAXIMUMTRANSMISSIONPOWER=398

  USEDFREQTHRESH2DRSCP=-100
  USEDFREQTHRESH2DECNO=-12
  SRATSEARCH=4

  OUTPUT=WRAN

  #OUTPUT=GRAN
  ###################################################
  #
  # According to your need modify output from below
  # START: OUTPUT
  ###################################################


  if [ $OUTPUT == "GRAN" ]
  then
    echo "RNCID:"$RNCCOUNT" CI:"$CID" USERLABEL:"$UTRANCELLID" FDDARFCN:"$UARFCNDL" SCRCODE:"$PRIMSCRCODE" PRIMARYCPICHPOWER:"$PRIMARYCPICHPOWER
    echo -n "  QQUALMIN:"$QQUALMIN" LAC:"$LA" QRXLEVMIN:"$QRXLEVMIN" USEDFREQTHRESH2DECNO:"$USEDFREQTHRESH2DECNO
    echo " USEDFREQTHRESH2DRSCP:"$USEDFREQTHRESH2DRSCP" SRATSEARCH:"$SRATSEARCH
    echo ""
  elif [ $OUTPUT == "WRAN" ]
  then
   # echo "ROWID=$CID;EXTUCFDDID=$UTRANCELLID;MUCID=$UTRANCELLID;USERLABEL=$UTRANCELLID;LAC=$LA;PCID=$PRIMSCRCODE;CID=$CID;RAC=$RA;ARFCNVDL=$UARFCNDL;RNCID=$RNCCOUNT;UARFCNUL=12;RNCNAME=$RNCNAME"
echo "SubNetwork=$RNCNAME,MeContext=$RNCNAME,ManagedElement=1,RncFunction=1,UtranCell=$UTRANCELLID"
  fi



  #echo "CID=$CID;UTRANCELLID=$UTRANCELLID;RNCCOUNT=$RNCCOUNT;RBSCOUNT=$RBSCOUNT;CELLCOUNT=$CELLCOUNT"
  

  # END: OUTPUT
  ######################################################

  if [ $CID -eq 10000 ]
  then
    echo "...script ended at "`date`
    echo ""
    exit
  fi

  CID=`expr $CID + 1`
  
  # For testing. To quit at required amount
  #if [ "$COUNT" -eq 13 ]
  #then
  #  break
  #  exit 1
  #fi

  CELLCOUNT=`expr $CELLCOUNT + 1`
  COUNT=`expr $COUNT + 1`
done
  LacId=`expr $LacId + 1`
  RCOUNT=`expr $RCOUNT + 1`
done


#echo "...script ended at "`date`
#echo ""

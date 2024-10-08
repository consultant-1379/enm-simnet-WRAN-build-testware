#!/bin/sh 

# Created by  : unknown
# Created in  : unknown
##
### VERSION HISTORY
###############################################
# Ver2        : Moddified in WRAN 0-10.3
# Purpose     :
# Description : getMinValue and getMaxValue functions added for 1030createExtUtranCell.sh in WRAN O-10.3
# Date        : 13 07 2010
# Who         : Fatih ONUR
###############################################
# Ver3        : Moddified in WRAN 0-11.0
# Purpose     :
# Description : getMinValue and getMaxValue functions added for 1030createExtUtranCell.sh in WRAN O-10.3
# Date        : 19 08 2010
# Who         : Fatih ONUR
###############################################
# Ver4        : Moddified in WRAN 0-11.2
# Purpose     :
# Description : 
# Date        : 23.03.2011
# Who         : Fatih ONUR
###############################################
# Ver4        : Moddified in WRAN 13A
# Purpose     :
# Description :
# Date        : 23.08.2012
# Who         : Fatih ONUR
###############################################
##########################################3
# Ver5        : Modified for PICO node
# Purpose     : To include PICO also in the sim design
# Description : Along with RNC,RBS,RXI PICO is also include for SIM design
# Date        : 2013.08.06
# Who         : EAGACHI



#
# File to be sourced in every simgen script to define some
# utility "good to have" functions
#


# create port
setup_port() # portname
{
    echo ".select configuration"
    echo ".config deleteport $1"
    echo ".config save"
    echo ".config add port $1 iiop `hostname`"
    echo ".config port address $1 commonhttpd no_value no_value no_value no_value"
    echo ".config save"
}

# Create simulation
create_simulation() # Simname
{
    echo ".deletesimulation $1 force"
    echo ".new simulation $1"
}

# Import kertayle file
import_kertayle() # simname nename filename
{
    echo '.open '$1 
    echo '.select '$2 
    echo '.start'
    echo 'kertayle:file="'$3'";' 
}

# Run mml script
run_mmlscript() # mmlfile
{
    #$NETSIMDIR/$NETSIMVERSION/netsim_pipe < $1
    /netsim/inst/netsim_pipe < $1
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
# gets max value of given group. ex num=17 and group consist of 8 units. max value for group is 24
#
getMinValue()
{
NUM=$1
DIVISOR=$2
REM=`expr $NUM % $DIVISOR`
NEEDED=`expr $DIVISOR - $REM`

if [ "$REM" -ne 0 ]
then
  MIN=`expr $NUM - $REM + 1`
else
  MIN=`expr $NUM - $DIVISOR + 1`
fi

echo $MIN
}

#
# gets min value of given group. ex num=19 and group consist of 8 units. min value for group is 17
#
getMaxValue()
{
NUM=$1
DIVISOR=$2
REM=`expr $NUM % $DIVISOR`
NEEDED=`expr $DIVISOR - $REM`

if [ "$REM" -ne 0 ]
then
  MAX=`expr $NUM + $NEEDED`
else
  MAX=`expr $NUM + $REM`
fi

echo $MAX
}


#
## get MIM version
#
getMimType() # RNCCOUNT MIMARRAY
{
RNCCOUNT=$1
MIMARRAY=$2

IFS=";"
for x in $MIMARRAY
do

  FROM=$(echo $x | awk -F"," '{print $1}' | awk -F":" '{print $1}')
  TO=$(echo $x | awk -F"," '{print $1}' | awk -F":" '{print $2}')

  #echo "FROM="$FROM 
  #echo "TO="$TO

  if [ "$RNCCOUNT" -ge "$FROM" ] && [ "$RNCCOUNT" -le "$TO" ]
  then
    MIMVERSION=$(echo $x | awk -F"," '{print $2}')
    #echo "MIMVERSION="$MIMVERSION
    echo $MIMVERSION
    break
  fi

done;
}

#
## reads array to find out item according to range from given id
# e.g range 1 to 10 has X, range 11 to 11 has Y
#
getItemFromArray() # ID ARRAY
{
ID=$1
ARRAY=$2

OUTPUT=0
IFS=";"
for ITEM in $ARRAY
do

  FROM=$(echo $ITEM | awk -F"," '{print $1}' | awk -F":" '{print $1}')
  TO=$(echo $ITEM | awk -F"," '{print $1}' | awk -F":" '{print $2}')

  #echo "FROM="$FROM
  #echo "TO="$TO

  if [ "$ID" -ge "$FROM" ] && [ "$ID" -le "$TO" ]
  then
    OUTPUT=$(echo $ITEM | awk -F"," '{print $2}')
    #echo "OUTPUT="$OUTPUT
    echo $OUTPUT
    break
  fi

done;

#if [ $OUTPUT -eq 0 ]; then echo "0"; fi
}

#
## reads array to find out items(list) according to range from given id
# e.g range 1 to 10 has Xlist, range 11 to 11 has Ylist
#
getItemsFromArray() # ID ARRAY
{
RNCCOUNT=$1
ARRAY=$2

LIST="0"

IFS=";"
for x in $ARRAY
do

  FROM=$(echo $x | awk -F"," '{print $1}' | awk -F":" '{print $1}')
  TO=$(echo $x | awk -F"," '{print $1}' | awk -F":" '{print $2}')

  #echo "FROM="$FROM
  #echo "TO="$TO

  if [ "$RNCCOUNT" -ge "$FROM" ] && [ "$RNCCOUNT" -le "$TO" ]
  then
    LIST=$(echo $x | awk -F"," '{for(i=2;i<=NF;i++)print $i;}')
    #echo "LIST="$LIST
    echo $LIST
    break
  fi

done;

if [ $LIST == "0" ]; then echo "0"; fi
}

#
## Print transport script name
#
getTransportScript() # TRANSPORT_SCRIPT_ID <RNC_TRANSPORT_SCRIPTS or RBS_TRANSPORT_SCRIPTS or RXI_TRANSPORT_SCRIPTS>
{
ID=$1
ARRAY=$2
OUTPUT=`echo $ARRAY | awk -F";" '{print $'\$ID'}' | awk -F"-" '{print $2}'`
echo $OUTPUT
}


#
## reads array to find out items(list) according to range from given id
# e.g range 1 to 10 has Xlist, range 11 to 11 has Ylist
#
getTransportDistributionArray(){

NUMOFRBS=$1
RBSTRANSPORTARRAY=$2
LIST=$3
#echo "LIST="$LIST
#exit

TOTAL_PERCENTAGE=0
RBS_TRANSPORT_DISTRIBUTION_ARRAY=""
RBSSTART=0
RBSEND=0

#IFS=" "
for ITEM in $LIST
do
  #echo "ITEM="$ITEM
  PERCENTAGE=$(echo $ITEM | awk -F"-" '{print $1}')
  SCRIPT_ID=$(echo $ITEM | awk -F"-" '{print $2}')

  #echo "  PERCENTAGE=$PERCENTAGE"
  #echo "  SCRIPT_ID="$SCRIPT_ID

  TOTAL_PERCENTAGE=`expr $TOTAL_PERCENTAGE + $PERCENTAGE`
  #echo "  TOTAL_PERCENTAGE="$TOTAL_PERCENTAGE

  RBSSTART=`expr $RBSEND + 1`
  NUMBER_VALUE_OF_PERCANTAGE=`expr \( $NUMOFRBS \* $PERCENTAGE \) / 100`
  RBSEND=`expr \( $NUMOFRBS \* $PERCENTAGE \) / 100 + $RBSEND`

  if [ $TOTAL_PERCENTAGE -eq 100 ]
  then
    RBSEND=$NUMOFRBS
  fi


  RBS_TRANSPORT_DISTRIBUTION_ARRAY=$RBS_TRANSPORT_DISTRIBUTION_ARRAY""$RBSSTART":"$RBSEND","$SCRIPT_ID";"
done

echo $RBS_TRANSPORT_DISTRIBUTION_ARRAY
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
    TOTALCELLS=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $1}'`
    NUMOFRBS=`echo $x | awk -F"," '{print $3}'`

    echo $TOTALCELLS
    break
  fi
done;
}

#
## get RNC type either 1,2,3 or 4
#
getRncType() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
RNCRBSARRAY=$2
RBSCELLARRAY=$3

IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    #echo "TYPE="$TYPE
    echo $TYPE
    break
  fi
done;
}


#
## get total numb of RBS for defined RNCCOUNT e.g. RNCCOUNT=52 getNumOfRBS returns 75
#
getNumOfRBS() # RNCCOUNT RNCRBSARRAY 
{

RNCCOUNT=$1
RNCRBSARRAY=$2

NUMOFRNC=0
IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`


  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    NUMOFRBS=`echo $x | awk -F"," '{print $3}'`

   
    echo $NUMOFRBS

    break
  fi
done;
}
#END

#RNCPICOARRAY="1,1:750;"\

getNumOfPICO()
{
	RNCCOUNT=$1
	RNCPICOARRAY=$2
	NUMOFPICO=0
	IFS=";"
	for x in $RNCPICOARRAY
	do

		FROM=$(echo $x | awk -F":" '{print $1}' | awk -F"," '{print $1}')
		TO=$(echo $x | awk -F":" '{print $1}' | awk -F"," '{print $2}')

  
		if [ "$RNCCOUNT" -ge "$FROM" ] && [ "$RNCCOUNT" -le "$TO" ]
			then
			NUMOFPICO=$(echo $x | awk -F":" '{print $2}')
			echo $NUMOFPICO
			break
		fi

	done;

}
#RNCDG2ARRAY="10,10:10;" 
getNumOfDG2()
{
	RNCCOUNT=$1
	RNCDG2ARRAY=$2
	NUMOFDG2=0
	IFS=";"
	for x in $RNCDG2ARRAY
	do

		FROM=$(echo $x | awk -F":" '{print $1}' | awk -F"," '{print $1}')
		TO=$(echo $x | awk -F":" '{print $1}' | awk -F"," '{print $2}')

  
		if [ "$RNCCOUNT" -ge "$FROM" ] && [ "$RNCCOUNT" -le "$TO" ]
			then
			NUMOFDG2=$(echo $x | awk -F":" '{print $2}')
			echo $NUMOFDG2
			break
		fi

	done;

}


#
## get total numb of nodes up to entered RNC count
#
getStartIP() # RNCCOUNT RNCRBSARRAY RBSCELLARRAY
{

RNCCOUNT=$1
RNCDG2ARRAY=$2
TOTALNUMOFNODES=0

for (( i=1; i<= $RNCCOUNT; i++ ));
do 
  #break

  NUMOFDG2=`getNumOfDG2 $i $RNCDG2ARRAY`
  TOTALNUMOFNODES=`expr $TOTALNUMOFNODES  + $i + $NUMOFDG2 + 5`
done
echo $(($TOTALNUMOFNODES - $NUMOFRBS - $NUMOFPICO - 4 ))
}


#END

#
## get total num of RBS for defined RNC and CELLTYPE
#
getNumOfRBSofCellType() # RNCCOUNT CELLTYPE RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
CELLTYPE=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

case "$CELLTYPE"
in
  1) CELLTYPE=2;; #POSITION in the RBSCELLARRAY
  3) CELLTYPE=3;;
  6) CELLTYPE=4;;
  9) CELLTYPE=5;;
  12) CELLTYPE=6;;
esac


NUMOFRNC=0
IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    NUMOFRBS_FOR_CELLTYPE=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $'\$CELLTYPE'}' | awk -F"-" '{print $1}'`

    echo $NUMOFRBS_FOR_CELLTYPE
    break
  fi
done;
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
  echo "NUMOFRNC="$NUMOFRNC

  TYPE=$(echo $x | awk -F"," '{print $1}')
  TOTALCELLS=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}' | awk -F"," '{print $1}'`
  NUMOFRBS=`echo $x | awk -F"," '{print $3}'`
  CURRENT_NUMOFRNC=$(echo $x | awk -F"," '{print $2}')
  echo "CURRENT_NUMOFRNC="$CURRENT_NUMOFRNC

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then

    PRE_NUMOFRNC=`expr $NUMOFRNC - $(echo $x | awk -F"," '{print $2}')`
    DIFF=`expr $RNCCOUNT - $PRE_NUMOFRNC`
    CUM=`expr $CUM + $DIFF \* $TOTALCELLS`
    CUM=`expr $CUM - \( $TOTALCELLS - $COUNT \)`
    echo $CUM
    break
  else
    CUM=`expr $CUM + $CURRENT_NUMOFRNC \* $TOTALCELLS`
  fi

done;

}

#
## get num of EutranFreqRelation for each cell, according to specified percantage
#
getNumOfEutranFreqRel() # CELLCOUNT,TOTALCELLS
{
CELLCOUNT=$1
TOTALCELLS=$2

#
# User Configurable
# Num of relations per UtranCells for each band
#
BAND_A=8
BAND_B=4
BAND_C=2
BAND_D=1

#
# User Configurable
# Percantage portion of each band
#
BAND_A_PERC=5
BAND_B_PERC=5
BAND_C_PERC=40
BAND_D_PERC=50

#
# Not User Configurable
# Calculated percantage portion of each band
#
BAND_B_SWITCH_PERC=`expr $BAND_A_PERC + 0`
BAND_C_SWITCH_PERC=`expr $BAND_A_PERC + $BAND_B_PERC`
BAND_D_SWITCH_PERC=`expr $BAND_A_PERC + $BAND_B_PERC + $BAND_C_PERC`

#
# Not User Configurable
# Calculated switch cell percantage portion of each band
#
SWITCH_TO_BAND_B=`expr \( $TOTALCELLS \* $BAND_B_SWITCH_PERC \) / 100 + 1`
SWITCH_TO_BAND_C=`expr \( $TOTALCELLS \* $BAND_C_SWITCH_PERC \) / 100 + 1`
SWITCH_TO_BAND_D=`expr \( $TOTALCELLS \* $BAND_D_SWITCH_PERC \) / 100 + 1`
#echo "SWITCH_TO_BAND_B="$SWITCH_TO_BAND_B
#echo "SWITCH_TO_BAND_C="$SWITCH_TO_BAND_C
#echo "SWITCH_TO_BAND_D="$SWITCH_TO_BAND_D

#
# Not User Configurable
# Num of relations are set according to within defined percantage volume
#
if [ "$CELLCOUNT" -ge "1" ]
then
  NUMOFREL=$BAND_A
fi

if [ "$CELLCOUNT" -ge "$SWITCH_TO_BAND_B" ]
then
  NUMOFREL=$BAND_B
fi

if [ "$CELLCOUNT" -ge "$SWITCH_TO_BAND_C" ]
then
  NUMOFREL=$BAND_C
fi

if [ "$CELLCOUNT" -ge "$SWITCH_TO_BAND_D" ]
then
  NUMOFREL=$BAND_D
fi

echo $NUMOFREL
}


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


#
# calculates LASTART
#   eg. 
#
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

#
##GETLA
#
getLA() # CELLCOUNT SHARE LASTART START_CUMTOTALCELLS RNCCOUNT
{
CELLCOUNT=$1
SHARE=$2
LASTART=$3
START_CUMTOTALCELLS=$4
RNCCOUNT=$5

COUNT=`expr $CELLCOUNT - $START_CUMTOTALCELLS + 1`

INC=`getGroup $COUNT $SHARE`
LACOUNT=`expr $LASTART + $INC - 1`
echo $LACOUNT

}

#
# get num of cell per each RBS
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
    #echo "bar="${bar[0]}

    for (( i=1; i<${#bar[@]}; i++ )); do
      SUBNUMOFRBS=`echo ${bar[$i]} | awk -F "-" '{print $1}'`
      TOTALSUBNUMOFRBS=`expr $SUBNUMOFRBS + $TOTALSUBNUMOFRBS`
      if [ "$RBSCOUNT" -le "$TOTALSUBNUMOFRBS" ]
      then
        NUMOFCELL=`echo ${bar[$i]} | awk -F "-" '{print $2}'`
        #echo "NUMOFCELL="$NUMOFCELL
        break
      fi
    done;
    echo $NUMOFCELL
    break
  fi
done;
}


#####################################################################################################
# finds the start Target Cell ID which current cell make bi-directional inter relation. Ex. below
#####################################################################################################
#
# CURRENTCID=1 CURRENTRNC=1 TARGETRNC=2
# 1: 1 -> 2 - 1   or   CID= 1 -> iurLink=2 - CID=796
# 2: 1 -> 2 - 2   or   CID= 1 -> iurLink=2 - CID=797
# 3: 1 -> 2 - 3   or   CID= 1 -> iurLink=2 - CID=798
# 4: 1 -> 2 - 4   or   CID= 1 -> iurLink=2 - CID=799
getStartTargetCID() # CID, TEMPEXCESS, NUMOFELMOF_CELLGROUP
{
CID=$1
TEMPEXCESS=$2
NUMOFELMOF_CELLGROUP=$3


TEMP_CID=`expr $CID - $TEMPEXCESS`

MOD=`expr $TEMP_CID % $NUMOFELMOF_CELLGROUP`
DIV=`expr $TEMP_CID / $NUMOFELMOF_CELLGROUP`

if [ "$MOD" -eq 0 ]
then
  CELLGROUP=$DIV
else
  CELLGROUP=`expr $DIV + 1`
fi

TEMP_STARTTARGETCID=`expr $CELLGROUP \* $NUMOFELMOF_CELLGROUP - \( $NUMOFELMOF_CELLGROUP - 1 \)`
PRE_STARTTARGETCID=`expr $TEMP_STARTTARGETCID + $TEMPEXCESS`

echo $PRE_STARTTARGETCID
}


#  IRATHOM VERSION
## Gettig UtranCellId in the format of <RNCNO>-<RBSNO>-<CELLNO>
##  for ExternalUtranCells for better readability of cell
#
getUtranCellIdForOtherWRAN() # CID
{
CID=$1

#
# Num of cells per RBS for each band
#
BAND_A=5
DEFAULT=5

#
## Num of rbs per band
#
NUMOFRBS_TYPE_C_BAND_A=50   # 5 cells per RBS

#
## Total num of cells per type
#
TOTALCELLS_TYPE_C_BAND_A=`expr \( $NUMOFRBS_TYPE_C_BAND_A \* $BAND_A \)`

TOTALCELLS_TYPE_C=200

RNCCOUNT=`getGroup $CID $TOTALCELLS_TYPE_C`

MOD=`expr $CID % $TOTALCELLS_TYPE_C`
if [ "$MOD" -eq 0 ]; then  MOD=$TOTALCELLS_TYPE_C ; fi

COUNT=$MOD


if [ "$COUNT" -le "$TOTALCELLS_TYPE_C_BAND_A" ]
then
    RBSCOUNT=`getGroup $COUNT $BAND_A`
    CELLCOUNT=`expr $COUNT % $BAND_A`
    if [ "$CELLCOUNT" -eq 0 ]; then  CELLCOUNT=$BAND_A ; fi
fi

UTRANCELLID=`cell_name $RNCCOUNT $RBSCOUNT $CELLCOUNT`

echo $UTRANCELLID
}


#
## get the Target Iurlink for each RNC
#
#
# RNCGROUP: =1 for RNC01,2,3,4,5,6,7,8: =2 for RNC09,10,11,12,13,14,15,16 ........
#
getIurLink() # RNCCOUNT "MIN|MAX"
{
RNCCOUNT=$1
KEY=$2

  MAXIMUM=0
  MINIMUM=999

  NUMOF_PROXY_TYPE=4
  START=1
  STOP=$NUMOF_PROXY_TYPE

  PCOUNT=$START
  while [ "$PCOUNT" -le "$STOP" ]
  do
    case "$PCOUNT"
    in
      1) NUMOFELMOF_RNCGROUP=2 ;;
      2) NUMOFELMOF_RNCGROUP=3 ;;
      3) NUMOFELMOF_RNCGROUP=4 ;;
      4) NUMOFELMOF_RNCGROUP=8 ;;
    esac

    MIN=`getMinValue $RNCCOUNT $NUMOFELMOF_RNCGROUP`
    MAX=`getMaxValue $RNCCOUNT $NUMOFELMOF_RNCGROUP`

    if [ "$MIN" -lt "$MINIMUM" ]
    then
      MINIMUM=$MIN
    fi

    if [ "$MAX" -gt "$MAXIMUM" ]
    then
      MAXIMUM=$MAX
    fi

    # special case: we don't want iurLinks after 
    if [ "$RNCCOUNT" -ge 105 ] && [ "$RNCCOUNT" -le 110 ] 
    then
      if [ "$MAX" -ge 112 ]
      then
        MAXIMUM=111
      fi
    fi
     # special case: we don't want iurLinks after RNC82 upto RNC99
    if [ "$RNCCOUNT" -eq 111 ] 
    then
      if [ "$MAX" -ge 111 ]
      then
        MAXIMUM=110
      fi
    fi

    # special case: we don't want iurLinks
    if [ "$RNCCOUNT" -ge 112 ] 
    then
        MINIMUM=10000
    fi

    PCOUNT=`expr $PCOUNT + 1`
  done

if [ "$KEY" == "MIN" ]
then
  echo $MINIMUM
else
  echo $MAXIMUM
fi
}

#
# get RBS id for the specified cell on certain RNC
#
getRbsId() # RNCCOUNT COUNT RNCRBSARRAY RBSCELLARRAY
{
RNCCOUNT=$1
COUNT=$2
RNCRBSARRAY=$3
RBSCELLARRAY=$4

RBSCOUNT=0
NUMOFRNC=0
COUNTX=0

IFS=";"
for x in $RNCRBSARRAY
do
  NUMOFRNC=`expr $NUMOFRNC + $(echo $x | awk -F"," '{print $2}')`

  if [ "$RNCCOUNT" -le "$NUMOFRNC" ]
  then
    TYPE=$(echo $x | awk -F"," '{print $1}')
    RBSCELLARRAYATR=`echo $RBSCELLARRAY  | awk -F" " '{print $'\$TYPE'}'`
    #echo "RBSCELLARRAYATR="$RBSCELLARRAYATR

    IFS=","
    bar=( $RBSCELLARRAYATR )
    TOTALSUBNUMOFRBS=0
    #echo "bar="${bar[0]}

    for (( i=1; i<${#bar[@]}; i++ )); do
      SUBNUMOFRBS=`echo ${bar[$i]} | awk -F "-" '{print $1}'`
      SUBNUMOFCELL=`echo ${bar[$i]} | awk -F "-" '{print $2}'`
      COUNTZ=1
      while [ "$COUNTZ" -le "$SUBNUMOFRBS" ]
      do
        COUNTX=`expr $COUNTX + $SUBNUMOFCELL`
        #echo "COUNTX="$COUNTX
        RBSCOUNT=`expr $RBSCOUNT + 1`
        if [ "$COUNTX" -ge "$COUNT" ]
        then
          break
        fi
        COUNTZ=`expr $COUNTZ + 1`
      done;

      # exit from loop when totalcellcount reached to targetcellcount
      if [ "$(($COUNTX + 0 ))" -ge "$COUNT" ]
      then
         break
      fi
    done;
    echo $RBSCOUNT
    break
  fi
done;
}


#
## Create Plain Sim
#
createSim() #SIM
{
SIM=$1
echo '.deletesimulation '$SIM' force'
echo '.new simulation '$SIM
}

#
## Create RNC nodes
#
createRNCip() #SIM PORT RNCCOUNT RNCVERSION OFFSET
{
SIM=$1
PORT=$2
RNCCOUNT=$3
RNCVERSION=$4
OFFSET=$5

echo '.open '$SIM
echo '.createne checkport '$PORT
echo '.new simne -auto 1 RNC '$RNCCOUNT
echo '.set netype WCDMA RNC '$RNCVERSION
echo '.set port '$PORT
echo '.createne subaddr '$OFFSET' subaddr no_value'
echo '.set save'
}

createNodeip()
{
SIM=$1
PORT=$2
NODETYPE=$3
NUMOFNODE=$4
NODEVERSION=$5
OFFSET=$6
	
    echo '.open '$SIM
    echo '.createne checkport '$PORT
    echo '.new simne -auto '$NUMOFNODE $NODETYPE' 01'
    echo '.set netype WCDMA' $NODETYPE $NODEVERSION
    echo '.set port '$PORT
    echo '.createne subaddr '$OFFSET' subaddr no_value'
    echo '.set save'

}

createNodeipDG2()
{
SIM=$1
PORT=$2
NODETYPE=$3
NUMOFNODE=$4
NODEVERSION=$5
OFFSET=$6
    echo '.open '$SIM
    echo '.createne checkport '$PORT
    echo '.new simne -auto '$NUMOFNODE $NODETYPE' 01'
    echo '.set netype LTE' $NODETYPE $NODEVERSION
    echo '.set port '$PORT
    echo '.createne subaddr '$OFFSET' subaddr no_value'
    echo '.set save'
	

}


#
## Relate RXI|RNS nodes to the RNC
#
relateNEs()
{
SIM=$1
RNCNAME=$2
echo '.open '$SIM
echo '.selectregexp simne '"$RNCNAME|RBS.*|RXI.*|PRBS.*|MSRBS-V2.*"
echo '.relate'

}


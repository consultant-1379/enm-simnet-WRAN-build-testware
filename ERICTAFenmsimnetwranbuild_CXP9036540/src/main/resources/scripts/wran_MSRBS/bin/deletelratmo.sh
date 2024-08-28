#!/bin/sh

if [ "$#" -ne 3  ]
then
 echo
 echo "Usage: $0 <sim name> <rnc num> <numOfMsrbsNodes>"
 echo
 echo "Example: $0 WegaC5LargeRNC14 SIM1.env 9 (to create RNC09)"
 echo
 exit 1
fi


SIMNAME=$1
NUMOFMSRBS=$3

if [ "$2" -le 9 ]
then
RNCNAME="RNC0"$2
RNCCOUNT="0"$2
else
RNCNAME="RNC"$2
RNCCOUNT=$2
fi


if [ "$2" -eq 0 ]
then
RNCNAME=
fi



PWD=`pwd`


productNumber="CXP9024418/6"
productRevision="R21A43"

NOW=`date +"%Y_%m_%d_%T:%N"`
pdkdate="$NOW"

COUNT=1

while [ "$COUNT" -le "$NUMOFMSRBS"  ]
do
if [ $COUNT -le 9 ]
then
NODENAME=$RNCNAME'MSRBS-V20'$COUNT
else
NODENAME=$RNCNAME'MSRBS-V2'$COUNT
fi
MOSCRIPT=$NODENAME"_dg2Product.mo"
MMLSCRIPT=$NODENAME"_dg2Product.mml"
cat >> $MOSCRIPT << MOSC

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:CellSleepFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:Etws=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:MimoSleepFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA1Prim=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA1Sec=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA4=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA5=1,Lrat:ReportConfigA5Anr=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA5=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA5DlComp=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA5SoftLock=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigA5UlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB1Geran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB1Utra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Cdma2000=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Cdma20001xRtt=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2CdmaRttUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2CdmaUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Geran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2GeranUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Utra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigB2UtraUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbCdma2000=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbGeran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbUtra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigCsg=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBadCovPrim=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBadCovSec=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBestCell=1,Lrat:ReportConfigEUtraBestCellAnr=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBestCell=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraIFA3UlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraIFBestCell=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraInterFreqLb=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraInterFreqMbms=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigElcA1A2=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigInterEnbUlComp=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigInterRatLb=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA1A2=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA4=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA6=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1,Lrat:ReportConfigSearch=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3,Lrat:UeMeasControl=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:CellSleepFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:Etws=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:MimoSleepFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA1Prim=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA1Sec=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA4=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA5=1,Lrat:ReportConfigA5Anr=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA5=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA5DlComp=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA5SoftLock=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigA5UlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB1Geran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB1Utra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Cdma2000=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Cdma20001xRtt=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2CdmaRttUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2CdmaUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Geran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2GeranUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Utra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigB2UtraUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbCdma2000=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbGeran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbUtra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigCsg=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBadCovPrim=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBadCovSec=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBestCell=1,Lrat:ReportConfigEUtraBestCellAnr=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBestCell=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraIFA3UlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraIFBestCell=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraInterFreqLb=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraInterFreqMbms=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigElcA1A2=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigInterEnbUlComp=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigInterRatLb=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA1A2=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA4=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA6=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1,Lrat:ReportConfigSearch=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2,Lrat:UeMeasControl=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:CellSleepFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:Etws=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:MimoSleepFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA1Prim=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA1Sec=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA4=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA5=1,Lrat:ReportConfigA5Anr=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA5=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA5DlComp=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA5SoftLock=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigA5UlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB1Geran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB1Utra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Cdma2000=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Cdma20001xRtt=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2CdmaRttUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2CdmaUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Geran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2GeranUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2Utra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigB2UtraUlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbCdma2000=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbGeran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigCsfbUtra=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigCsg=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBadCovPrim=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBadCovSec=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBestCell=1,Lrat:ReportConfigEUtraBestCellAnr=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraBestCell=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraIFA3UlTrig=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraIFBestCell=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraInterFreqLb=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigEUtraInterFreqMbms=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigElcA1A2=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigInterEnbUlComp=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigInterRatLb=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA1A2=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA4=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigSCellA6=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1,Lrat:ReportConfigSearch=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1,Lrat:UeMeasControl=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AdmissionControl=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AmoFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AnrFunction=1,Lrat:AnrFunctionEUtran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AnrFunction=1,Lrat:AnrFunctionGeran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AnrFunction=1,Lrat:AnrFunctionUtran=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AnrFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AnrPciConflictDrxProfile=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AutoCellCapEstFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:CarrierAggregationFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:CellSleepNodeFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=19"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=18"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=17"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=16"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=15"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=14"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=13"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=12"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=11"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=10"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=9"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=8"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=7"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=6"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=5"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=4"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=3"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=2"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtraNetwork=1,Lrat:EUtranFrequency=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtraNetwork=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:FlexibleQoSFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:ImeisvTable=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:LoadBalancingFunction=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:MdtConfiguration=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:NonPlannedPciDrxProfile=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:Paging=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:ParameterChangeRequests=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:PmEventService=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:PreschedulingProfile=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:LogicalChannelGroup=4"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:LogicalChannelGroup=3"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:LogicalChannelGroup=2"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:LogicalChannelGroup=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=10"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=9"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=8"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=7"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=6"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=5"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=4"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=3"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=2"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:QciProfilePredefined=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=19"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=18"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=17"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=16"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=15"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=14"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=13"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=12"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=11"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=10"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=9"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=8"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=7"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=6"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=5"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=4"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=3"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=2"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default,Lrat:SciProfile=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=default"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1,Lrat:DataRadioBearer=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1,Lrat:MACConfiguration=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1,Lrat:SignalingRadioBearer=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:Rcs=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:ResourcePartitions=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=19"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=18"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=17"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=16"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=15"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=14"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=13"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=12"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=11"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=10"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=9"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=8"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=7"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=6"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=5"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=4"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=3"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=2"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:Rrc=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:SecurityHandling=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:TermPointToSGW=1,Lrat:GtpPath=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:TermPointToSGW=1"
)

// Delete Statement generated: 2018-02-08 13:29:39
DELETE 
(
  mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1"
)




MOSC
echo '.open '$SIMNAME >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
/netsim/inst/netsim_shell < $MMLSCRIPT
rm -rf $MMLSCRIPT
rm -rf $MOSCRIPT
COUNT=`expr $COUNT + 1`
done


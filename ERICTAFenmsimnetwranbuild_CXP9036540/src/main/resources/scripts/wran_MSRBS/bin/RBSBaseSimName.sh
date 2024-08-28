#!/bin/bash

### VERSION HISTORY
####################################################################################
#     Version     : 1.1
#
#     Revision    : CXP 903 6540-1-18
#
#     Author      : zachaja
#
#     JIRA        : NSS-41460
#
#     Description : Copying RcsRem fragment functionality files to SimNetRevision folder in simulation
#
#     Date        : 30th November 2022
#
####################################################################################

SIMNAME=$1
NodeType=MSRBS
NodeVersion=`echo "$SIMNAME" | awk -F 'x' '{print $2}' | sed 's/1-FT-MSRBS-//g' | sed s/-/_/2`
NodeURL="https://netsim.seli.wh.rnd.internal.ericsson.com/tssweb/simulations/com3.1/"
MSRBS_Template=`curl $NodeURL | grep ${NodeType}"_V2_"${NodeVersion} | awk -F "href=" '{print $2}' | awk -F '"' '{print $2}'| cut -d "." -f1 `
#wget $NodeURL/$MSRBS_Template
MSRBS_Template_WithoutZIP=`echo $MSRBS_Template | awk -F '.' '{print $1}'`

cd /netsim/netsimdir/$SIMNAME/
if [ -d SimNetRevision ]
then
cp $BINPATH/../dat/README /netsim/netsimdir/$SIMNAME/SimNetRevision/

cp $BINPATH/../log/*SimulationBuild.log /netsim/netsimdir/$SIMNAME/SimNetRevision/

else
mkdir SimNetRevision
cp $BINPATH/../dat/README /netsim/netsimdir/$SIMNAME/SimNetRevision/

cp $BINPATH/../log/*SimulationBuild.log /netsim/netsimdir/$SIMNAME/SimNetRevision/

fi

if [ -d NrEtcm ]
then
    chmod 777 NrEtcm
    cd NrEtcm/
    rm -rf *
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/etcm_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrEtcm/
else
    mkdir NrEtcm
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/etcm_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrEtcm/
fi

if [ -d NrFtem ]
then
    chmod 777 NrFtem
    cd NrFtem/
    rm -rf *
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ftem_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrFtem/
else
    mkdir NrFtem
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/ftem_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrFtem/
fi

if [ -d NrPmEvents ]
then
    chmod 777 NrPmEvents
    cd NrPmEvents
    rm -rf *
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/pm_event_package_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrPmEvents/
else
    mkdir NrPmEvents
    cp /netsim/netsimdir/$MSRBS_Template_WithoutZIP/Events/pm_event_package_* /netsim/netsimdir/$SIMNAME/SimNetRevision/NrPmEvents/
fi


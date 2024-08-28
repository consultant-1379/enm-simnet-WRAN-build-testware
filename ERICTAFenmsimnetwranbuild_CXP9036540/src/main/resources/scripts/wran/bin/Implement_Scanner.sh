#!/bin/bash
###########################################
## Version2    : 20.02
## Revision    : CXP 903 6540-1-3
## Purpose     : Rectifying the Implement scanners script
## JIRA        : NSS-26915
## Date        : 10th Dec 2019
## Author      : zyamkan
############################################
# Ver1        : Moddified for Scanner
# Purpose     : To Implement scanners for simulation
# Description :
# Date        : 06 07 2017
# Who         : ANUSHA CHITRAM
##########################################################
Sim=$1

if [[ $# -eq 0 ]] ; then
echo 'invalid'
exit 1
fi
cd /netsim/netsimdir
if [ -d "scanner" ];
then
rm -rf /netsim/netsimdir/scanner
echo "removing scanner directory and creating one"
mkdir /netsim/netsimdir/scanner
else
mkdir /netsim/netsimdir/scanner
fi
cp $Sim".zip" /netsim/netsimdir/scanner
cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin
./Scanner_operation.sh ${Sim}


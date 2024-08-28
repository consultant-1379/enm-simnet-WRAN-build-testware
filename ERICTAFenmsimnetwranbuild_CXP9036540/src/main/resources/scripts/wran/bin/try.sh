#!/bin/sh

if [ "$#" -ne 2  ]
then
 echo
 echo "Usage: $0  <env file> <simname>"
 echo
fi

ENV=$1
SIM=$2

. ../dat/$ENV

JARFILE=RNCST/JAR/$RNCMIMTYPE/
echo "$JARFILE"
if [ ! -f $JARFILE ]
then
echo "No Jar file found. Failed to set jar path for $SIM"
echo "-------------------------------------------------------------------"
echo "# $0 script ended ERRONEOUSLY !!!!"
echo "###################################################################"

exit 1
fi



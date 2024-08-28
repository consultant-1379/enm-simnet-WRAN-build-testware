#!/bin/sh
#This script will create delete xml file for WRAN nodes..#

onrm_cstest="/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS"

file="nodeList.txt"

arnefile="delete.xml"
rm $arnefile

echo "list of WRAN nodes to be deleted" > $file

$onrm_cstest lt ManagedElement | grep RBS | grep -v LTE >> $file 
$onrm_cstest lt Group | grep RNC >> $file
$onrm_cstest lt ManagedElement | grep RXI >> $file
$onrm_cstest lt ManagedElement | grep RNC | egrep -v "RBS|RXI" >> $file
$onrm_cstest lt SubNetwork | grep RNC >> $file
$onrm_cstest lt Site | grep RNC >> $file

cat $file | awk '{print "<Object fdn=\""$0"\"/>" }' > modifiedtext.txt

cat >> $arnefile << syntax
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE Model SYSTEM "/opt/ericsson/arne/etc/arne12_2.dtd">
syntax

echo '<Model version="1" importVersion="12.2">' >> $arnefile
echo '<Delete>' >> $arnefile
cat modifiedtext.txt >> $arnefile
echo '</Delete>' >> $arnefile
echo '</Model>' >> $arnefile

rm modifiedtext.txt $file

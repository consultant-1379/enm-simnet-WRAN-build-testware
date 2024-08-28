#!/bin/sh

Pwd=`pwd`
echo "$Pwd"
mkdir jar/testmo
cp -R jar/RNC*/ jar/testmo
cd jar/testmo
find . -type f | xargs perl -pi -e 's/NodeSupport=1,SectorEquipmentFunction/ManagedElement=1,NodeBFunction=1,Sector/g';
cp -R RNC*/ ../

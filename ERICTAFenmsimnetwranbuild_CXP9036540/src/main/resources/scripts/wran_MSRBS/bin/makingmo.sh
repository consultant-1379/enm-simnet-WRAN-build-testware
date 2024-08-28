#!/bin/sh

Pwd=`pwd`
echo "*********************************************"
echo "Removing Userlabel string from the Mo files since it is null and leading to improper kertayle loading"
echo "*********************************************"
mkdir jar/testmo
cp -R jar/RNC*/ jar/testmo
cd jar/testmo
#find . -type f | xargs perl -pi -e 's/NodeSupport=1,SectorEquipmentFunction/ManagedElement=1,NodeBFunction=1,Sector/g';
find . -type f -print0 | xargs -0 sed -i '/userLabel   String ""/d'
cp -R RNC*/ ../
echo "********** Change in the Mo files done and copied back to /bin/jar path ************"



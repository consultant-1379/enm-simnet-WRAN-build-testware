#!/bin/sh
SIM=$1
#RNCNUM=$2

if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV71659x1-FT-RBSU4460x40-RNC01"
 echo
 exit 1
fi

RbsStr=$(echo $SIM | awk -F"RBS" '{print $2}'| awk -F"x" '{print $2}')
RBSNUM=(${RbsStr//-/ })
RncStr=(${SIM//RNC/ })
RNCNUM=${RncStr[1]}
RNCNAME="RNC"$RNCNUM
COUNT=1

while [ $COUNT -le $RBSNUM  ]
do
if [ $COUNT -le 9 ]
then
NODE=$RNCNAME"RBS0"$COUNT".mo"
NODENAME=$RNCNAME"RBS0"$COUNT
else
NODE=$RNCNAME"RBS"$COUNT".mo"
NODENAME=$RNCNAME"RBS"$COUNT
fi
cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/jar/$RNCNAME
find -name $NODE |xargs grep -i "AuxPlugInUnit=" | awk -F"," '{print $3}' | awk -F"=" '{print $2}' | awk -F"\"" '{print $1}' > $NODENAME_"find.txt"
getArray() {
    array=() # Create array
    while IFS= read -r line # Read a line
    do
        array+=("$line") # Append line to the array
    done < "$1"
}

getArray $NODENAME_"find.txt"
len=${#array[@]}
if [ $len -eq 0 ]
then
break
fi
last=`expr $len - 1`
echo ${array[last]}

var="${array[last]}"
echo "MOCOUNT : "$var
rm -rf $NODENAME_"find.txt"
cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/
MoCount=1
while [ $MoCount -le $var  ]
do
MOSCRIPT=$NODENAME"_"$MoCount"_device.mo"
#rm -rf $MOSCRIPT
cat >> $MOSCRIPT << MOSC

CREATE
(
    parent "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount"
    identity "1"
    moType DeviceGroup
    exception none
    nrOfAttributes 6
    "availabilityStatus" Integer 0
    "hwTestResult" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TrDeviceSet=1"
    // moid = 2268
    exception none
    nrOfAttributes 5
    "TrDeviceSetId" String "1"
    "usageState" Integer 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
   
)

// Create Statement generated: 2017-04-27 07:24:12
SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TrDeviceSet=1,TrDevice=1"
    // moid = 2269
    exception none
    nrOfAttributes 6
    "reservedBy" Array Ref 0
    "TrDeviceId" String "1"
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

// Create Statement generated: 2017-04-27 07:24:12
SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TrDeviceSet=1,TrDevice=2"
    // moid = 2270
    exception none
    nrOfAttributes 6
    "reservedBy" Array Ref 0
    "TrDeviceId" String "2"
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,PimcDeviceSet=1"
    // moid = 2271
    exception none
    nrOfAttributes 5
    "usageState" Integer 0
    "PimcDeviceSetId" String "1"
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,DpclDeviceSet=1"
    // moid = 2272
    exception none
    nrOfAttributes 5
    "DpclDeviceSetId" String "1"
    "usageState" Integer 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    
)

// Create Statement generated: 2017-04-27 07:24:12
SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,DpclDeviceSet=1,DpclDevice=1"
    // moid = 2273
    exception none
    nrOfAttributes 6
    "DpclDeviceId" String "1"
    "reservedBy" Array Ref 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TmaDeviceSet=1"
    // moid = 2274
    exception none
    nrOfAttributes 9
    "TmaDeviceSetId" String "1"
    "dlTrafficDelay" Integer 100
    "ulTrafficDelay" Integer 350
    "dlAttenuation" Integer 2
    "tmfData" Struct
        nrOfElements 5
        "ulAirFrequency" Integer 0
        "ulFeederFrequency" Array Integer 0
        "ifBandwidth" Integer 0
        "ulDelay" Array Integer 0
        "dlDelay" Array Integer 0

    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TmaDeviceSet=1,TmaDevice=1"
    // moid = 2275
    exception none
    nrOfAttributes 6
    "reservedBy" Array Ref 0
    "TmaDeviceId" String "1"
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TmaDeviceSet=1,TmaDevice=2"
    // moid = 2276
    exception none
    nrOfAttributes 6
    "reservedBy" Array Ref 0
    "TmaDeviceId" String "2"
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TpaDeviceSet=1"
    // moid = 2277
    exception none
    nrOfAttributes 4
    "TpaDeviceSetId" String "1"
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,TpaDeviceSet=1,TpaDevice=1"
    // moid = 2278
    exception none
    nrOfAttributes 10
    "reservedBy" Array Ref 0
    "TpaDeviceId" String "1"
    "maxTotalOutputPower" Integer -1
    "maxTotalOutputPowerLow" Integer -1
    "txPowerPersistentLock" Boolean false
    "extraPowerHsdpaMixedModePowerSharing" Integer -1
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,AiDeviceSet=1"
    // moid = 2279
    exception none
    nrOfAttributes 5
    "AiDeviceSetId" String "1"
    "usageState" Integer 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,AiDeviceSet=1,AiDevice=1"
    // moid = 2280
    exception none
    nrOfAttributes 7
    "administrativeState" Integer 1
    "AiDeviceId" String "1"
    "reservedBy" Array Ref 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,AiDeviceSet=1,AiDevice=2"
    // moid = 2281
    exception none
    nrOfAttributes 7
    "administrativeState" Integer 1
    "AiDeviceId" String "2"
    "reservedBy" Array Ref 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)
CREATE
(
    parent "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,AiDeviceSet=1"
    // moid = 2280
        moType AiDevice
        identity RXA_IO
    exception none
    nrOfAttributes 7
    "administrativeState" Integer 1
    "AiDeviceId" String "RXA_IO"
    "reservedBy" Array Ref 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)
SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,AiDeviceSet=1,AiDevice=RXA_IO"
    // moid = 2280
    exception none
    nrOfAttributes 7
    "administrativeState" Integer 1
    "AiDeviceId" String "RXA_IO"
    "reservedBy" Array Ref 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)


// Create Statement generated: 2017-04-27 07:24:12
SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,RetDeviceSet=1"
    // moid = 2282
    exception none
    nrOfAttributes 7
    "RetDeviceSetId" String "1"
    "retType" Integer 0
    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    
)

// Create Statement generated: 2017-04-27 07:24:12
SET
(
    mo "ManagedElement=1,Equipment=1,AuxPlugInUnit=$MoCount,DeviceGroup=1,RetDeviceSet=1,RetDevice=1"
    // moid = 2283
    exception none
    nrOfAttributes 10
    "electricalAntennaTilt" Integer 0
    "maxTilt" Integer -1
    "minTilt" Integer -1
    "reservedBy" Array Ref 0
    "RetDeviceId" String "1"
    "aretDeviceData" Struct
        nrOfElements 7
        "antennaOperatingBand" Integer 0
        "beamwidthForBands" Array Integer 0
        "gainForBands" Array Integer 0
        "maxSupportedElectricalTilt" Integer 0
        "antennaBearing" Integer 0
        "installedMechTilt" Integer 0
        "minSupportedElectricalTilt" Integer 0

    "availabilityStatus" Integer 0
    "operationalState" Integer 0
    "usageState" Integer 0
    
)

MOSC

####################################################################################
MMLSCRIPT=$NODENAME"_"$MoCount"_device.mml"
rm -rf $MMLSCRIPT

echo '.open '$SIM >> $MMLSCRIPT
echo '.select '$NODENAME >> $MMLSCRIPT
echo '.start ' >> $MMLSCRIPT
echo 'useattributecharacteristics:switch="off";' >> $MMLSCRIPT
echo 'kertayle:file="'$PWD'/'$MOSCRIPT'";' >> $MMLSCRIPT
MoCount=`expr $MoCount + 1`
~/inst/netsim_shell < $MMLSCRIPT
done
COUNT=`expr $COUNT + 1`
done

cd /netsim/enm-simnet-WRAN-build-testware/ERICTAFenmsimnetwranbuild_CXP9036540/src/main/resources/scripts/wran/bin/
rm -rf *device.mo
rm -rf *device.mml

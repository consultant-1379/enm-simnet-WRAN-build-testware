#!/usr/bin/perl 
use Cwd;

################################
# Vars
################################

local $SIMNAME=$ARGV[0];
local $SIMNUM=$ARGV[1];
local $date=`date`,$NODENAME;
local $dir=cwd,$currentdir=$dir."/";
local $scriptpath="$currentdir";
local $NETSIM_INSTALL_PIPE="/netsim/inst/netsim_pipe";
local $MOSCRIPT="$scriptpath".${0}.".mo";
local $MMLSCRIPT="$scriptpath".${0}.".mml";
local @MOCmds,@MMLCmds,@netsim_output;
local $NETSIMMOSCRIPT,$NETSIMMMLSCRIPT,$NODECOUNT=1;
local $temp=1;
local $NUMOFNODES=350;
local $enbID=(350*($SIMNUM-1));

#############################################################

local @helpinfo=qq(Usage  : ${0} <sim name> <sim num>
Example: $0  RNCV71659-limx1-MSRBS-16Bx10-RNC10 10);
if (!( @ARGV==2)){
   print "@helpinfo\n";exit(1);}

#############################################################


####################
# Integrity Check
####################
if (-e "$NETSIMMOSCRIPT"){
    unlink "$NETSIMMOSCRIPT";}

################################
# MAIN
################################
print "...${0} started running at $date\n";

################################
# Make MO & MML Scripts
################################

while ($NODECOUNT<=$NUMOFNODES){
=pod
if ($NODECOUNT<10) {
    if ($SIMTYPE=="dg2") {
    $NODENAME="LTE${SIMNUM}${SIMTYPE}ERBS0000${NODECOUNT}";
    }
    else {
    $NODENAME="LTE${SIMNUM}ERBS0000${NODECOUNT}";
    }
}
if ($NODECOUNT>=10 && $NODECOUNT<99) {
     if ($SIMTYPE=="dg2") {
    $NODENAME="LTE${SIMNUM}${SIMTYPE}ERBS000${NODECOUNT}";
    }
    else {
    $NODENAME="LTE${SIMNUM}ERBS0000${NODECOUNT}";
    }
}
if ($NODECOUNT>=100) {
    if ($SIMTYPE=="dg2") {
    $NODENAME="LTE${SIMNUM}${SIMTYPE}ERBS000${NODECOUNT}";
    }
    else {
    $NODENAME="LTE${SIMNUM}ERBS0000${NODECOUNT}";
    }
}
=cut
if ($NODECOUNT<10) {
    $NODENAME="RNC${SIMNUM}MSRBS-V20${NODECOUNT}";
    $enbID++;
}
else {
$NODENAME="RNC${SIMNUM}MSRBS-V2${NODECOUNT}";
    $enbID++;
}

print "THE NODENAME IS $NODENAME and enbID is $enbID\n";
	  
	   @MOCmds=qq^

// Create Statement generated: 2016-06-01 07:13:26
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME"
    // moid = 4783
    identity "1"
    moType Lrat:ENodeBFunction
    exception none
    nrOfAttributes 120
    "timeAndPhaseSynchCritical" Boolean false
    "eNodeBFunctionId" String ""
    "userLabel" String "null"
    "sctpRef" Ref "null"
    "dnsLookupOnTai" Integer 1
    "dnsLookupTimer" Int32 0
    "dscpLabel" Int32 24
    "eNBId" Int32 $enbID
    "eNodeBPlmnId" Struct
        nrOfElements 3
        "mcc" Int32 0
        "mnc" Int32 0
        "mncLength" Int32 0

    "x2BlackList" Array Struct 1
        nrOfElements 4
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
        "enbId" Int32 0

    "x2retryTimerMaxAuto" Int32 1440
    "x2retryTimerStart" Int32 30
    "x2WhiteList" Array Struct 1
        nrOfElements 4
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
        "enbId" Int32 0

    "s1RetryTimer" Int32 30
    "ulSchedulerDynamicBWAllocationEnabled" Boolean true
    "x2IpAddrViaS1Active" Boolean true
    "nnsfMode" Integer 1
    "rrcConnReestActive" Boolean false
    "zzzTemporary1" String ""
    "zzzTemporary2" String ""
    "zzzTemporary3" String ""
    "zzzTemporary4" String ""
    "zzzTemporary5" String ""
    "zzzTemporary6" String ""
    "zzzTemporary7" String ""
    "zzzTemporary8" String ""
    "zzzTemporary9" Int32 -2000000000
    "zzzTemporary10" Int32 -2000000000
    "zzzTemporary11" Int32 -2000000000
    "zzzTemporary12" Int32 -2000000000
    "x2SetupTwoWayRelations" Boolean true
    "timePhaseMaxDeviation" Int32 100
    "licCapDistrMethod" Integer 0
    "s1HODirDataPathAvail" Boolean false
    "minRandc" Int32 1
    "maxRandc" Int32 255
    "randUpdateInterval" Int32 200
    "zzzTemporary13" Int32 -2000000000
    "zzzTemporary14" Int32 -2000000000
    "zzzTemporary15" Int32 -2000000000
    "zzzTemporary16" Int32 -2000000000
    "zzzTemporary17" Int32 -2000000000
    "mfbiSupport" Boolean true
    "upIpAddressRef" Ref "null"
    "pwsPersistentStorage" Integer 0
    "csfbMeasFromIdleMode" Boolean true
    "tRelocOverallValue" Int32 5
    "forcedSiTunnelingActive" Boolean false
    "initPreschedulingEnable" Boolean true
    "zzzTemporary18" Int32 -2000000000
    "zzzTemporary19" Int32 -2000000000
    "zzzTemporary20" Int32 -2000000000
    "zzzTemporary21" Int32 -2000000000
    "zzzTemporary22" Int32 -2000000000
    "zzzTemporary23" Int32 -2000000000
    "zzzTemporary24" Int32 -2000000000
    "zzzTemporary25" Int32 -2000000000
    "zzzTemporary26" Int32 -2000000000
    "zzzTemporary27" Int32 -2000000000
    "tOutgoingHoExecCdma1xRtt" Int32 5
    "biasThpWifiMobility" Int32 10
    "tS1HoCancelTimer" Int32 3
    "dnsSelectionS1X2Ref" Ref "null"
    "releaseInactiveUesEnable" Boolean false
    "releaseInactiveUesInactTime" Int32 1
    "releaseInactiveUesMpLoadLevel" Integer 2
    "combCellSectorSelectThreshTx" Int32 300
    "combCellSectorSelectThreshRx" Int32 300
    "timePhaseMaxDeviationSib16" Int32 100
    "timePhaseMaxDeviationMbms" Int32 50
    "timePhaseMaxDeviationOtdoa" Int32 9
    "timePhaseMaxDeviationCdma2000" Int32 100
    "timePhaseMaxDeviationTdd" Int32 15
    "timePhaseSynchStateSib16" Boolean true
    "timePhaseSynchStateMbms" Boolean true
    "timePhaseSynchStateOtdoa" Boolean true
    "timePhaseSynchStateCdma2000" Boolean true
    "timeAndPhaseSynchAlignment" Boolean false
    "licConnectedUsersPercentileConf" Int32 90
    "licDlBbPercentileConf" Int32 90
    "licUlBbPercentileConf" Int32 90
    "licDlPrbPercentileConf" Int32 90
    "licUlPrbPercentileConf" Int32 90
    "mtRreWithoutNeighborActive" Boolean true
    "checkEmergencySoftLock" Boolean false
    "softLockRwRWaitTimerInternal" Int32 60
    "softLockRwRWaitTimerOperator" Int32 60
    "mfbiSupportPolicy" Boolean false
    "zzzTemporary28" Int32 -2000000000
    "zzzTemporary29" Int32 -2000000000
    "zzzTemporary30" Int32 -2000000000
    "zzzTemporary31" Int32 -2000000000
    "zzzTemporary32" Int32 -2000000000
    "zzzTemporary33" Int32 -2000000000
    "zzzTemporary34" Int32 -2000000000
    "tddVoipDrxProfileId" Int32 -1
    "measuringEcgiWithAgActive" Boolean false
    "enabledUlTrigMeas" Boolean false
    "adaptiveRlcRetxDl" Boolean false
    "ulMaxWaitingTimeGlobal" Int32 0
    "dlMaxWaitingTimeGlobal" Int32 0
    "tRelocOverall" Int32 5
    "alignTtiBundWUlTrigSinr" Integer 0
    "s1GtpuEchoEnable" Integer 0
    "x2GtpuEchoEnable" Integer 0
    "s1GtpuEchoDscp" Int32 14
    "x2GtpuEchoDscp" Int32 14
    "gtpuErrorIndicationDscp" Int32 40
    "s1GtpuEchoFailureAction" Integer 0
    "bbVlanPortRef" Ref "null"
    "zzzTemporary35" Int32 -2000000000
    "zzzTemporary36" Int32 -2000000000
    "zzzTemporary37" Int32 -2000000000
    "zzzTemporary38" Int32 -2000000000
    "zzzTemporary39" Int32 -2000000000
    "zzzTemporary40" Int32 -2000000000
    "caAwareMfbiIntraCellHo" Boolean false
    "prioritizeAdditionalBands" Boolean false
    "useBandPrioritiesInSCellEval" Boolean false
    "release" String ""
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:TermPointToSGW=1"
    // moid = 4784
    exception none
    nrOfAttributes 1
    "termPointToSGWId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:TermPointToSGW=1,Lrat:GtpPath=1"
    // moid = 4785
    exception none
    nrOfAttributes 4
    "samplingInterval" Int32 0
    "echoPeerStatus" Integer 0
    "operationalState" Integer 0
    "gtpPathId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:SecurityHandling=1"
    // moid = 4786
    exception none
    nrOfAttributes 5
    "securityHandlingId" String "1"
    "countWrapSupervisionActive" Boolean true
    "rbIdSupervisionActive" Boolean true
    "cipheringAlgoPrio" Array Integer 3
         1
         2
         0
    "integrityProtectAlgoPrio" Array Integer 2
         2
         1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:Rrc=1"
    // moid = 4787
    exception none
    nrOfAttributes 9
    "rrcId" String "1"
    "t300" Int32 1000
    "t301" Int32 400
    "t304" Int32 1000
    "t311" Int32 3000
    "t320" Int32 30
    "tRrcConnectionReconfiguration" Int32 6
    "tRrcConnReest" Int32 1
    "tWaitForRrcConnReest" Int32 6
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=1"
    // moid = 4788
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "1"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=2"
    // moid = 4789
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "2"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=3"
    // moid = 4790
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "3"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=4"
    // moid = 4791
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "4"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=5"
    // moid = 4792
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "5"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=6"
    // moid = 4793
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "6"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=7"
    // moid = 4794
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "7"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=8"
    // moid = 4795
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "8"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=9"
    // moid = 4796
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "9"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=10"
    // moid = 4797
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "10"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=11"
    // moid = 4798
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "11"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=12"
    // moid = 4799
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "12"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=13"
    // moid = 4800
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "13"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=14"
    // moid = 4801
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "14"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=15"
    // moid = 4802
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "15"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=16"
    // moid = 4803
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "16"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=17"
    // moid = 4804
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "17"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=18"
    // moid = 4805
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "18"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RlfProfile=19"
    // moid = 4806
    exception none
    nrOfAttributes 7
    "n310" Int32 20
    "n311" Int32 1
    "t301" Int32 400
    "t310" Int32 2000
    "t311" Int32 3000
    "rlfProfileId" String "19"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:ResourcePartitions=1"
    // moid = 4807
    exception none
    nrOfAttributes 1
    "resourcePartitionsId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:Rcs=1"
    // moid = 4808
    exception none
    nrOfAttributes 3
    "rcsId" String "1"
    "tInactivityTimer" Int32 61
    "rlcDlDeliveryFailureAction" Integer 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1"
    // moid = 4809
    exception none
    nrOfAttributes 1
    "radioBearerTableId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1,Lrat:SignalingRadioBearer=1"
    // moid = 4810
    exception none
    nrOfAttributes 6
    "signalingRadioBearerId" String "1"
    "tReorderingUl" Int32 35
    "tPollRetransmitDl" Int32 80
    "dlMaxRetxThreshold" Int32 8
    "tPollRetransmitUl" Int32 80
    "ulMaxRetxThreshold" Int32 8
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1,Lrat:MACConfiguration=1"
    // moid = 4811
    exception none
    nrOfAttributes 2
    "ulMaxHARQTx" Int32 4
    "mACConfigurationId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:RadioBearerTable=1,Lrat:DataRadioBearer=1"
    // moid = 4812
    exception none
    nrOfAttributes 5
    "dataRadioBearerId" String "1"
    "tPollRetransmitUl" Int32 80
    "tPollRetransmitDl" Int32 80
    "dlMaxRetxThreshold" Int32 8
    "ulMaxRetxThreshold" Int32 8
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1"
    // moid = 4813
    exception none
    nrOfAttributes 2
    "qciTableId" String "1"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=1"
    // moid = 4814
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "1"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=2"
    // moid = 4815
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "2"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=3"
    // moid = 4816
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "3"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=4"
    // moid = 4817
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "4"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=5"
    // moid = 4818
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "5"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=6"
    // moid = 4819
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "6"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=7"
    // moid = 4820
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "7"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=8"
    // moid = 4821
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "8"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=9"
    // moid = 4822
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "9"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=10"
    // moid = 4823
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "10"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=11"
    // moid = 4824
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "11"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=12"
    // moid = 4825
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "12"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=13"
    // moid = 4826
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "13"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=14"
    // moid = 4827
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "14"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=15"
    // moid = 4828
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "15"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=16"
    // moid = 4829
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "16"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=17"
    // moid = 4830
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "17"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=18"
    // moid = 4831
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "18"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:SciProfile=19"
    // moid = 4832
    exception none
    nrOfAttributes 17
    "absPrioOverride" Integer 0
    "dlMaxWaitingTime" Int32 0
    "dlMinBitRate" Int32 0
    "dlResourceAllocationStrategy" Integer 0
    "logicalChannelGroupRef" Ref ""
    "pdb" Int32 0
    "priority" Int32 9
    "sci" Int32 0
    "sciProfileId" String "19"
    "dlRelativePriority" Int32 1
    "reservedBy" Array Ref 0
    "ulResourceAllocationStrategy" Integer 0
    "schedulingAlgorithm" Integer 0
    "srsAllocationStrategy" Integer 0
    "ulMaxWaitingTime" Int32 0
    "ulMinBitRate" Int32 0
    "ulRelativePriority" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=1"
    // moid = 4833
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "1"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=2"
    // moid = 4834
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "2"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET`
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=3"
    // moid = 4835
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "3"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=4"
    // moid = 4836
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "4"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=5"
    // moid = 4837
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "5"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=6"
    // moid = 4838
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "6"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=7"
    // moid = 4839
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "7"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=8"
    // moid = 4840
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "8"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=9"
    // moid = 4841
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "9"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:26
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:QciProfilePredefined=10"
    // moid = 4842
    exception none
    nrOfAttributes 39
    "schedulingAlgorithm" Integer 0
    "qciProfilePredefinedId" String "10"
    "userLabel" String "null"
    "qci" Int32 0
    "priority" Int32 0
    "pdb" Int32 0
    "dscp" Int32 0
    "logicalChannelGroupRef" Ref ""
    "aqmMode" Integer 0
    "pdbOffset" Int32 0
    "dlMinBitRate" Int32 0
    "rlcSNLength" Int32 10
    "pdcpSNLength" Int32 12
    "tReorderingUl" Int32 35
    "rlcMode" Integer 0
    "resourceType" Integer 0
    "dataFwdPerQciEnabled" Boolean false
    "ulMinBitRate" Int32 0
    "absPrioOverride" Integer 0
    "resourceAllocationStrategy" Integer 0
    "srsAllocationStrategy" Integer 0
    "measReportConfigParams" Struct
        nrOfElements 22
        "a1ThresholdRsrpPrimOffset" Int32 0
        "a1ThresholdRsrpSecOffset" Int32 0
        "a1ThresholdRsrqPrimOffset" Int32 0
        "a1ThresholdRsrqSecOffset" Int32 0
        "a2ThresholdRsrpPrimOffset" Int32 0
        "a2ThresholdRsrpSecOffset" Int32 0
        "a2ThresholdRsrqPrimOffset" Int32 0
        "a2ThresholdRsrqSecOffset" Int32 0
        "a5Threshold1RsrpOffset" Int32 0
        "a5Threshold1RsrqOffset" Int32 0
        "a5Threshold2RsrpOffset" Int32 0
        "a5Threshold2RsrqOffset" Int32 0
        "b2Threshold1RsrpCdma2000Offset" Int32 0
        "b2Threshold1RsrqCdma2000Offset" Int32 0
        "b2Threshold2Cdma2000Offset" Int32 0
        "b2Threshold1RsrpGeranOffset" Int32 0
        "b2Threshold1RsrqGeranOffset" Int32 0
        "b2Threshold2GeranOffset" Int32 0
        "b2Threshold1RsrpUtraOffset" Int32 0
        "b2Threshold1RsrqUtraOffset" Int32 0
        "b2Threshold2EcNoUtraOffset" Int32 0
        "b2Threshold2RscpUtraOffset" Int32 0

    "qciSubscriptionQuanta" Int32 1
    "qciACTuning" Int32 1000
    "dlResourceAllocationStrategy" Integer 0
    "relativePriority" Int32 1
    "rohcEnabled" Boolean false
    "serviceType" Integer 0
    "drxProfileRef" Ref "null"
    "drxPriority" Int32 0
    "counterActiveMode" Boolean false
    "reservedBy" Array Ref 0
    "rlfProfileRef" Ref "null"
    "rlfPriority" Int32 0
    "inactivityTimerOffset" Int32 0
    "dlMaxWaitingTime" Int32 0
    "ulMaxWaitingTime" Int32 0
    "timerProfileRef" Ref "null"
    "timerPriority" Int32 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:LogicalChannelGroup=1"
    // moid = 4843
    exception none
    nrOfAttributes 3
    "logicalChannelGroupId" String "1"
    "userLabel" String "null"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:LogicalChannelGroup=2"
    // moid = 4844
    exception none
    nrOfAttributes 3
    "logicalChannelGroupId" String "2"
    "userLabel" String "null"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:LogicalChannelGroup=3"
    // moid = 4845
    exception none
    nrOfAttributes 3
    "logicalChannelGroupId" String "3"
    "userLabel" String "null"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:QciTable=1,Lrat:LogicalChannelGroup=4"
    // moid = 4846
    exception none
    nrOfAttributes 3
    "logicalChannelGroupId" String "4"
    "userLabel" String "null"
    "reservedBy" Array Ref 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:PreschedulingProfile=1"
    // moid = 4847
    exception none
    nrOfAttributes 4
    "preschedulingProfileId" String "1"
    "preschedulingPeriod" Int32 5
    "preschedulingDataSize" Int32 86
    "preschedulingDuration" Int32 200
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:PmEventService=1"
    // moid = 4848
    exception none
    nrOfAttributes 13
    "cellTraceHighPrioReserve" Int32 0
    "totalCellTraceStorageSize" Int32 80000
    "cellTraceFileSize" Int32 1000
    "totalEventStorageSize" Int32 100000
    "ueTraceFileSize" Int32 1000
    "pmEventServiceId" String "1"
    "totalUeTraceStorageSize" Int32 16000
    "streamPortPmUeTrace" Int32 51543
    "streamStatusPmCellTrace" Array Struct 1
        nrOfElements 6
        "traceReference" Int64 0
        "scannerId" Int32 0
        "ipAddress" String ""
        "portNumber" Int32 0
        "fileStatus" Integer 0
        "streamStatus" Integer 0

    "streamStatusPmUeTrace" Array Struct 1
        nrOfElements 6
        "traceReference" Int64 0
        "scannerId" Int32 0
        "ipAddress" String ""
        "portNumber" Int32 0
        "fileStatus" Integer 0
        "streamStatus" Integer 0

    "cellTracePeriodicReport" Boolean false
    "streamStatusNotification" Boolean true
    "eventsExcludedFromUeTrace" Array Integer 1
         1
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:ParameterChangeRequests=1"
    // moid = 4849
    exception none
    nrOfAttributes 3
    "parameterChangeRequestList" Array Struct 1
        nrOfElements 10
        "seqNo" Int32 0
        "objectRef" String ""
        "attributeName" String ""
        "originalValue" String ""
        "requestedValue" String ""
        "causeCode" Integer 0
        "causeString" String ""
        "state" Integer 0
        "timeOfCreation" String ""
        "timeOfChange" String ""

    "latestUpdate" Struct
        nrOfElements 10
        "seqNo" Int32 0
        "objectRef" String ""
        "attributeName" String ""
        "originalValue" String ""
        "requestedValue" String ""
        "causeCode" Integer 0
        "causeString" String ""
        "state" Integer 0
        "timeOfCreation" String ""
        "timeOfChange" String ""

    "parameterChangeRequestsId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:Paging=1"
    // moid = 4850
    exception none
    nrOfAttributes 6
    "pagingId" String "1"
    "maxNoOfPagingRecords" Int32 3
    "defaultPagingCycle" Int32 128
    "nB" Integer 2
    "pagingDiscardTimer" Int32 3
    "noOfDefPagCyclPrim" Int32 8
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:NonPlannedPciDrxProfile=1"
    // moid = 4851
    exception none
    nrOfAttributes 4
    "nonPlannedPciDrxProfileId" String "1"
    "nonPlannedPciDrxInactivityTimer" Integer 1
    "nonPlannedPciLongDrxCycle" Integer 9
    "nonPlannedPciOnDurationTimer" Integer 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:MdtConfiguration=1"
    // moid = 4852
    exception none
    nrOfAttributes 12
    "mdtConfigurationId" String "1"
    "reportingTrigger" Integer 0
    "reportIntervalMdt" Integer 6
    "reportAmountMdt" Int32 16
    "a2ThresholdRsrpMdt" Int32 -140
    "a2ThresholdRsrqMdt" Int32 -195
    "positioningMethod" Integer 1
    "hysteresisA2Mdt" Int32 10
    "timeToTriggerA2Mdt" Int32 640
    "maxReportCellsA2Mdt" Int32 4
    "reportQuantityA2Mdt" Integer 1
    "triggerQuantityA2Mdt" Integer 0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:LoadBalancingFunction=1"
    // moid = 4853
    exception none
    nrOfAttributes 29
    "loadBalancingFunctionId" String "1"
    "lbThreshold" Int32 30
    "lbCeiling" Int32 200
    "lbRateOffsetCoefficient" Int32 320
    "lbUtranOffloadBackoffTime" Int32 60
    "lbEUtranOffloadBackoffTime" Int32 60
    "lbCauseCodeS1SourceTriggersOffload" Integer 0
    "lbCauseCodeS1TargetAcceptsOffload" Integer 0
    "lbCauseCodeX2SourceTriggersOffload" Integer 0
    "lbCauseCodeX2TargetAcceptsOffload" Integer 0
    "lbHitRateEUtranMeasUeThreshold" Int32 10
    "lbHitRateUtranMeasUeThreshold" Int32 10
    "lbHitRateEUtranMeasUeIntensity" Int32 10
    "lbHitRateUtranMeasUeIntensity" Int32 10
    "lbHitRateEUtranAddThreshold" Int32 15
    "lbHitRateUtranAddThreshold" Int32 15
    "lbHitRateEUtranRemoveThreshold" Int32 2
    "lbHitRateUtranRemoveThreshold" Int32 2
    "txPwrForOverlaidCellDetect" Int32 370
    "ocdMaxNoHighHitRateCells" Int32 3
    "ocdMinHighHitThresh" Int32 15
    "lbMeasScalingLimit" Int32 30
    "lbDiffCaOffset" Int32 100
    "lbRateOffsetLoadThreshold" Int32 500
    "lbCaThreshold" Int32 800
    "lbCaCapHysteresis" Int32 20
    "lbUeEvaluationTimer" Int32 90
    "isUlEvalAllowedAtTpLbHo" Boolean false
    "isUlEvalAllowedAtCaTrHo" Boolean false
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:ImeisvTable=1"
    // moid = 4854
    exception none
    nrOfAttributes 3
    "imeisvTableId" String "1"
    "listOfFeaturesDefaultOff" Array Integer 1
         0
    "listOfFeaturesDefaultOn" Array Integer 1
         0
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:FlexibleQoSFunction=1"
    // moid = 4855
    exception none
    nrOfAttributes 1
    "flexibleQoSFunctionId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtraNetwork=1"
    // moid = 4856
    exception none
    nrOfAttributes 2
    "eUtraNetworkId" String "1"
    "userLabel" String "null"
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=1"
    // moid = 4857
    exception none
    nrOfAttributes 8
    "drxProfileId" String "1"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=2"
    // moid = 4858
    exception none
    nrOfAttributes 8
    "drxProfileId" String "2"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=3"
    // moid = 4859
    exception none
    nrOfAttributes 8
    "drxProfileId" String "3"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=4"
    // moid = 4860
    exception none
    nrOfAttributes 8
    "drxProfileId" String "4"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=5"
    // moid = 4861
    exception none
    nrOfAttributes 8
    "drxProfileId" String "5"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=6"
    // moid = 4862
    exception none
    nrOfAttributes 8
    "drxProfileId" String "6"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=7"
    // moid = 4863
    exception none
    nrOfAttributes 8
    "drxProfileId" String "7"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=8"
    // moid = 4864
    exception none
    nrOfAttributes 8
    "drxProfileId" String "8"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=9"
    // moid = 4865
    exception none
    nrOfAttributes 8
    "drxProfileId" String "9"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=10"
    // moid = 4866
    exception none
    nrOfAttributes 8
    "drxProfileId" String "10"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=11"
    // moid = 4867
    exception none
    nrOfAttributes 8
    "drxProfileId" String "11"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=12"
    // moid = 4868
    exception none
    nrOfAttributes 8
    "drxProfileId" String "12"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=13"
    // moid = 4869
    exception none
    nrOfAttributes 8
    "drxProfileId" String "13"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=14"
    // moid = 4870
    exception none
    nrOfAttributes 8
    "drxProfileId" String "14"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=15"
    // moid = 4871
    exception none
    nrOfAttributes 8
    "drxProfileId" String "15"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=16"
    // moid = 4872
    exception none
    nrOfAttributes 8
    "drxProfileId" String "16"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=17"
    // moid = 4873
    exception none
    nrOfAttributes 8
    "drxProfileId" String "17"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=18"
    // moid = 4874
    exception none
    nrOfAttributes 8
    "drxProfileId" String "18"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:DrxProfile=19"
    // moid = 4875
    exception none
    nrOfAttributes 8
    "drxProfileId" String "19"
    "onDurationTimer" Integer 7
    "drxInactivityTimer" Integer 15
    "drxRetransmissionTimer" Integer 1
    "shortDrxCycle" Integer 7
    "shortDrxCycleTimer" Int32 4
    "longDrxCycle" Integer 9
    "longDrxCycleOnly" Integer 7
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:CellSleepNodeFunction=1"
    // moid = 4876
    exception none
    nrOfAttributes 5
    "cellSleepNodeFunctionId" String "1"
    "csmEutranInterFMeasReportMax" Int32 100
    "csmEutranInterFMeasReportMin" Int32 5
    "csmEutranInterFMeasReportIncr" Int32 10
    "csmEutranInterFMeasReportDecr" Int32 1
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:CarrierAggregationFunction=1"
    // moid = 4877
    exception none
    nrOfAttributes 20
    "caUsageLimit" Int32 300
    "caPreemptionThreshold" Int32 50
    "sCellActDeactDataThres" Int32 100
    "sCellActDeactDataThresHyst" Int32 90
    "sCellScheduleSinrThres" Int32 0
    "sCellActDeactProhibitTimer" Int32 200
    "waitForCaOpportunity" Int32 10000
    "waitForBetterSCellRep" Int32 1000
    "carrierAggregationFunctionId" String "1"
    "waitForAdditionalSCellOpportunity" Int32 10000
    "caRateAdjustCoeff" Int32 10
    "sCellActDeactUlDataThresh" Int32 100
    "sCellActDeactUlDataThreshHyst" Int32 90
    "sCellScheduleUlPathlossThresh" Int32 1400
    "pdcchEnhancedLaForVolte" Boolean false
    "sCellSelectionMode" Integer 0
    "sCellActProhibitTimer" Int32 10
    "sCellDeactProhibitTimer" Int32 200
    "sCellDeactOutOfCoverageTimer" Int32 100
    "sCellDeactDelayTimer" Int32 50
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AutoCellCapEstFunction=1"
    // moid = 4878
    exception none
    nrOfAttributes 2
    "useEstimatedCellCap" Boolean false
    "autoCellCapEstFunctionId" String "1"
)

// Create Statement generated: 2016-06-01 07:13:27
SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:AnrFunction=1"
    // moid = 4879
    exception none
    nrOfAttributes 31
    "anrFunctionId" String "1"
    "removeNcellTime" Int32 30
    "removeNenbTime" Int32 7
    "removeNrelTime" Int32 7
    "zzzTemporary1" String ""
    "zzzTemporary2" String ""
    "zzzTemporary3" String ""
    "zzzTemporary4" String ""
    "zzzTemporary5" Int32 -2000000000
    "zzzTemporary6" Int32 -2000000000
    "zzzTemporary7" Int32 -2000000000
    "prioTime" Int32 100
    "prioHoSuccRate" Int32 100
    "prioHoRate" Int32 100
    "maxNoPciReportsInact" Int32 30
    "maxTimeEventBasedPciConf" Int32 30
    "maxNoPciReportsEvent" Int32 15
    "nrHoNeededToAddCellRelation" Int32 0
    "cellRelHoAttRateThreshold" Int32 0
    "zzzTemporary8" Int32 -2000000000
    "zzzTemporary9" Int32 -2000000000
    "zzzTemporary10" Int32 -2000000000
    "zzzTemporary11" Int32 -2000000000
    "zzzTemporary12" Int32 -2000000000
    "problematicCellPolicy" Integer 0
    "probCellDetectMedHoSuccThres" Int32 50
    "probCellDetectMedHoSuccTime" Int32 4
    "probCellDetectLowHoSuccThres" Int32 10
    "probCellDetectLowHoSuccTime" Int32 10
    "plmnWhiteListEnabled" Boolean false
    "perEcgiMeasPlmnWhiteList" Boolean true
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1"
    exception none
    nrOfAttributes 2
    "eNodeBPlmnId" Struct
        nrOfElements 3
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2

    "eNodeBFunctionId" String "1"
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1"
    // moid = 4783
    exception none
    nrOfAttributes 1
    "eNBId" Int32 $enbID
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1"
    identity "$NODENAME-1"
    moType Lrat:EUtranCellFDD
    exception none
    nrOfAttributes 3
    "eUtranCellFDDId" String "$NODENAME-1"
    "earfcndl" Int32 1
    "earfcnul" Int32 180001
    )
	
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1"
    identity "$NODENAME-2"
    moType Lrat:EUtranCellFDD
    exception none
    nrOfAttributes 3
    "eUtranCellFDDId" String "$NODENAME-2"
    "earfcndl" Int32 1
    "earfcnul" Int32 180001
    )
	
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1"
    identity "$NODENAME-3"
    moType Lrat:EUtranCellFDD
    exception none
    nrOfAttributes 3
    "eUtranCellFDDId" String "$NODENAME-3"
    "earfcndl" Int32 1
    "earfcnul" Int32 180001
    )

SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-1"
    exception none
    nrOfAttributes 1
    "additionalPlmnList" Array Struct 1
        nrOfElements 3
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-2"
    exception none
    nrOfAttributes 1
    "additionalPlmnList" Array Struct 1
        nrOfElements 3
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
)

SET
(
    mo "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtranCellFDD=$NODENAME-3"
    exception none
    nrOfAttributes 1
    "additionalPlmnList" Array Struct 1
        nrOfElements 3
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,Lrat:ENodeBFunction=1,Lrat:EUtraNetwork=1"
    identity "1"
    moType Lrat:EUtranFrequency
    exception none
    nrOfAttributes 7
    "eUtranFrequencyId" String "1"
    "reservedBy" Array Ref 0
    "userLabel" String "null"
    "arfcnValueEUtranDl" Int32 0
    "additionalFreqBandList" Array Int32 1
        0
    "excludeAdditionalFreqBandList" Array Int32 1
        0
    "freqBand" Int32 0
)

	 ^;# end @MO

$NETSIMMOSCRIPT=&makeMOscript("append",$MOSCRIPT.$NODECOUNT,@MOCmds);
	   
	   
push(@NETSIMMOSCRIPTS,$NETSIMMOSCRIPT);	

 @MMLCmds=();
  # build mml script
  @MMLCmds=(".open ".$SIMNAME,
          ".select ".$NODENAME,
          ".start ",
          "useattributecharacteristics:switch=\"off\"; ",
          "kertayle:file=\"$NETSIMMOSCRIPT\";"
  );# end @MMLCmds

  $NETSIMMMLSCRIPT=&makeMMLscript("append",$MMLSCRIPT,@MMLCmds);
	   
	   $NODECOUNT++;
}# end outer NODECOUNT while

 @MMLCmds=();
@MMLCmds=(".open ".$SIMNAME,
".select network",
            ".stop -parallel ",
".saveandcompress force nopmdata"
);# end @MMLCmds

  $NETSIMMMLSCRIPT=&makeMMLscript("append",$MMLSCRIPT,@MMLCmds);

 # execute mml script
  @netsim_output=`$NETSIM_INSTALL_PIPE < $NETSIMMMLSCRIPT`;

  # output mml script execution
  print "@netsim_output\n";
  
  ################################
# CLEANUP
################################
$date=`date`;
# remove mo script
unlink "$NETSIMMMLSCRIPT";
unlink @NETSIMMOSCRIPTS;
print "... ${0} ended running at $date\n";
################################
# END
################################

#
#---------------------------------------------------------------------------------
#SubRoutine to call create MML and mo scripts
#---------------------------------------------------------------------------------
#
sub makeMMLscript{
    my ($fileaction,$mmlscriptname,@cmds) = @_;
    $mmlscriptname=~s/\.\///;
    if($fileaction eq "write"){
     if(-e "$mmlscriptname"){
       unlink "$mmlscriptname";
     }#end if
       open FH, ">$mmlscriptname" or die $!;
    }# end write
    if($fileaction eq "append"){
      open FH, ">>$mmlscriptname" or die $!;
    }# end append
    print FH "#!/bin/sh\n";

    foreach $_(@cmds){print FH "$_\n";}
    close(FH);
    system("chmod 777 $mmlscriptname");
    return($mmlscriptname);
}# end makeMMLscript

sub makeMOscript{
    my ($fileaction,$moscriptname,@cmds) = @_;
    $moscriptname=~s/\.\///;
    if($fileaction eq "write"){
      if(-e "$moscriptname"){
        unlink "$moscriptname";
      }#end if
      open FH1, ">$moscriptname" or die $!;
    }# end write
    if($fileaction eq "append"){
       open FH1, ">>$moscriptname" or die $!;
    }# end append
    foreach $_(@cmds){print FH1 "$_\n";}
    close(FH1);
    system("chmod 777 $moscriptname");
    return($moscriptname);
}# end makeMOscript


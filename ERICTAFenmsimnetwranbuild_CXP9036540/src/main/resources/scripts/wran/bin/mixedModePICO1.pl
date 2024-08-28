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
local $NUMOFNODES=2;
local $enbID=(160*($SIMNUM-1));

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
#=pod
#if ($NODECOUNT<10) {
#    if ($SIMTYPE=="dg2") {
#    $NODENAME="LTE${SIMNUM}${SIMTYPE}ERBS0000${NODECOUNT}";
#    }
#    else {
#    $NODENAME="LTE${SIMNUM}ERBS0000${NODECOUNT}";
#    }
#}
#if ($NODECOUNT>=10 && $NODECOUNT<99) {
#     if ($SIMTYPE=="dg2") {
#    $NODENAME="LTE${SIMNUM}${SIMTYPE}ERBS000${NODECOUNT}";
#    }
#    else {
#    $NODENAME="LTE${SIMNUM}ERBS0000${NODECOUNT}";
#    }
#}
#if ($NODECOUNT>=100) {
#    if ($SIMTYPE=="dg2") {
#    $NODENAME="LTE${SIMNUM}${SIMTYPE}ERBS000${NODECOUNT}";
#    }
#    else {
#    $NODENAME="LTE${SIMNUM}ERBS0000${NODECOUNT}";
#    }
#}
#=cut
if ($NODECOUNT<10) {
    $NODENAME="RNC${SIMNUM}PRBS0${NODECOUNT}";
    $enbID++;
}
else {
$NODENAME="RNC${SIMNUM}PRBS${NODECOUNT}";
    $enbID++;
}

print "THE NODENAME IS $NODENAME and enbID is $enbID\n";

	   @MOCmds=qq^
CREATE
(
    parent "ComTop:ManagedElement=$NODENAME"
    identity "1"
    moType MSRBS_V1_eNodeBFunction:ENodeBFunction
    exception none
    nrOfAttributes 3
    "eNodeBFunctionId" String "1"
    "eNBId" Int32 $enbID
    "eNodeBPlmnId" Struct
        nrOfElements 3
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
)

CREATE
(
    parent "ComTop:ManagedElement=$NODENAME,MSRBS_V1_eNodeBFunction:ENodeBFunction=1"
    identity "1"
    moType MSRBS_V1_eNodeBFunction:EUtranCellFDD
    exception none
    nrOfAttributes 5
    "eUtranCellFDDId" String "$NODENAME-1"
    "earfcndl" Int32 1
    "earfcnul" Int32 18001
    "pciConflictCell" Array Struct 1
        nrOfElements 5
        "cellId" Int32 0
        "enbId" Int32 0
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2

    "pciDetectingCell" Array Struct 1
        nrOfElements 5
        "cellId" Int32 0
        "enbId" Int32 0
        "mcc" Int32 1
        "mnc" Int32 1
        "mncLength" Int32 2
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

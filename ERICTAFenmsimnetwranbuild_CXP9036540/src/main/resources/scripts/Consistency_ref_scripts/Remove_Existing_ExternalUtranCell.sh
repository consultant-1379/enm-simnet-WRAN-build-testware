#!/bin/sh
if [ "$#" -ne 1  ]
then
 echo
 echo "Usage: $0 <sim name>"
 echo
 echo "Example: $0 RNCV81349x1-FT-MSRBS-17Bx466-RNC10"
 echo
 echo "-------------------------------------------------------------------"
 echo "# $0 script ended ERRONEOUSLY !!!!"
 echo "###################################################################"
 exit 1
fi

SIMNAME=$1
Instpath=/netsim/inst
LOGSPATH=`pwd`
neVersion=`echo -e $SIMNAME | cut -d 'x' -f1 | awk -F "RNC" '{print $2}'`
neType=${neVersion}-lim
nename=`echo -e $SIMNAME | rev | cut -d '-' -f1 | rev`
echo -e ".open $SIMNAME \n .selectnocallback $nename \n.start \n e case simneenv:get_netype() of {\"WCDMA\", \"RNC\", \"$neType\",_} -> SId = cs_session_factory:create_internal_session(\"MoDelete\", infinity), ExtUtrCellMOs = csmo:get_mo_ids_by_type(null,\"ExternalUtranCell\"), lists:map(fun(ExtUtrCellMOId) -> case ExtUtrCellMOId of ExtUtrCellMOId when is_integer(ExtUtrCellMOId) -> csmodb:delete_mo_by_id(SId, ExtUtrCellMOId);_Any-> OK end end, ExtUtrCellMOs), cs_session:commit_chk(SId),cs_session_factory:end_session(SId);_AnyValue -> OK end." | $Instpath/netsim_shell

echo "*******************already present ExternalUtranCells are deleted *********************"

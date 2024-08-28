SET
(
    mo "ManagedElement=1,SwManagement=1,UpgradePackage=1"
    identity "1"
    
    exception none
    nrOfAttributes 27
    "UpgradePackageId" String "1"
    "actionResult" Array Struct 0
    "administrativeData" Struct
        nrOfElements 5
        "productNumber" String "$RNCNAME"
        "productRevision" String "$RNCNAME"
        "productName" String "$RNCNAME"
        "productInfo" String "$RNCNAME"
        "productionDate" String "$RNCNAME"

    "basedOnUpgradePackages" Array Struct 0
    "confirmationDeadline" String ""
    "cppUpVersion" Struct
        nrOfElements 5
        "productNumber" String "$RNCNAME"
        "productRevision" String "$RNCNAME"
        "productName" String "$RNCNAME"
        "productInfo" String "$RNCNAME"
        "productionDate" String "$RNCNAME"

    "deletePreventingCVs" Array String 0
   // "deletePreventingUPs" Array Struct 0
    "ftpServerIpAddress" String "159.107.188.100"
    "isDeletable" Boolean true
    "loadModuleList" Array Ref 0
    "maxTimeBetweenUpgradeEvents" Integer 1
    "otherReferringCVs" Array String 0
    "password" String "anonymous"
    "progressCount" Integer 0
    "progressHeader" Integer 0
    "progressTotal" Integer 0
    "sendEvents" Boolean true
    "state" Integer 0
    "stepLabel" String ""
    // "typeOfUP" Integer 0
    "upCompatibilityIndex" String ""
    "upFilePathOnFtpServer" String ""
    "upgradeControlFilePath" String ""
    "upgradePackageDocumentId" String ""
    "user" String "anonymous"
    "userLabel" String "UpgradePackage-1"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCell"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenRnh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuRnsap"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=9"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=8"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuRanap"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=9"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=8"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuModOm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuUe"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenOm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuFro"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuDh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenRh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenDh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2ap_12_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2cpsrc_12_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2disncc_12_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2rh_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=jvm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=http"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=spp_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ip_util"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=nss_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=equip_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=nsaal_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=usaal_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal5s_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal5d_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal0s_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal0d_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal2ncc"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal2_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal2mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=atmmp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)
SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCell"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenRnh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuRnsap"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=9"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=8"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuRanap"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=9"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=8"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuModOm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuUe"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenOm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuFro"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuDh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenRh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=RncRpuCenDh"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2ap_12_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2cpsrc_12_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2disncc_12_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ans_aal2rh_1"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=15"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=14"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=jvm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=http"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=13"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=12"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=spp_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ip_util"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=nss_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=equip_mp"
  exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=nsaal_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=usaal_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal5s_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal5d_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal0s_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal0d_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal2ncc"
    exception none
    nrOfAttributes 2
 "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=phy_stm1_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=phy_e1_mp"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal_cc"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal05_ncc"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=ospf"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=inet"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=spas_res"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=sw_inst"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=aal2ap13"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=9"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=8"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=scc_server"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=9"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=8"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ReliableProgramUniter=scc_adm"
    exception none
    nrOfAttributes 2
    "admPassiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=11"
    "admActiveSlot" Ref "ManagedElement=1,Equipment=1,Subrack=MS,Slot=10"
)

SET
(
    mo "ManagedElement=1,SwManagement=1,ConfigurationVersion=1"
    exception none
    nrOfAttributes 1
    "currentUpgradePackage" Ref "ManagedElement=1,SwManagement=1,UpgradePackage=1"
)

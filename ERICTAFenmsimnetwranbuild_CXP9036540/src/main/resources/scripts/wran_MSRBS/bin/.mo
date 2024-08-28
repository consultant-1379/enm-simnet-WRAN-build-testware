SET
(
    mo "ComTop:ManagedElement=RNC09MSRBS-V203,ComTop:SystemFunctions=1,RcsPMEventM:PmEventM=1,RcsPMEventM:EventProducer=Lrat,RcsPMEventM:FilePullCapabilities=2"
    // moid = 3603
    exception none
    nrOfAttributes 1
    "outputDirectory" String "/c/pm_data/"
)

SET
(
    mo "ComTop:ManagedElement=RNC09MSRBS-V203,ComTop:SystemFunctions=1,RcsPm:Pm=1,RcsPm:PmMeasurementCapabilities=1"
    // moid = 40
    exception none
    nrOfAttributes 1
    "fileLocation" String "/c/pm_data/"
)


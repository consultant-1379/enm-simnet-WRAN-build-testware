#!/bin/sh
getSimType()
{
    MY_SIM=$1

    TYPE="UNKNOWN"
    echo ${MY_SIM} | grep MSRBS > /dev/null
    if [ $? -eq 0 ] ; then
        echo "MSRBS"
        return
    fi
    echo ${MY_SIM} | grep -v TD | grep RNC > /dev/null
    if [ $? -eq 0 ] ; then
	echo "WRAN"
	return
    fi

    

    echo ${MY_SIM} | grep LTE > /dev/null
    if [ $? -eq 0 ] ; then
	echo "LTE"
	return
    fi
    
    echo ${MY_SIM} | grep TD > /dev/null
    if [ $? -eq 0 ] ; then
	echo "TD"
	return
    fi

    echo "UNKNOWN"
    return
}


createScanners() {
    
    CMD_FILE=/tmp/create_scanners.cmd
    if [ -r ${CMD_FILE} ] ; then
	rm ${CMD_FILE}
    fi

    for SIM in $LIST ; do
    # WRAN
	
	SIM_NAM=`ls /netsim/netsimdir | grep ${SIM} `
	SIM_NAME=`echo $SIM_NAM | rev | cut -c 5- | rev`
	SIM_TYPE=`getSimType ${SIM_NAME}`
	echo $SIM_TYPE
	echo $SIM_NAME
	if [ "${SIM_TYPE}" = "WRAN" ] ; then	    
	    cat >> ${CMD_FILE} <<EOF
.open ${SIM_NAME}
.select network
.start
setswinstallvariables:createCVFiles=true;
.genreffilecpp wcdma Fileset.GPEH gpeh default
.genreffilecpp wcdma Fileset.STATS stats default
.genreffilecpp wcdma Fileset.CTR ctr default
.genreffilecpp wcdma Fileset.UETR uetr default

.selectnetype RNC
createscanner2:id=1,measurement_name="PREDEF.10000.UETR",file="Fileset.UETR";
createscanner2:id=2,measurement_name="PREDEF.10001.UETR",file="Fileset.UETR";
createscanner2:id=3,measurement_name="PREDEF.10002.UETR",file="Fileset.UETR";
createscanner2:id=4,measurement_name="PREDEF.10003.UETR",file="Fileset.UETR";
createscanner2:id=5,measurement_name="PREDEF.10004.UETR",file="Fileset.UETR";
createscanner2:id=6,measurement_name="PREDEF.10005.UETR",file="Fileset.UETR";
createscanner2:id=7,measurement_name="PREDEF.10006.UETR",file="Fileset.UETR";
createscanner2:id=8,measurement_name="PREDEF.10007.UETR",file="Fileset.UETR";
createscanner2:id=9,measurement_name="PREDEF.10008.UETR",file="Fileset.UETR";
createscanner2:id=10,measurement_name="PREDEF.10009.UETR",file="Fileset.UETR";
createscanner2:id=11,measurement_name="PREDEF.10010.UETR",file="Fileset.UETR";
createscanner2:id=12,measurement_name="PREDEF.10011.UETR",file="Fileset.UETR";
createscanner2:id=13,measurement_name="PREDEF.10012.UETR",file="Fileset.UETR";
createscanner2:id=14,measurement_name="PREDEF.10013.UETR",file="Fileset.UETR";
createscanner2:id=15,measurement_name="PREDEF.10014.UETR",file="Fileset.UETR";
createscanner2:id=16,measurement_name="PREDEF.10015.UETR",file="Fileset.UETR";
createscanner2:id=216,measurement_name="PREDEF.10016.UETR",file="Fileset.UETR";
createscanner2:id=217,measurement_name="PREDEF.10017.UETR",file="Fileset.UETR";
createscanner2:id=218,measurement_name="PREDEF.10018.UETR",file="Fileset.UETR";
createscanner2:id=219,measurement_name="PREDEF.10019.UETR",file="Fileset.UETR";
createscanner2:id=220,measurement_name="PREDEF.10020.UETR",file="Fileset.UETR";
createscanner2:id=221,measurement_name="PREDEF.10021.UETR",file="Fileset.UETR";
createscanner2:id=222,measurement_name="PREDEF.10022.UETR",file="Fileset.UETR";
createscanner2:id=223,measurement_name="PREDEF.10023.UETR",file="Fileset.UETR";
createscanner2:id=224,measurement_name="PREDEF.10024.UETR",file="Fileset.UETR";
createscanner2:id=225,measurement_name="PREDEF.10025.UETR",file="Fileset.UETR";
createscanner2:id=226,measurement_name="PREDEF.10026.UETR",file="Fileset.UETR";
createscanner2:id=227,measurement_name="PREDEF.10027.UETR",file="Fileset.UETR";
createscanner2:id=228,measurement_name="PREDEF.10028.UETR",file="Fileset.UETR";
createscanner2:id=229,measurement_name="PREDEF.10029.UETR",file="Fileset.UETR";
createscanner2:id=230,measurement_name="PREDEF.10030.UETR",file="Fileset.UETR";
createscanner2:id=231,measurement_name="PREDEF.10031.UETR",file="Fileset.UETR";
createscanner2:id=232,measurement_name="PREDEF.10032.UETR",file="Fileset.UETR";
createscanner2:id=233,measurement_name="PREDEF.10033.UETR",file="Fileset.UETR";
createscanner2:id=234,measurement_name="PREDEF.10034.UETR",file="Fileset.UETR";
createscanner2:id=235,measurement_name="PREDEF.10035.UETR",file="Fileset.UETR";
createscanner2:id=236,measurement_name="PREDEF.10036.UETR",file="Fileset.UETR";
createscanner2:id=237,measurement_name="PREDEF.10037.UETR",file="Fileset.UETR";
createscanner2:id=238,measurement_name="PREDEF.10038.UETR",file="Fileset.UETR";
createscanner2:id=239,measurement_name="PREDEF.10039.UETR",file="Fileset.UETR";
createscanner2:id=240,measurement_name="PREDEF.10040.UETR",file="Fileset.UETR";
createscanner2:id=241,measurement_name="PREDEF.10041.UETR",file="Fileset.UETR";
createscanner2:id=242,measurement_name="PREDEF.10042.UETR",file="Fileset.UETR";
createscanner2:id=243,measurement_name="PREDEF.10043.UETR",file="Fileset.UETR";
createscanner2:id=244,measurement_name="PREDEF.10044.UETR",file="Fileset.UETR";
createscanner2:id=245,measurement_name="PREDEF.10045.UETR",file="Fileset.UETR";
createscanner2:id=246,measurement_name="PREDEF.10046.UETR",file="Fileset.UETR";
createscanner2:id=247,measurement_name="PREDEF.10047.UETR",file="Fileset.UETR";
createscanner2:id=248,measurement_name="PREDEF.10048.UETR",file="Fileset.UETR";
createscanner2:id=249,measurement_name="PREDEF.10049.UETR",file="Fileset.UETR";
createscanner2:id=250,measurement_name="PREDEF.10050.UETR",file="Fileset.UETR";
createscanner2:id=251,measurement_name="PREDEF.10051.UETR",file="Fileset.UETR";
createscanner2:id=252,measurement_name="PREDEF.10052.UETR",file="Fileset.UETR";
createscanner2:id=253,measurement_name="PREDEF.10053.UETR",file="Fileset.UETR";
createscanner2:id=254,measurement_name="PREDEF.10054.UETR",file="Fileset.UETR";
createscanner2:id=255,measurement_name="PREDEF.10055.UETR",file="Fileset.UETR";
createscanner2:id=256,measurement_name="PREDEF.10056.UETR",file="Fileset.UETR";
createscanner2:id=257,measurement_name="PREDEF.10057.UETR",file="Fileset.UETR";
createscanner2:id=258,measurement_name="PREDEF.10058.UETR",file="Fileset.UETR";
createscanner2:id=259,measurement_name="PREDEF.10059.UETR",file="Fileset.UETR";
createscanner2:id=260,measurement_name="PREDEF.10060.UETR",file="Fileset.UETR";
createscanner2:id=261,measurement_name="PREDEF.10061.UETR",file="Fileset.UETR";
createscanner2:id=262,measurement_name="PREDEF.10062.UETR",file="Fileset.UETR";
createscanner2:id=263,measurement_name="PREDEF.10063.UETR",file="Fileset.UETR";
createscanner2:id=264,measurement_name="PREDEF.10064.UETR",file="Fileset.UETR";
createscanner2:id=265,measurement_name="PREDEF.10065.UETR",file="Fileset.UETR";
createscanner2:id=266,measurement_name="PREDEF.10066.UETR",file="Fileset.UETR";
createscanner2:id=267,measurement_name="PREDEF.10067.UETR",file="Fileset.UETR";
createscanner2:id=268,measurement_name="PREDEF.10068.UETR",file="Fileset.UETR";
createscanner2:id=269,measurement_name="PREDEF.10069.UETR",file="Fileset.UETR";
createscanner2:id=270,measurement_name="PREDEF.10070.UETR",file="Fileset.UETR";
createscanner2:id=271,measurement_name="PREDEF.10071.UETR",file="Fileset.UETR";
createscanner2:id=272,measurement_name="PREDEF.10072.UETR",file="Fileset.UETR";
createscanner2:id=273,measurement_name="PREDEF.10073.UETR",file="Fileset.UETR";
createscanner2:id=274,measurement_name="PREDEF.10074.UETR",file="Fileset.UETR";
createscanner2:id=275,measurement_name="PREDEF.10075.UETR",file="Fileset.UETR";
createscanner2:id=276,measurement_name="PREDEF.10076.UETR",file="Fileset.UETR";
createscanner2:id=277,measurement_name="PREDEF.10077.UETR",file="Fileset.UETR";
createscanner2:id=278,measurement_name="PREDEF.10078.UETR",file="Fileset.UETR";
createscanner2:id=279,measurement_name="PREDEF.10079.UETR",file="Fileset.UETR";
createscanner2:id=280,measurement_name="PREDEF.10080.UETR",file="Fileset.UETR";
createscanner2:id=281,measurement_name="PREDEF.10081.UETR",file="Fileset.UETR";
createscanner2:id=282,measurement_name="PREDEF.10082.UETR",file="Fileset.UETR";
createscanner2:id=283,measurement_name="PREDEF.10083.UETR",file="Fileset.UETR";
createscanner2:id=284,measurement_name="PREDEF.10084.UETR",file="Fileset.UETR";
createscanner2:id=285,measurement_name="PREDEF.10085.UETR",file="Fileset.UETR";
createscanner2:id=286,measurement_name="PREDEF.10086.UETR",file="Fileset.UETR";
createscanner2:id=287,measurement_name="PREDEF.10087.UETR",file="Fileset.UETR";
createscanner2:id=288,measurement_name="PREDEF.10088.UETR",file="Fileset.UETR";
createscanner2:id=289,measurement_name="PREDEF.10089.UETR",file="Fileset.UETR";
createscanner2:id=290,measurement_name="PREDEF.10090.UETR",file="Fileset.UETR";
createscanner2:id=291,measurement_name="PREDEF.10091.UETR",file="Fileset.UETR";
createscanner2:id=292,measurement_name="PREDEF.10092.UETR",file="Fileset.UETR";
createscanner2:id=293,measurement_name="PREDEF.10093.UETR",file="Fileset.UETR";
createscanner2:id=294,measurement_name="PREDEF.10094.UETR",file="Fileset.UETR";
createscanner2:id=295,measurement_name="PREDEF.10095.UETR",file="Fileset.UETR";
createscanner2:id=296,measurement_name="PREDEF.10096.UETR",file="Fileset.UETR";
createscanner2:id=297,measurement_name="PREDEF.10097.UETR",file="Fileset.UETR";
createscanner2:id=298,measurement_name="PREDEF.10098.UETR",file="Fileset.UETR";
createscanner2:id=299,measurement_name="PREDEF.10099.UETR",file="Fileset.UETR";
createscanner2:id=300,measurement_name="PREDEF.10100.UETR",file="Fileset.UETR";
createscanner2:id=301,measurement_name="PREDEF.10101.UETR",file="Fileset.UETR";
createscanner2:id=302,measurement_name="PREDEF.10102.UETR",file="Fileset.UETR";
createscanner2:id=303,measurement_name="PREDEF.10103.UETR",file="Fileset.UETR";
createscanner2:id=304,measurement_name="PREDEF.10104.UETR",file="Fileset.UETR";
createscanner2:id=305,measurement_name="PREDEF.10105.UETR",file="Fileset.UETR";
createscanner2:id=306,measurement_name="PREDEF.10106.UETR",file="Fileset.UETR";
createscanner2:id=307,measurement_name="PREDEF.10107.UETR",file="Fileset.UETR";
createscanner2:id=308,measurement_name="PREDEF.10108.UETR",file="Fileset.UETR";
createscanner2:id=309,measurement_name="PREDEF.10109.UETR",file="Fileset.UETR";
createscanner2:id=310,measurement_name="PREDEF.10110.UETR",file="Fileset.UETR";
createscanner2:id=311,measurement_name="PREDEF.10111.UETR",file="Fileset.UETR";
createscanner2:id=312,measurement_name="PREDEF.10112.UETR",file="Fileset.UETR";
createscanner2:id=313,measurement_name="PREDEF.10113.UETR",file="Fileset.UETR";
createscanner2:id=314,measurement_name="PREDEF.10114.UETR",file="Fileset.UETR";
createscanner2:id=315,measurement_name="PREDEF.10115.UETR",file="Fileset.UETR";
createscanner2:id=17,measurement_name="PREDEF.20000.CTR",file="Fileset.CTR";
createscanner2:id=18,measurement_name="PREDEF.20001.CTR",file="Fileset.CTR";
createscanner2:id=19,measurement_name="PREDEF.30000.GPEH",file="Fileset.GPEH";
createscanner2:id=20,measurement_name="PREDEF.30001.GPEH",file="Fileset.GPEH";
createscanner2:id=21,measurement_name="PREDEF.30002.GPEH",file="Fileset.GPEH";
createscanner2:id=22,measurement_name="PREDEF.30003.GPEH",file="Fileset.GPEH";
createscanner2:id=23,measurement_name="PREDEF.30004.GPEH",file="Fileset.GPEH";
createscanner2:id=24,measurement_name="PREDEF.30005.GPEH",file="Fileset.GPEH";
createscanner2:id=25,measurement_name="PREDEF.30006.GPEH",file="Fileset.GPEH";
createscanner2:id=26,measurement_name="PREDEF.30007.GPEH",file="Fileset.GPEH";
createscanner2:id=27,measurement_name="PREDEF.30008.GPEH",file="Fileset.GPEH";
createscanner2:id=28,measurement_name="PREDEF.30009.GPEH",file="Fileset.GPEH";
createscanner2:id=29,measurement_name="PREDEF.30010.GPEH",file="Fileset.GPEH";
createscanner2:id=30,measurement_name="PREDEF.30011.GPEH",file="Fileset.GPEH";
createscanner2:id=31,measurement_name="PREDEF.30012.GPEH",file="Fileset.GPEH";
createscanner2:id=32,measurement_name="PREDEF.30013.GPEH",file="Fileset.GPEH";
createscanner2:id=33,measurement_name="PREDEF.30014.GPEH",file="Fileset.GPEH";
createscanner2:id=34,measurement_name="PREDEF.30015.GPEH",file="Fileset.GPEH";
createscanner2:id=35,measurement_name="PREDEF.30016.GPEH",file="Fileset.GPEH";
createscanner2:id=36,measurement_name="PREDEF.30017.GPEH",file="Fileset.GPEH";
createscanner2:id=37,measurement_name="PREDEF.30018.GPEH",file="Fileset.GPEH";
createscanner2:id=38,measurement_name="PREDEF.30019.GPEH",file="Fileset.GPEH";
createscanner2:id=39,measurement_name="PREDEF.30020.GPEH",file="Fileset.GPEH";
createscanner2:id=40,measurement_name="PREDEF.30021.GPEH",file="Fileset.GPEH";
createscanner2:id=41,measurement_name="PREDEF.30022.GPEH",file="Fileset.GPEH";
createscanner2:id=42,measurement_name="PREDEF.30023.GPEH",file="Fileset.GPEH";
createscanner2:id=43,measurement_name="PREDEF.PRIMARY.STATS",state="SUSPENDED",file="Fileset.STATS";
createscanner2:id=44,measurement_name="PREDEF.SECONDARY.STATS",state="SUSPENDED",file="Fileset.STATS";
pmdata:disable;
pmfstime:time=24;
modifyscanner:noofprocs = 1;
pmstats:files=1;
pmmode:reffile;

.selectnetype RBS
createscanner2:id=100,measurement_name="PREDEF.PRIMARY.STATS",state="SUSPENDED",file="Fileset.STATS";
createscanner2:id=110,measurement_name="PREDEF.RBS.GPEH",file="Fileset.GPEH";
pmdata:disable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;

.selectnetype RXI
createscanner2:id=200,measurement_name="PREDEF.PRIMARY.STATS",state="SUSPENDED",file="Fileset.STATS";
createscanner2:id=210,measurement_name="PREDEF.RBS.GPEH",file="Fileset.GPEH";
pmdata:disable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;

.selectnetype PRBS*
createscanner2:id=1,measurement_name="PREDEF.10000.CELLTRACE",file="Fileset.CTR";
createscanner2:id=2,measurement_name="PREDEF.10001.CELLTRACE",file="Fileset.CTR";
createscanner2:id=3,measurement_name="PREDEF.10002.CELLTRACE",file="Fileset.CTR";
createscanner2:id=4,measurement_name="PREDEF.10003.CELLTRACE",file="Fileset.CTR";
createscanner2:id=5,measurement_name="PREDEF.10004.CELLTRACE",file="Fileset.CTR";
createscanner2:id=6,measurement_name="PREDEF.10005.CELLTRACE",file="Fileset.CTR";
createscanner2:id=7,measurement_name="PREDEF.10006.UETRACE.11223344",file="Fileset.UETR";
createscanner2:id=8,measurement_name="PREDEF.PRIMARY.STATS",state="SUSPENDED",file="Fileset.STATS";
pmdata:disable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;

.select network
setswinstallvariables:createCVFiles=true; 
.saveandcompress ${SIM_NAME} force
EOF
	elif [ "${SIM_TYPE}" = "LTE" ] ; then
		cat >> ${CMD_FILE} <<EOF
.open ${SIM_NAME}
.select network
.start
.genreffilecpp lte Fileset.GPEH gpeh default
.genreffilecpp lte Fileset.STATS stats default
.genreffilecpp lte Fileset.CTR ctr default
.genreffilecpp lte Fileset.UETR uetr default
.selectnetype ERBS
createscanner2:id=1,measurement_name="PREDEF.10000.CELLTRACE",file="Fileset.CTR";
createscanner2:id=2,measurement_name="PREDEF.10001.CELLTRACE",file="Fileset.CTR";
createscanner2:id=3,measurement_name="PREDEF.10002.CELLTRACE",file="Fileset.CTR";
createscanner2:id=4,measurement_name="PREDEF.10003.CELLTRACE",file="Fileset.CTR";
createscanner2:id=5,measurement_name="PREDEF.10004.CELLTRACE",file="Fileset.CTR";
createscanner2:id=6,measurement_name="PREDEF.10005.CELLTRACE",file="Fileset.CTR";
createscanner2:id=100,measurement_name="PREDEF.STATS",state="SUSPENDED",file="Fileset.STATS";
pmdata:disable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;
.select network
.saveandcompress ${SIM_NAME} force
EOF

	elif [ "${SIM_TYPE}" = "MSRBS" ] ; then
		cat >> ${CMD_FILE} <<EOF
.open ${SIM_NAME}
.select network
.start
.selectnetype RNC
.genreffilecpp wcdma Fileset.GPEH gpeh default
.genreffilecpp wcdma Fileset.STATS stats default
.genreffilecpp wcdma Fileset.CTR ctr default
.genreffilecpp wcdma Fileset.UETR uetr default
createscanner2:id=1,measurement_name="PREDEF.10000.UETR",file="Fileset.UETR";
createscanner2:id=2,measurement_name="PREDEF.10001.UETR",file="Fileset.UETR";
createscanner2:id=3,measurement_name="PREDEF.10002.UETR",file="Fileset.UETR";
createscanner2:id=4,measurement_name="PREDEF.10003.UETR",file="Fileset.UETR";
createscanner2:id=5,measurement_name="PREDEF.10004.UETR",file="Fileset.UETR";
createscanner2:id=6,measurement_name="PREDEF.10005.UETR",file="Fileset.UETR";
createscanner2:id=7,measurement_name="PREDEF.10006.UETR",file="Fileset.UETR";
createscanner2:id=8,measurement_name="PREDEF.10007.UETR",file="Fileset.UETR";
createscanner2:id=9,measurement_name="PREDEF.10008.UETR",file="Fileset.UETR";
createscanner2:id=10,measurement_name="PREDEF.10009.UETR",file="Fileset.UETR";
createscanner2:id=11,measurement_name="PREDEF.10010.UETR",file="Fileset.UETR";
createscanner2:id=12,measurement_name="PREDEF.10011.UETR",file="Fileset.UETR";
createscanner2:id=13,measurement_name="PREDEF.10012.UETR",file="Fileset.UETR";
createscanner2:id=14,measurement_name="PREDEF.10013.UETR",file="Fileset.UETR";
createscanner2:id=15,measurement_name="PREDEF.10014.UETR",file="Fileset.UETR";
createscanner2:id=16,measurement_name="PREDEF.10015.UETR",file="Fileset.UETR";
createscanner2:id=216,measurement_name="PREDEF.10016.UETR",file="Fileset.UETR";
createscanner2:id=217,measurement_name="PREDEF.10017.UETR",file="Fileset.UETR";
createscanner2:id=218,measurement_name="PREDEF.10018.UETR",file="Fileset.UETR";
createscanner2:id=219,measurement_name="PREDEF.10019.UETR",file="Fileset.UETR";
createscanner2:id=220,measurement_name="PREDEF.10020.UETR",file="Fileset.UETR";
createscanner2:id=221,measurement_name="PREDEF.10021.UETR",file="Fileset.UETR";
createscanner2:id=222,measurement_name="PREDEF.10022.UETR",file="Fileset.UETR";
createscanner2:id=223,measurement_name="PREDEF.10023.UETR",file="Fileset.UETR";
createscanner2:id=224,measurement_name="PREDEF.10024.UETR",file="Fileset.UETR";
createscanner2:id=225,measurement_name="PREDEF.10025.UETR",file="Fileset.UETR";
createscanner2:id=226,measurement_name="PREDEF.10026.UETR",file="Fileset.UETR";
createscanner2:id=227,measurement_name="PREDEF.10027.UETR",file="Fileset.UETR";
createscanner2:id=228,measurement_name="PREDEF.10028.UETR",file="Fileset.UETR";
createscanner2:id=229,measurement_name="PREDEF.10029.UETR",file="Fileset.UETR";
createscanner2:id=230,measurement_name="PREDEF.10030.UETR",file="Fileset.UETR";
createscanner2:id=231,measurement_name="PREDEF.10031.UETR",file="Fileset.UETR";
createscanner2:id=232,measurement_name="PREDEF.10032.UETR",file="Fileset.UETR";
createscanner2:id=233,measurement_name="PREDEF.10033.UETR",file="Fileset.UETR";
createscanner2:id=234,measurement_name="PREDEF.10034.UETR",file="Fileset.UETR";
createscanner2:id=235,measurement_name="PREDEF.10035.UETR",file="Fileset.UETR";
createscanner2:id=236,measurement_name="PREDEF.10036.UETR",file="Fileset.UETR";
createscanner2:id=237,measurement_name="PREDEF.10037.UETR",file="Fileset.UETR";
createscanner2:id=238,measurement_name="PREDEF.10038.UETR",file="Fileset.UETR";
createscanner2:id=239,measurement_name="PREDEF.10039.UETR",file="Fileset.UETR";
createscanner2:id=240,measurement_name="PREDEF.10040.UETR",file="Fileset.UETR";
createscanner2:id=241,measurement_name="PREDEF.10041.UETR",file="Fileset.UETR";
createscanner2:id=242,measurement_name="PREDEF.10042.UETR",file="Fileset.UETR";
createscanner2:id=243,measurement_name="PREDEF.10043.UETR",file="Fileset.UETR";
createscanner2:id=244,measurement_name="PREDEF.10044.UETR",file="Fileset.UETR";
createscanner2:id=245,measurement_name="PREDEF.10045.UETR",file="Fileset.UETR";
createscanner2:id=246,measurement_name="PREDEF.10046.UETR",file="Fileset.UETR";
createscanner2:id=247,measurement_name="PREDEF.10047.UETR",file="Fileset.UETR";
createscanner2:id=248,measurement_name="PREDEF.10048.UETR",file="Fileset.UETR";
createscanner2:id=249,measurement_name="PREDEF.10049.UETR",file="Fileset.UETR";
createscanner2:id=250,measurement_name="PREDEF.10050.UETR",file="Fileset.UETR";
createscanner2:id=251,measurement_name="PREDEF.10051.UETR",file="Fileset.UETR";
createscanner2:id=252,measurement_name="PREDEF.10052.UETR",file="Fileset.UETR";
createscanner2:id=253,measurement_name="PREDEF.10053.UETR",file="Fileset.UETR";
createscanner2:id=254,measurement_name="PREDEF.10054.UETR",file="Fileset.UETR";
createscanner2:id=255,measurement_name="PREDEF.10055.UETR",file="Fileset.UETR";
createscanner2:id=256,measurement_name="PREDEF.10056.UETR",file="Fileset.UETR";
createscanner2:id=257,measurement_name="PREDEF.10057.UETR",file="Fileset.UETR";
createscanner2:id=258,measurement_name="PREDEF.10058.UETR",file="Fileset.UETR";
createscanner2:id=259,measurement_name="PREDEF.10059.UETR",file="Fileset.UETR";
createscanner2:id=260,measurement_name="PREDEF.10060.UETR",file="Fileset.UETR";
createscanner2:id=261,measurement_name="PREDEF.10061.UETR",file="Fileset.UETR";
createscanner2:id=262,measurement_name="PREDEF.10062.UETR",file="Fileset.UETR";
createscanner2:id=263,measurement_name="PREDEF.10063.UETR",file="Fileset.UETR";
createscanner2:id=264,measurement_name="PREDEF.10064.UETR",file="Fileset.UETR";
createscanner2:id=265,measurement_name="PREDEF.10065.UETR",file="Fileset.UETR";
createscanner2:id=266,measurement_name="PREDEF.10066.UETR",file="Fileset.UETR";
createscanner2:id=267,measurement_name="PREDEF.10067.UETR",file="Fileset.UETR";
createscanner2:id=268,measurement_name="PREDEF.10068.UETR",file="Fileset.UETR";
createscanner2:id=269,measurement_name="PREDEF.10069.UETR",file="Fileset.UETR";
createscanner2:id=270,measurement_name="PREDEF.10070.UETR",file="Fileset.UETR";
createscanner2:id=271,measurement_name="PREDEF.10071.UETR",file="Fileset.UETR";
createscanner2:id=272,measurement_name="PREDEF.10072.UETR",file="Fileset.UETR";
createscanner2:id=273,measurement_name="PREDEF.10073.UETR",file="Fileset.UETR";
createscanner2:id=274,measurement_name="PREDEF.10074.UETR",file="Fileset.UETR";
createscanner2:id=275,measurement_name="PREDEF.10075.UETR",file="Fileset.UETR";
createscanner2:id=276,measurement_name="PREDEF.10076.UETR",file="Fileset.UETR";
createscanner2:id=277,measurement_name="PREDEF.10077.UETR",file="Fileset.UETR";
createscanner2:id=278,measurement_name="PREDEF.10078.UETR",file="Fileset.UETR";
createscanner2:id=279,measurement_name="PREDEF.10079.UETR",file="Fileset.UETR";
createscanner2:id=280,measurement_name="PREDEF.10080.UETR",file="Fileset.UETR";
createscanner2:id=281,measurement_name="PREDEF.10081.UETR",file="Fileset.UETR";
createscanner2:id=282,measurement_name="PREDEF.10082.UETR",file="Fileset.UETR";
createscanner2:id=283,measurement_name="PREDEF.10083.UETR",file="Fileset.UETR";
createscanner2:id=284,measurement_name="PREDEF.10084.UETR",file="Fileset.UETR";
createscanner2:id=285,measurement_name="PREDEF.10085.UETR",file="Fileset.UETR";
createscanner2:id=286,measurement_name="PREDEF.10086.UETR",file="Fileset.UETR";
createscanner2:id=287,measurement_name="PREDEF.10087.UETR",file="Fileset.UETR";
createscanner2:id=288,measurement_name="PREDEF.10088.UETR",file="Fileset.UETR";
createscanner2:id=289,measurement_name="PREDEF.10089.UETR",file="Fileset.UETR";
createscanner2:id=290,measurement_name="PREDEF.10090.UETR",file="Fileset.UETR";
createscanner2:id=291,measurement_name="PREDEF.10091.UETR",file="Fileset.UETR";
createscanner2:id=292,measurement_name="PREDEF.10092.UETR",file="Fileset.UETR";
createscanner2:id=293,measurement_name="PREDEF.10093.UETR",file="Fileset.UETR";
createscanner2:id=294,measurement_name="PREDEF.10094.UETR",file="Fileset.UETR";
createscanner2:id=295,measurement_name="PREDEF.10095.UETR",file="Fileset.UETR";
createscanner2:id=296,measurement_name="PREDEF.10096.UETR",file="Fileset.UETR";
createscanner2:id=297,measurement_name="PREDEF.10097.UETR",file="Fileset.UETR";
createscanner2:id=298,measurement_name="PREDEF.10098.UETR",file="Fileset.UETR";
createscanner2:id=299,measurement_name="PREDEF.10099.UETR",file="Fileset.UETR";
createscanner2:id=300,measurement_name="PREDEF.10100.UETR",file="Fileset.UETR";
createscanner2:id=301,measurement_name="PREDEF.10101.UETR",file="Fileset.UETR";
createscanner2:id=302,measurement_name="PREDEF.10102.UETR",file="Fileset.UETR";
createscanner2:id=303,measurement_name="PREDEF.10103.UETR",file="Fileset.UETR";
createscanner2:id=304,measurement_name="PREDEF.10104.UETR",file="Fileset.UETR";
createscanner2:id=305,measurement_name="PREDEF.10105.UETR",file="Fileset.UETR";
createscanner2:id=306,measurement_name="PREDEF.10106.UETR",file="Fileset.UETR";
createscanner2:id=307,measurement_name="PREDEF.10107.UETR",file="Fileset.UETR";
createscanner2:id=308,measurement_name="PREDEF.10108.UETR",file="Fileset.UETR";
createscanner2:id=309,measurement_name="PREDEF.10109.UETR",file="Fileset.UETR";
createscanner2:id=310,measurement_name="PREDEF.10110.UETR",file="Fileset.UETR";
createscanner2:id=311,measurement_name="PREDEF.10111.UETR",file="Fileset.UETR";
createscanner2:id=312,measurement_name="PREDEF.10112.UETR",file="Fileset.UETR";
createscanner2:id=313,measurement_name="PREDEF.10113.UETR",file="Fileset.UETR";
createscanner2:id=314,measurement_name="PREDEF.10114.UETR",file="Fileset.UETR";
createscanner2:id=315,measurement_name="PREDEF.10115.UETR",file="Fileset.UETR";
createscanner2:id=17,measurement_name="PREDEF.20000.CTR",file="Fileset.CTR";
createscanner2:id=18,measurement_name="PREDEF.20001.CTR",file="Fileset.CTR";
createscanner2:id=19,measurement_name="PREDEF.30000.GPEH",file="Fileset.GPEH";
createscanner2:id=20,measurement_name="PREDEF.30001.GPEH",file="Fileset.GPEH";
createscanner2:id=21,measurement_name="PREDEF.30002.GPEH",file="Fileset.GPEH";
createscanner2:id=22,measurement_name="PREDEF.30003.GPEH",file="Fileset.GPEH";
createscanner2:id=23,measurement_name="PREDEF.30004.GPEH",file="Fileset.GPEH";
createscanner2:id=24,measurement_name="PREDEF.30005.GPEH",file="Fileset.GPEH";
createscanner2:id=25,measurement_name="PREDEF.30006.GPEH",file="Fileset.GPEH";
createscanner2:id=26,measurement_name="PREDEF.30007.GPEH",file="Fileset.GPEH";
createscanner2:id=27,measurement_name="PREDEF.30008.GPEH",file="Fileset.GPEH";
createscanner2:id=28,measurement_name="PREDEF.30009.GPEH",file="Fileset.GPEH";
createscanner2:id=29,measurement_name="PREDEF.30010.GPEH",file="Fileset.GPEH";
createscanner2:id=30,measurement_name="PREDEF.30011.GPEH",file="Fileset.GPEH";
createscanner2:id=31,measurement_name="PREDEF.30012.GPEH",file="Fileset.GPEH";
createscanner2:id=32,measurement_name="PREDEF.30013.GPEH",file="Fileset.GPEH";
createscanner2:id=33,measurement_name="PREDEF.30014.GPEH",file="Fileset.GPEH";
createscanner2:id=34,measurement_name="PREDEF.30015.GPEH",file="Fileset.GPEH";
createscanner2:id=35,measurement_name="PREDEF.30016.GPEH",file="Fileset.GPEH";
createscanner2:id=36,measurement_name="PREDEF.30017.GPEH",file="Fileset.GPEH";
createscanner2:id=37,measurement_name="PREDEF.30018.GPEH",file="Fileset.GPEH";
createscanner2:id=38,measurement_name="PREDEF.30019.GPEH",file="Fileset.GPEH";
createscanner2:id=39,measurement_name="PREDEF.30020.GPEH",file="Fileset.GPEH";
createscanner2:id=40,measurement_name="PREDEF.30021.GPEH",file="Fileset.GPEH";
createscanner2:id=41,measurement_name="PREDEF.30022.GPEH",file="Fileset.GPEH";
createscanner2:id=42,measurement_name="PREDEF.30023.GPEH",file="Fileset.GPEH";
createscanner2:id=43,measurement_name="PREDEF.PRIMARY.STATS",state="SUSPENDED",file="Fileset.STATS";
createscanner2:id=44,measurement_name="PREDEF.SECONDARY.STATS",state="SUSPENDED",file="Fileset.STATS";
pmdata:disable;
pmfstime:time=24;
modifyscanner:noofprocs = 1;
pmstats:files=1;
pmmode:reffile;

.selectnetype MSRBS-V2
.genreffilecpp lte Fileset.GPEH gpeh default
.genreffilecpp lte Fileset.STATS stats default
.genreffilecpp lte Fileset.CTR ctr default
.genreffilecpp lte Fileset.UETR uetr default
createscanner2:id=101,measurement_name="PREDEF.10016.UETR",file="Fileset.UETR";
createscanner2:id=102,measurement_name="PREDEF.10017.UETR",file="Fileset.UETR";
createscanner2:id=103,measurement_name="PREDEF.10018.UETR",file="Fileset.UETR";
createscanner2:id=104,measurement_name="PREDEF.10019.UETR",file="Fileset.UETR";
createscanner2:id=105,measurement_name="PREDEF.20020.GPEH",file="Fileset.GPEH";
createscanner2:id=106,measurement_name="PREDEF.20021.GPEH",file="Fileset.GPEH";
createscanner2:id=108,measurement_name="PREDEF.20022.GPEH",file="Fileset.GPEH";
createscanner2:id=107,measurement_name="PREDEF.20023.GPEH",file="Fileset.GPEH";
createscanner2:id=109,measurement_name="PREDEF.30024.CELLTRACE",file="Fileset.CTR";
createscanner2:id=110,measurement_name="PREDEF.30025.CELLTRACE",file="Fileset.CTR";
createscanner2:id=111,measurement_name="PREDEF.30026.CELLTRACE",file="Fileset.CTR";
createscanner2:id=112,measurement_name="PREDEF.30027.CELLTRACE",file="Fileset.CTR";
createscanner2:id=113,measurement_name="PREDEF.30028.CELLTRACE",file="Fileset.CTR";
createscanner2:id=114,measurement_name="PREDEF.30029.CELLTRACE",file="Fileset.CTR";
createscanner2:id=215,measurement_name="PREDEF.STATS",state="SUSPENDED",file="Fileset.STATS";
pmdata:disable;
pmfstime:time=24;
pmstats:files=1;
pmmode:reffile;
.select network
setswinstallvariables:createCVFiles=true; 
.saveandcompress ${SIM_NAME} force
EOF
	fi
    done

    echo "INFO: Creating scanners"
    /netsim/inst/netsim_pipe < ${CMD_FILE} 
}

deleteScanners() {
    CMD_FILE=/tmp/delete_scanners.cmd
    if [ -r ${CMD_FILE} ] ; then
	rm ${CMD_FILE}
    fi

    for SIM in $LIST ; do	
	
	SIM_NAM=`ls /netsim/netsimdir | grep ${SIM} `
	SIM_NAME=`echo $SIM_NAM | rev | cut -c 5- | rev`
	SIM_TYPE=`getSimType ${SIM_NAME}`
	#SIM_NAME=`ls /netsim/netsimdir/ | grep ${SIM} | grep -v zip`
	
	#log "INFO: Reading scanners in ${SIM}"

	NE_TYPE_LIST=""
	if [ "${SIM_TYPE}" = "WRAN" ] ; then
	    NE_TYPE_LIST="RNC RBS RXI PRBS*"		
	elif [ "${SIM_TYPE}" = "LTE" ] ; then
	    NE_TYPE_LIST="ERBS"
	elif [ "${SIM_TYPE}" = "MSRBS" ] ; then
	    NE_TYPE_LIST="MSRBS-V2 RNC"
	fi

	echo ".open ${SIM_NAME}" >> ${CMD_FILE}

	for NE_TYPE in ${NE_TYPE_LIST} ; do
	    /netsim/inst/netsim_pipe <<EOF > /tmp/scannerlist.txt
.open ${SIM_NAME}
.selectnetype ${NE_TYPE}
showscanners2;
EOF
	    echo ".selectnetype ${NE_TYPE}" >> ${CMD_FILE}
	    # New a sort -u cause now we're get an output per NE
            cat /tmp/scannerlist.txt | awk '{ if ( $2 ~ /^PREDEF/ ) {print $1} }' | sort -un \
                | awk '{ printf "deletescanner2:id=%d;\n", $1; }' \
                >> ${CMD_FILE}
	done
    done    

    echo "INFO: Deleting scanners"
    /netsim/inst/netsim_pipe < ${CMD_FILE} 
}
LIST=`ls -ltr /netsim/netsimdir/scanner |egrep 'LTE|ERBS|WRAN|RNC|RBS|RXI|PRBS' | tr -s " " | cut -d " " -f 9 | grep  "zip"`
	deleteScanners
	createScanners
  
echo "Scanners available"    




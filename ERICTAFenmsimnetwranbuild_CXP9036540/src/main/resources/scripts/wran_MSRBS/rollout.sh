#!/bin/bash 
#
# Name    : rollout.sh
# Written : TEP
# Date    : 2010 - ~
# Purpose : NETSim Rollout
#

source /var/www/html/scripts/automation_wran/support/message.sh
if [[ -n $HTTP_ACCEPT ]];then echo -e "Content-type: text/plain\n\n";fi

ALL_COMMAND_ARGUMENTS=$@
AWK=/bin/awk
BASENAME=/bin/basename
CAT=/bin/cat
CHMOD=/usr/bin/chmod
CLEAR=/usr/bin/clear
CP=/bin/cp
CUT=/usr/bin/cut
DATE=/usr/bin/date
DIRNAME=/usr/bin/dirname
DOMAINNAME=/usr/bin/domainname
EGREP=/bin/egrep
EXPR=/usr/bin/expr
GETENT=/usr/bin/getent
GREP=/bin/grep
HEAD=/usr/bin/head
HOSTNAME=/bin/hostname
ID=/usr/bin/id
IFCONFIG=/sbin/ifconfig
LS=/bin/ls
MKDIR=/bin/mkdir
MORE=/usr/bin/more
MOUNT=/bin/mount
MV=/bin/mv
NAWK=/bin/awk
NSLOOKUP=/usr/sbin/nslookup
PING=/bin/ping
RM=/bin/rm
RCP=/usr/bin/rcp
RSH="/usr/bin/rsh -K"
SED=/usr/bin/sed
SLEEP=/bin/sleep
SORT=/usr/bin/sort
TAIL=/usr/bin/tail
TELNET=/usr/bin/telnet
TOUCH=/bin/touch
TR=/usr/bin/tr
UMOUNT=/bin/umount
UNAME=/bin/uname
UNIQ=/usr/bin/uniq
WC=/usr/bin/wc
startAdjust=/opt/ericsson/fwSysConf/bin/startAdjust.sh
smtool=/opt/ericsson/nms_cif_sm/bin/smtool
CSTEST=/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest
JPS=/opt/ericsson/ddc/util/bin/jps

SSH="/usr/bin/ssh -o LogLevel=QUIET -oStrictHostKeyChecking=no "
SCP="/usr/bin/scp -o LogLevel=QUIET"
SCRIPT_LOGFILE=""
unset DISPLAY

declare -A netsimServerSimulationsFiltered
declare -A netsimServerSimulations

ME=`basename $0`	# for output messages

# ********************************************************************
#
#       Variable Definition
#
# ********************************************************************
SCRIPTHOST=atrclin3
SCRIPTDIR=/var/www/html/scripts/automation_wran
MOUNTPOINT=/mnt
CONFIGFILE=/var/www/html/scripts/automation_wran/config.cfg
FTPSERVER=ftp.athtem.eei.ericsson.se
FTPUSER=simguest
FTPPASSWD=simguest
NETSIMSHELL=/netsim/inst/netsim_shell
NETSIMPIPE=/netsim/inst/netsim_shell
formatedDate=`date +\%d_\%m_\%Y-%H.%M.%S`

# Parallel related variables
processes_remaining_last=999
parallel_pids=""
parallel_strings=()
parallel_logs=()

### Function: ctrl_c ###
#
#   Traps ctrl_c and exits
#
# Arguments:
#       none
# Return Values:
#       none
ctrl_c()
{
    echo -e "\nERROR: CTRL-C detected. Do you wish to exit (y/n)?"
    echo -e "INPUT: \c"
    read ANS
    if [ "$ANS" = "y" ]
    then
        echo "INFO: Script exiting due to CTRL-C"
        exit_routine 50
    fi
}

### Function: usage_msg ###
#
#   Print out the usage message
#
# Arguments:
#       none
# Return Values:
#       none
usage_msg()
{
    if [[ $ROLLOUT == "GRAN" ]]
    then
        echo "Usage: rollout.sh  [ -u USERID ] [ -a SECURITY ] [ -s oss_server_name | -n netsim_server_name ] [-d deployment] [ -c config file ] [ -z y/n use_new_functions ] [ -f function ] [ -i interaction ] [ -e notification_email_address ]"
		./gran_run.sh|egrep -v "ERROR:|Usage:"
    else
        echo "
        Usage: rollout.sh  [ -c CONFIGFILE ] [ -u USERID ] [ -s OSS server [ -a SECURITY oss server ] [ -n SERVERS netsimserver filter ] [ -g SIMLIST filter ] [ -f FUNCTIONS ] [ -z y/n use_new_functions ] [ -i INTERACTION ] [ -v VERBOSITY ]

        -u : Ericsson User ID
        -c : config file (Optional, if not specified, script will use file $CONFIGFILE)

        -d : deployment eg -d cominf
        -a : security (eg NPT or cominf)

        -s : This is the hostname of the OSS server you wish to perform rollout for.
        -n : This is the hostname of the NETSim server you wish to perform rollout for.

        -f : This is if you wish to run 1 function of the script singly.
        -i : Delete sims y/n - No prompt for Keep simulations will be displayed if set - set to n
        -o : OFFSET - ip offset - Keep existing sims + use availbale subnets only
        eg -o 4 - rollout will ignore the first 4 subnets or 1000 ipaddress
        -x : x OFFSET - start assigning from this ip address or nr (ipv6 compatible)
        eg -x 192.168.1.50 || -x 1000
        -g : Apply a filter to SIMLIST - eg -g RNC04 (just run against RNC04)
        -r : Network Type - GRAN if necessary
        -z : Use -z y to use the new parallel version of some functions which are faster
        -e : Use -e with your email address as an argument, to have an email sent with the log of output when completed
        -h : search for function for more man rollout
        -v : verbosity level quiet=0 +ERROR=$ERROR +WARNING=$WARNING +INFO=$INFO +DEBUG=$DEBUG 

        ### LTE WRAN rollout steps:

        rollout               rollout simulations to netsimboxes with followoing steps:
        - check_netsim_shell  checks that netsim pipe is working
        - delete_sims         looks for simulation that might need to be deleted (asking)
        - make_ports          makes NetSimPort
        - get_sims            ftps simulations onto the box acording to config
        - set_ips             assignes ips either C,F, continues or auto
        - deploy_amos_and_c   copy userdefined commands and licenses (becomming obsolete NR:2130,2131)
        - start_all           starts all nodes on netsims exits on failure
        - setup_variables     sets up some default variables (becoming obsolete)
        - create_users        creates users for simulations
        - copy_config_file_to_netsim copies config file to netsimbox
        - generate_ip_map     generates_ip_map on netsimbox for amos
        - upload_ip_map       upload amos file
        - show_sims 
        - post_scripts        
        - login_banner        updates the login banner
        - save_config         backups ip_map config below savedconfig/netsimserver123/

        ### LTE WRAN other simulation functions ###
        delete_sim         You can delete specific sims
        show_started       Show started nodes
        show_subnets_wran  show all ipaddress on netsim
        sim_summary_wran   sim summary

        ### Arne default steps:
        rollout_arne
        - generate_arne      generates xmls from netsimboxs
        - upload_arne        uploads arne from savedconfig/$host/$date/arnefiles to $oss:/home/nmsadm/tep
        - arne_validate      validate all xmls on oss server
        - arne_import        import all xmls on oss server (Tracing is ON)
        - arne_dump          Dump the CS once import is finished
        - start_adjust_maf   synchronizes nodes ONRM_CS and Seg_masterservice_CS

        ### Arne other functions:
        arne_delete        deletes all nodes or selection -g on master

        ### Arne siu based generation:
        generate_arne_siu
        - check_siu_ftp      checks if ftp locations are ready on the master
        - generate_arne      generate arne as normal 
        - createAssociationsTextFile creates association file table from live data
        - siu_xml_mod        modifies netsim arne xmls with siu and subnet information

        ### Gran based rollout
        rollout_gran         gran based rollout
        - check_netsim_shell checks that netsim pipe is working
        - delete_sims        looks for simulation that might need to be deleted (asking)
        - get_sims_gran      ftps the gran simulation
        - make_ports_gran    makes ports for gran
        - make_destination   makes destinations for gran
        - rename_all         renames the nodes
        - set_ips_gran       sets ips, port, default destination gran
        - set_cpus           ?
        - start_all          starts all nodes
        - lanswitch_acl      ?
        - check_ssh_setup    ?
        - create_users_gran  create users the gran way
        
        ### pm related functions:
        create_scanners
        delete_scanners
        check_pm           Verifies that pm is setup correctly
        pm_rollout         full pm rollout

        ######### Standalone Functions ##################

        all_final_checks   runs all checks before handover

        ### oss related functions ###

        cello_ping         cello ping nodes directly from the oss
        check_mims         retrieve mim list from OSS
        cstest_all         Show all imported nodes on OSS
        cstest_ftp         cstest retrieve list of ftp services
        cstest_me          cstest retrieve node info
        check_master       checks if masterserver is ready for arne import
        check_onrm_cs      checks nodes on master ONRM_CS against nodes on the netsims
        check_seg_cs       checks nodes on master Seg_masterservice_CS against nodes on the netsims
        check_omsas        checks nodes on OMSAS (CAAS) against nodes on the netsims
        restart_arne_mcs   Restarts the arne related mcs
        ssh_connection     setup atrclin3 ssh key on chosen OSS server
        verify_MAF         shows WRAN and LTE nodes in ONRM_CS and Seg_masterservice_CS

        ### netsim administrative functions ###

        start_netsim       start netsim
        stop_netsim        stop netsim
        restart_netsim     restart netsim
        restart_netsim_gui restart netsim_gui
        install_netsim     installs netsim
        install_patch      install a netsim patch
        check_installed_patches    checks netsim patches
        check_netsim_version   displays netsim version
        setup_netsim_ftp   sets the default ftp download location (helpfull for using the gui)
        setup_rsh          Setup rsh on netsim
        check_os_details   checks netsimbox os
        reboot_host        reboots the netsim machine
        stop_relay         stop netsim relay ( relay is obsolete since R24F )
        restart_relay      restart netsim relay ( relay is obsolete since R24F )
        check_relay        Checks if the netsim relay is started or not (obsolete since R24F)
        netsim_dance       dance (pdsh) with all netsims as user netsim
        netsim_dance_root  dance (pdsh) with all netsims as user root

        disable_security   disable L2 security

        check_nead_status_on_master
        gets the most important parts of the ying yang file on the master server 
        showing the amount of nodes synced.


        ######### Security Related Functions ##################
        show_security_level     Checks security level mo
        setup_external_ssh      Enables external ssh (old)

        set_security_MO_sl1     sets security to sl1 on sims (ftp unsecure)
        disable_chrooted        disables chrooted on netsim
        enable_corba_security   enables corba (off->on) to (on) will stop all nodes and start afterwards

        setup_sl2_phase1
        - create_pem_sl2        create the .pem files needed for rollout

        setup_sl2_phase2
        - upload_pems_sl2
        - setup_internal_ssh    Enables internal ssh
        - set_security_MO_sl2   sets security to sl2 on sims (sftp secure without corba)

        setup_sl3_phase1        Sets up internal ssh and enables chrooted environment
        - setup_internal_ssh    Enables internal ssh
        - enable_chrooted       Enables chrooted environment

        initial_enrollment      generate pem for one node and stores it on `hostname`
                                this pem can then be used accross all nodes (upload_pems_sl3)

        setup_sl3_phase2        does all below:
        - upload_pems_sl3                 uploads pems stored in subscripts/security/$ -a 
        - set_security_definitions_sl3    tells each node what pem to use
        - set_caas_ip                     tells each node what caas ip to use
        - set_security_MO_sl3             tells each node to go to sec level 3
        - show_security_status
        - check_sftp                      tries to sftp the first node of each simulation
                                          from the master server

       ****** for more info check manpage:man rollout  *******
        "
    fi
}

### Function: check_args ###
#
#   Checks Arguments
#
# Arguments:
#       none
# Return Values:
#       none
check_args()
{
	local ME=check_args
	
    if [ -z "$VERBOSE" ]
    then
    	# see message.sh logging script for details on this
		VERBOSE=$WARNING
		export VERBOSE=$VERBOSE
    fi
    
    message 0 "DEBUG: verbosity set to $VERBOSE change with -v 20\n"
    
    if [ -z "$SERVER" ]
    then
        #Exception if -f history is run
        if [[ $FUNCTIONS == "history" ]]
        then
            history
            exit 1
        else
	    	message $DEBUG "$ME: no SERVER $SERVER specified taking it from config "
            SERVER=`egrep "^OSS=" $CONFIGFILE | awk -F= '{print $2}'|awk '{print $1}'`
		    if [ -z "$SERVER" ]
    		then
	            message $ERROR "FAILED no OSS= in config! $CONFIGFILE !\n"
    		else
    			message $DEBUG " OSS=$SERVER\n"
    		fi
        fi
    fi

    if [ -z "$SECURITY" ]
    then
        message $DEBUG "DEBUG $ME: Security (-a) not set,taking SECURITY from config\n"
        SECURITY=`egrep "^SECURITY=" $CONFIGFILE | $AWK -F= '{print $2}'|awk '{print $1}'`
	    if [ -z "$SECURITY" ]
		then
			message $WARNING "WARNING No SECURITY in config file or set via -a! Script might exit...\n"
			if not_sure_to_continue 
			then
				exit 7
			fi
		else
			message $DEBUG "DEBUG $ME: SECURITY=$SECURITY\n"
		fi
    fi

    if [ -z "$DEPLOYMENT" ]
    then
        DEPLOYMENT="Standard"
        message $DEBUG "DEBUG: $DEPLOYMENT deployment chosen\n"
    else
        echo $DEPLOYMENT | $EGREP -i "^cominf$" >> /dev/null
        TEST=`echo $?`
        if [ $TEST -ne 0 ]
        then
            echo "ERROR: You must specify a supported deployment -d cominf"
            usage_msg	
            exit 1
        else
            message $DEBUG "DEBUG $ME: Deployment is $DEPLOYMENT\n"
        fi
    fi

    #ejershe
    if [ -n "$INTERACTION" ]
    then
        message $DEBUG "DEBUG: Interaction set to $INTERACTION \n"
        if [ -n "$NODEFILTER" ]
        then
            echo "ERROR: You cannot set -i and -g simultaneously\n"
            exit_routine 1
        fi
    else
        message $DEBUG "DEBUG $ME:-i not set setting interaction to y\n"
        INTERACTION="y"
    fi

    #ejershe - ip subnet OFFSET
    if [ -n "$OFFSET" ]
    then
        echo "INFO: IP OFFSET is set to $OFFSET"
    fi

	# helge if -u not set default to USER
    if [ -z "$USERID" ]
    then
    	USERID="$USER"
    	ALL_COMMAND_ARGUMENTS="$ALL_COMMAND_ARGUMENTS -u $USERID"
    fi
    
    # helge - root as userid not allowed
    if [ "$USERID" == "root" ]
    then
   	   echo "ERROR: please login with your username or specify USER ID -u other then root"
       exit 1
    fi

    message $DEBUG "DEBUG $ME: USERID set to $USERID\n"

    #ekemark
    if [ "$NEWER_FUNCTIONS" == "y" ]
    then
        message $DEBUG "DEBUG $ME: Using newer function versions\n"
    fi

    if [[ $FUNCTIONS =~ "rollout" ]]
    then
        if [[ $SECURITY == "" ]]
        then
            echo "ERROR: Security (-a) must be set when doing a FULL rollout... Exiting"
            exit_routine 1
        fi
    fi

    #############################################
    # ekemark, log output to logfile and to screen
    # ehelweh, logfile name by configfile continusly 
    #############################################
    SCRIPT_LOGFILE=/var/www/html/scripts/automation_wran/logs/`basename $CONFIGFILE`.log
    message $DEBUG "DEBUG $ME: Logging full log to $SCRIPT_LOGFILE\n"
    npipe=/tmp/$$.tmp
    mknod $npipe p
    tee -a <$npipe $SCRIPT_LOGFILE &
    exec 1>&- 2>&-
    exec 1>$npipe 2>$npipe
    disown %-
    #############################################

    #############################################
    # ehelweh, compact log with last commands
    #############################################
    SCRIPT_COMPACT_LOGFILE=/var/www/html/scripts/automation_wran/logs/`basename $CONFIGFILE`.compact.log
    touch $SCRIPT_COMPACT_LOGFILE
    echo "${formatedDate} Command Run: $0 $ALL_COMMAND_ARGUMENTS" >> $SCRIPT_COMPACT_LOGFILE
    message $DEBUG "DEBUG $ME: Logging short log to $SCRIPT_COMPACT_LOGFILE\n"
    #############################################

    echo "Command Run: $0 $ALL_COMMAND_ARGUMENTS"

    if [[ $FUNCTIONS != "history" && "$EMAIL_ADDRESS" != "" ]]
    then
        echo "INFO: Email notification enabled"
        trap email_log EXIT TERM
    fi
}

### Function: check_config_file ###
#
#   Perform Check config file
#
# Arguments:
#       none
# Return Values:
#       none
check_config_file()
{
    if [ -z "$CONFIGFILEARG" ]
 	then 
    	echo "WARNING: Using default config file $CONFIGFILE"; #helge: dont know why this is here
	else 
		CONFIGFILE=$CONFIGFILEARG
    fi

    if [ ! -f $CONFIGFILE ]
    then
        echo "ERROR: Cannot find Config File $CONFIGFILE. Please investigate. Exiting"
        exit_routine 5
    fi    
}

parse_simlist_for_host(){
	local host=$1
	
	message $DEBUG "DEBUG: parse_simlist_for_host($host)\n"
	local SIMLIST=`$EGREP "^${host}_list=" $CONFIGFILE | $AWK -F\" '{print $2}'`
   	netsimServerSimulations[${host}]="$SIMLIST"

    #Apply filter to SIMLIST
   	if [[ $NODEFILTER != "" ]]
   	then
		local SIMLIST=`filterStringFromStringSpaced.sh "$NODEFILTER" "$SIMLIST"`
		netsimServerSimulationsFiltered["$host"]="$SIMLIST"
     else
		netsimServerSimulationsFiltered["$host"]="$SIMLIST"
     fi
}

### Function: get_netsim_servers ###
#
#   Perform Get Netsim servers from config file
#
# Arguments:
#       none
# Return Values:
#       none
get_netsim_servers()
{
    netsimServersInConfig=`$EGREP "^SERVERS=" $CONFIGFILE | $AWK -F\" '{print $2}'`

    if [ -n "$NETSIMSERVER" ]
    then
    	NETSIMSERVERLIST=$NETSIMSERVER
	else
        NETSIMSERVERLIST=$netsimServersInConfig
    fi

    if [ -z "$NETSIMSERVERLIST" ]; 
    then
		echo "ERROR: No Netsim Servers specified Exiting"
		exit 7
	fi
 
    NETSIMSERVERCOUNT=0

    for host in `echo $NETSIMSERVERLIST`
    do
  	    NETSIMSERVERCOUNT=`expr $NETSIMSERVERCOUNT + 1`
		host=`echo "$host"|tr -d " "`
		if [[ ! "$netsimServersInConfig" =~ "$host" ]] 
		then
			echo ""
			echo "ERROR: ********************************************"
			echo "ERROR: Netsimserver $host not in config $CONFIGFILE"
			echo -n "ERROR: SERVERS in config are $netsimServersInConfig"

			if not_sure_to_continue 
			then
				echo "DEBUG: returned $?"
				exit 7
			fi
		fi

		if ! egrep "^${host}_list" $CONFIGFILE &>/dev/null;
		then
			echo "ERROR: no sim list for $host in config $CONFIGFILE typo?? look:"
			echo "**************************************"
			egrep "${host}" $CONFIGFILE;
			egrep "_list=" $CONFIGFILE;
			echo "**************************************"

			if not_sure_to_continue
			then
				exit 7
			fi
		fi
		parse_simlist_for_host $host
    done
	message $DEBUG "$ME: netsim server config looking ok\n"

	DEPLOYMENT=`echo $DEPLOYMENT | $TR "[:upper:]" "[:lower:]"` 
	if [ "$DEPLOYMENT" = "cominf" ]
	then
    	TEMPLIST="$NETSIMSERVERLIST"
   		NETSIMSERVERLIST=""
    	for host in `echo $TEMPLIST`
    	do
	       	 NETSIMSERVERLIST="$NETSIMSERVERLIST ${host}-inst"
    	done
	fi
}

getNetsimServerList(){
	echo $netsimServersInConfig
}

getNetsimServerListFiltered(){
	echo ${NETSIMSERVERLIST}
}

load_config(){
	message $DEBUG "function load_config\n"
        SECURITY_LEVEL=`$EGREP "^SECURITY_LEVEL=" $CONFIGFILE | $AWK -F= '{print $2}'|awk '{print $1}'`
	message $DEBUG  "SECURITY_LEVEL=$SECURITY_LEVEL\n"
        CREATE_PM=`$EGREP "^CREATE_PM=" $CONFIGFILE | $AWK -F= '{print $2}'|awk '{print $1}'`
	message $DEBUG  "CREATE_PM=$CREATE_PM\n"
}

getSimulationListForHost(){
	local host=$1
	$EGREP "^${host}_list=" $CONFIGFILE | $AWK -F\" '{print $2}'
}

getSimulationListForHostFiltered(){
	local host=$1
	echo -n ${netsimServerSimulationsFiltered["$host"]}
}

getSimulationListFiltered(){
	local host
	for host in `getNetsimServerList`
	do
		echo -n ${netsimServerSimulationsFiltered["$host"]}
	done
}

getOssServer(){
	echo "$SERVER"
}

getSecurityLevel(){
        echo $SECURITY_LEVEL
}

createPmEnabled(){
        echo "$CREATE_PM"|egrep -i "yes|1"
		return $?
}

test_config_parser(){
# just for testing the variables loaded from config file
# helge
	local host;
	echo "DEBUG: unfiltered lists:"
	for host in `getNetsimServerList`
	do
		echo -n "DEBUG: simulationListForHost $host ="
		getSimulationListForHost "$host"|tr -d "\n"
		echo ""
	done

	echo "DEBUG: filtered lists:"

	for host in `getNetsimServerList`
	do
		echo -n "DEBUG: simulationListForHostFiltered $host ="
		getSimulationListForHostFiltered $host|tr -d "\n"
		echo ""
	done
}

### Function: set_parallel_variables ###
#
#   Sets parallel variables and arrays per parallel process for use in parallel_status and parallel_wait functions
#
# Arguments:
#       none
# Return Values:
#       none

set_parallel_variables()
{
    last_pid="$!"
    parallel_pids="$parallel_pids $last_pid"
    parallel_strings[$last_pid]="$PARALLEL_STATUS_STRING"
    parallel_logs[$last_pid]="$LOG_FILE"
}

### Function: reset_parallel_variables ###
#
#   Resets parallel variables and arrays for use in parallel_status and parallel_wait functions
#
# Arguments:
#       none
# Return Values:
#       none

reset_parallel_variables ()
{
    processes_remaining_last=999
    parallel_pids=""
    parallel_strings=()
    parallel_logs=()
    LOG_FILE=""
    PARALLEL_STATUS_STRING=""
    SHOW_STATUS_UPDATES="YES"
    SHOW_OUTPUT_BORDERS="YES"
    PARALLEL_STATUS_HEADER=""
}

### Function: parallel_status ###
#
#   Used in proceses to check status of parallel proceses
#
# Arguments:
#       none
# Return Values:
#       none
parallel_status() {
    set $parallel_pids

    for pid in "$@"; do
        shift
        if kill -0 "$pid" 2>/dev/null; then
            set -- "$@" "$pid"
        fi
    done
    processes_remaining_now="$#"

    if [[ $processes_remaining_last -ne $processes_remaining_now ]]
    then
        output=$(
        set $parallel_pids

        echo "    |====================================================================|"
        echo "    | Parallel Status: $PARALLEL_STATUS_HEADER"
        echo "    |--------------------------------------------------------------------|"
 
        for pid in "$@"; do
            shift
            if kill -0 "$pid" 2>/dev/null; then
                echo "    | INFO:  ${parallel_strings[$pid]}: Running (Temp logfile ${parallel_logs[$pid]} )"
                set -- "$@" "$pid"
            else
                wait "$pid"
                EXIT_CODE="$?"
                if [[ $EXIT_CODE -eq 0 ]]
                then
                    echo "    | INFO:  ${parallel_strings[$pid]}: Completed"
                else
                    echo "    | ERROR: ${parallel_strings[$pid]}: Completed with exit code $EXIT_CODE, please check ${parallel_logs[$pid]}"
                fi
            fi
        done
        echo "    |--------------------------------------------------------------------|"
        echo "    | Parallel Summary: Processes Remaining: $processes_remaining_now "
        echo "    |====================================================================|"
        )
        echo "$output"
    fi
    processes_remaining_last="$#"
}

### Function: parallel_finish ###
#
#   Used in functions to finish off a paralle process, output its logfile, retrieve its return code etc
#
# Arguments:
#       none
# Return Values:
#       none

parallel_finish()
{
    PARALLEL_EXIT_CODE="$?"

    output=$(
    if [[ "$SHOW_OUTPUT_BORDERS" != "NO" ]]
    then
        echo "|==============================================================================|"
        echo "| Start Of Output For: $PARALLEL_STATUS_STRING"
        echo "|------------------------------------------------------------------------------|"
    fi

    if [[ "$SHOW_OUTPUT_BORDERS" != "NO" ]]
    then
        echo "|------------------------------------------------------------------------------|"
        echo "| End Of Output For: $PARALLEL_STATUS_STRING"
        echo "|==============================================================================|"
    fi
    )
    echo "$output"

	if [[ "$PARALLEL_EXIT_CODE" -eq 0 ]];
	then  
	    rm $LOG_FILE
	fi

    exit "$PARALLEL_EXIT_CODE"
}

### Function: parallel_wait ###
#
#   Used in functions to wait for parallel processes to finish
#
# Arguments:
#       none
# Return Values:
#       none

parallel_wait() {
    if [[ "$SHOW_STATUS_UPDATES" != "NO" ]]
    then
        output=$(
        echo "|==============================================================================================|"
        echo "| Starting Parallel Processes: $PARALLEL_STATUS_HEADER"
        echo "|----------------------------------------------------------------------------------------------|"
        )
        echo "$output"
        parallel_status
    fi
    set $parallel_pids
    while :; do
        #echo "Processes remaining: $#"
        for pid in "$@"; do
            #       echo "Checking on $pid"
            shift
            if kill -0 "$pid" 2>/dev/null; then
                #         echo "$pid is still running"
                set -- "$@" "$pid"
            else
                # A process just finished, print out the parallel status
                if [[ "$SHOW_STATUS_UPDATES" != "NO" ]]
                then
                    parallel_status
                fi
            fi
        done
        if [[ "$#" == 0 ]]
        then
            break
        fi
        sleep 1
    done

    if [[ "$SHOW_STATUS_UPDATES" != "NO" ]]
    then
        output=$(
        echo "|----------------------------------------------------------------------------------------------|"
        echo "| Completed Parallel Processes: $PARALLEL_STATUS_HEADER"
        echo "|==============================================================================================|"
        )
        echo "$output"
    fi

    # Exit script if one of the processes had a non 0 return code

    set $parallel_pids
    while :; do
        for pid in "$@"; do
            #       echo "Checking on $pid"
            shift
            if kill -0 "$pid" 2>/dev/null; then
                #         echo "$pid is still running"
                set -- "$@" "$pid"
            else
                # A process just finished, print out the parallel status
                wait "$pid"
                EXIT_CODE="$?"
                if [[ $EXIT_CODE -ne 0 ]]
                then
                    echo "INFO: At least one of the parallel processes ended with non 0 exit code, exiting script"
                    exit_routine $EXIT_CODE
                fi
            fi
        done
        if [[ "$#" == 0 ]]
        then
            break
        fi
        sleep 1
    done
    reset_parallel_variables
}

with_each_netsim_server_simulation(){
	#run incoming scripts on each netsmin(filtered) on each node(filtered)
	echo ""
}

with_each_netsim_server(){
# sequential excecution
# echo "DEBUG: entering function with_each_netsim_server()"

    local runFunction=$1;
	local returnValue=0;
	
    for netSimServer in `echo $NETSIMSERVERLIST`
    do
        $runFunction "$netSimServer"
		returnValue=`expr $returnValue + $?`
    done
    return $returnValue;	# we give the highest in case of an error
}

with_one_netsim_server(){
	# just for testing
    echo "DEBUG: entering function with_one_netsimserver() $@"
    local host=$1;
}

test_with_each(){
	# just for testing
    NETSIMSERVERLIST="netsimlin1 netsimlin2 netsimlin3 netsimlin4"
    with_each_netsim_server with_one_netsim_server
}

### Function: mount_scripts_directory ###
#
#   check server is alive, can be rsh'ed to and mounts scripts directory
#
# Arguments:
#       none
# Return Values:
#       none

mount_scripts_directory()
{
	isScriptsDirectoryMounted=true
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        mount_scripts_directory_pdsh
    else
		if ! with_each_netsim_server "support/mountScriptsDirectoryOnHost.sh"
		then
			echo "ERROR: failed to mount "
			exit 1	
		fi
    fi
}


mount_scripts_directory_pdsh(){

	if ! pdsh -R exec -S -w "$NETSIMSERVERLIST" support/mountScriptsDirectoryOnHost.sh %h
	then 
		echo "ERROR: could not mount one of the netsims!"
		exit_routine 4;
	else
		echo "INFO: mounted all netsimservers."
	fi
}

netsim_dance(){
		echo "INFO: dancing with netsims user:netsim wait for pdsh> prompt exit with CTRL+D"
		pdsh -l netsim -w "$NETSIMSERVERLIST"
}

netsim_dance_root(){
		echo "INFO: dancing with netsims user:root wait for pdsh> prompt exit with CTRL+D"
		pdsh -l root -w "$NETSIMSERVERLIST"
}
	
setup_netsim_ftp(){

	if ! pdsh -R exec -S -w "$NETSIMSERVERLIST" setFtpDownloadLocationOnNetsim.sh %h
	then 
		echo "ERROR: could while setting up ftp download location for one of the hosts!"
		exit_routine 4;
	else
		echo "INFO: ftp download locations set."
	fi
}

umount_scripts_directory_on_host()
{
#    echo "DEBUG: entering function umount_scripts_directory_on_host()"
    local netsimserver=$1
    $RSH $netsimserver $UMOUNT -f $MOUNTPOINT &> /dev/null
	return $?
}

### Function: check_os_details ###
#
#   Check if OS is SuSe and when it was installed  
#
# Arguments:
#       none
# Return Values:
#       none

check_os_details()
{
	if ! pdsh -R exec -S -w "$NETSIMSERVERLIST" checkOsDetails.sh %h
	then
		echo "ERROR: while checking os details "
		exit 1	
	fi

	if ! pdsh -R exec -S -w "$NETSIMSERVERLIST" checkHostname.sh %h
	then
		echo "ERROR: while checking hostname"
		exit 1	
	fi
}

check_master()
{
	echo "checkMasterServer.sh $SERVER checking if its ready for import"
	checkMasterServer.sh $SERVER 
}

check_master_ips()
{
	local OSS=`getOssServer`
	local netsimServers=`getNetsimServerListFiltered`
	echo "checkIpsOnMasterAgainstNetsims.sh `getOssServer` `getNetsimServerListFiltered`"
	checkIpsOnMasterAgainstNetsims.sh "`getOssServer`" "`getNetsimServerListFiltered`"
}

check_onrm_cs(){
	
	checkImportOnMasterAgainstNetsims2.sh $SERVER "$NETSIMSERVERLIST"
}

check_seg_cs(){
	
	checkImportOnMasterAgainstNetsims.sh $SERVER "$NETSIMSERVERLIST"
}

check_omsas(){
	
	caasServers=`getCaasServersFromMaster.sh $SERVER`
	echo "caasServers on $SERVER :"
	echo -e "$caasServers"
	echo -n "what caas/omsas server would you like to check against netsims?:"
	read caasServer
	
	checkImportOnMasterAgainstNetsims.sh "$caasServer" "$NETSIMSERVERLIST"
}

check_netsim_shell()
{
	message $DEBUG "DEBUG: entering check_netsim_shell()\n"
	# if netsim_shell does not work parallel processing can go heywire ( script dump to output )

    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
		message $DEBUG "DEBUG: check_netsim_shell parallel\n"

		if pdsh -R exec -S -w "$NETSIMSERVERLIST" checkNetsimShell.sh %h
		then
			return 0
		else
			exit_routine 1
		fi
     
    else
		if ! with_each_netsim_server "support/checkNetsimShell.sh"
		then
			echo "ERROR: failed to use netsim_shell on one of the hosts "
			exit 1	
		fi
	fi

}


### Function: rollout_preroll ###
#
#   Perform Pre Rollount
#
# Arguments:
#       none
# Return Values:
#       none
delete_sims()
{
    # Get the list of sims on each netsim into a list
	query_sims_to_delete

    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Deleting Simulations"
            PARALLEL_STATUS_STRING="Deleting Simulations on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            delete_sims_on_host $host
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
        parallel_wait
        return
    else
	    for host in `echo $NETSIMSERVERLIST`
    	do
            delete_sims_on_host $host
    	done
	fi
}

query_sims_to_delete()
{
    SIMCOUNT=0
    for host in `echo $NETSIMSERVERLIST`
    do
    	local dateDir=`$RSH $host ls -1tr ${MOUNTPOINT}/savedconfigs/$host/ | tail -n 1`
        BACKUPDIR="$MOUNTPOINT/savedconfigs/$host/$dateDir/existingsims"

        echo "INFO: Checking what simulations are on $host"

        eval ${host}_sims_list=\"`$RSH -l netsim $host "cd /netsim/netsimdir/;ls */* | grep -i "/logfiles" | grep -v default | awk -F/ '{print \\$1}';ls -l *.zip 2> /dev/null | awk '{print \\$9}'"`\"

        SIMLIST=`eval echo \\$${host}_sims_list`

        if [ -n "$SIMLIST" ]
        then
            echo "**************************************"
            echo "SIMS on $host are as follows"
            echo "**************************************"
            for sim in `echo $SIMLIST`
            do
                echo "$sim"
                SIMCOUNT=`expr $SIMCOUNT + 1`
            done
            echo "**************************************"
        fi
    done

    # Now loop through each sim and ask questions if necesary to build up list of sims per netsim to delete

    if [[ ! $SIMCOUNT -gt 0 ]]
    then
    	echo "there no sims installed"
    	return 0
    fi
    
    echo "QUERY: Would you like to KEEP any of the $SIMCOUNT SIMS from all of the netsims above, upper case Y states yes to keep all, y means yes you want to keep some, n means no to keep any (y/Y/n)"
    echo -e "INPUT: \c"

    if [[ $INTERACTION == "y" ]]
    then
        read ANS_ALL
    else
        echo "INFO: Interaction Set to NO, Default answer here is (n)"
        ANS="n"
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        NETSIM_DELETE_LIST=${host}_sim_delete_list
        SIMLIST=`eval echo \\$${host}_sims_list`

        if [ -n "$SIMLIST" ]
        then

            if [[ "$ANS_ALL" == "Y" ]]
            then
                ANS="Y"
            elif [[ "$ANS_ALL" == "n" ]]
            then
                ANS="n"
            else
                echo "--------------------------------------"
                echo "SIMS on $host are as follows"
                echo "--------------------------------------"
                for sim in `echo $SIMLIST`
                do
                    echo "$sim"
                done
                echo "--------------------------------------"
                echo "QUERY: Would you like to KEEP any of the SIMS listed above for $host, upper case Y states Y for all, y means yes you want to keep some, n means no to keep any (y/Y/n)"
                echo -e "INPUT: \c"
                read ANS
            fi

            if [ "$ANS" = "n" ]
            then
                eval $NETSIM_DELETE_LIST=\"$SIMLIST\"
            else
                if [[ $ANS != "Y" ]]
                then
                    for sim in `echo $SIMLIST`
                    do
                        echo "QUERY: Do you wish to keep $sim on $host"
                        echo -e "INPUT: \c"
                        read ANS

                        if [ "$ANS" = "n" ]
                        then
                            eval $NETSIM_DELETE_LIST=\"\$$NETSIM_DELETE_LIST $sim\"
                        fi
                    done
                fi
            fi
        fi
    done
}

delete_sims_on_host()
{
	local host=$1
    # Delete the users
    if [[ "`eval echo \\$${host}_sim_delete_list`" != "" ]]
    then
        # Restart the netsim gui
        $RSH -n -l netsim $host "/netsim/inst/restart_gui"

        # Delete the users
        for sim in `eval echo \\$${host}_sim_delete_list`
        do
            if [[ ! -n "`echo $sim | $EGREP .zip$`" ]]
            then
                echo "INFO: Deleting users for $sim on $host"
                $RSH -n $host "/mnt/support/delete_users.sh $host $sim"
            fi
        done

        # Delete the sims
        list_formatted=`eval echo \\$${host}_sim_delete_list | sed 's/ /|/g'`
        $RSH -n -l netsim $host "echo \".delsim $list_formatted force\" | $NETSIMSHELL"
    else
        echo "Nothing to delete for $host"
    fi
}

### Function: make_ports ###
#
#   Make NETsim Ports
#
# Arguments:
#       none
# Return Values:
#       none
make_ports()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Setting NETSimPort on $host"
        $RSH -l netsim $host "/mnt/support/make_ports.sh | $NETSIMSHELL" | $GREP -v "DISPLAY"
        #echo "INFO: NETSim Port created on $host"
        PORT_CHECK=`$RSH -l netsim $host "/mnt/support/check_port.sh $NETSIMSHELL"`
        if [[ $PORT_CHECK == "ERROR" ]]
        then
            echo "ERROR: NetSimPort not created on $host"
            exit_routine 1
        else
            echo "INFO: Port creation on $host seems to be sucessfull"
        fi
    done
}

### Function: get_sims ###
#
#   Get Simulations from FTP area uncompress and open
#
# Arguments:
#       none
# Return Values:
#       none
get_sims()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
	    for host in `echo $NETSIMSERVERLIST`
    	do
	        ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Getting Simulations"
            PARALLEL_STATUS_STRING="Getting Simulations on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
                (
                    get_sims_for_host $host
                ) > $LOG_FILE 2>&1;parallel_finish
             ) & set_parallel_variables
        done
        parallel_wait
        return
    else
	    for host in `echo $NETSIMSERVERLIST`
    	do
	        get_sims_for_host $host
		done
	fi
}	

get_sims_for_host()
{
	local host=$1

	message $DEBUG "DEBUG: entering get_sims_for_host()\n"
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
			message $DEBUG "DEBUG: fetching sims for host $host\n"
            RNCSIM=""
            RNCSIM=`echo $SIMNAME | $EGREP "^RNC"`
            LTESIM=""
            LTESIM=`echo $SIMNAME | $EGREP "^LTE"`

            GRANSIM=""
            GRANSIM=`echo $SIMNAME | $EGREP "^GRAN|^SIU"`
			
			#default
            SIMSTR=SIMDIR
 
            if [ -n "$RNCSIM" ]
            then
                SIMSTR=WRAN_SIMDIR
            fi

            if [ -n "$LTESIM" ]
            then
                SIMSTR=LTE_SIMDIR
            fi

            if [ -n "$GRANSIM" ]
            then
                SIMSTR=GRAN_SIMDIR
            fi

            SIMDIRTEST=`$EGREP "^$SIMSTR=" $CONFIGFILE | $AWK -F= '{print $2}'`
            if [ -z "$SIMDIRTEST" ]
            then
                echo "ERROR: SIMDIR $SIMSTR not defined in $CONFIGFILE. Exiting."
                exit 10
            else
                SIMDIR=$SIMDIRTEST
            fi

            SIMSERVERTEST=`$EGREP "^SIMSERVER=" $CONFIGFILE | $AWK -F= '{print $2}'`
            if [ -z "$SIMSERVERTEST" ]
            then
                echo "ERROR: ftp SIMSERVER not defined in $CONFIGFILE. Exiting."
                exit 10
            else
                SIMSERVER=$SIMSERVERTEST
            fi

            MIMTEST=`$EGREP "^${SIMNAME}_mimtype=" $CONFIGFILE | $AWK -F= '{print $2}'`
            if [ -z "$MIMTEST" ]
            then
                LTETEST=`echo $SIMNAME | grep LTE`
                if [ -n "$LTETEST" ]
                then
                    echo "INFO: SIM is LTE so setting to \".\""
                    MIMTYPE="."
                else
	                echo "INFO: MIMTYPE $MIMTEST is not set N or N_* so setting to \"N\""
	                MIMTEST=N
                    MIMTYPE=$MIMTEST
                fi
            else
            	# if any mimversion is set keep it
                 MIMTYPE=$MIMTEST
            fi

            echo "INFO: Getting Simulation $SIMNAME  - $MIMTYPE for $host from $SIMDIR/$MIMTYPE on $SIMSERVER"
            echo "INFO: Command /mnt/support/ftp_sims.sh $host $SIMNAME $MIMTYPE $SIMSERVER $SIMDIR"
            $RSH -l netsim $host "/mnt/support/ftp_sims.sh $host $SIMNAME $MIMTYPE $SIMSERVER $SIMDIR" | $GREP -vi Display
            TEST=`$RSH -l netsim $host "ls /netsim/netsimdir | $EGREP $SIMNAME.zip" `
            if [ -z "$TEST" ]
            then
                echo "ERROR: SIM $SIMNAME not downloaded to $host. Exiting. Please investigate"
                exit 10
            else
                echo "INFO: Uncompress and open $SIMNAME on $host"
                $RSH -l netsim $host "/mnt/support/uncompress_and_open.sh $host $SIMNAME | $NETSIMSHELL" | $GREP -vi Display
                echo "INFO: Uncompress and open $SIMNAME on $host complete"
            fi
        done
}


### Function: set_ips ###
#
#   Configure IP addresses on SIMS
#
# Arguments:
#       none
# Return Values:
#       none
set_ips()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
   	then
	    for host in `echo $NETSIMSERVERLIST`
    	do
            ###################################
	        # Parallel variable initialization
    	    ###################################
        	LOG_FILE=/tmp/${host}.$BASHPID.log
        	PARALLEL_STATUS_HEADER="Setting up IPs"
        	PARALLEL_STATUS_STRING="Setting up IPs on $host"
        	# SHOW_STATUS_UPDATES="NO"
        	# SHOW_OUTPUT_BORDERS="NO"
        	###################################
        	(
        		(
				set_ips_on_host $host
    		    ) > $LOG_FILE 2>&1;parallel_finish
	        ) & set_parallel_variables
    	done
	    parallel_wait
		return
   	else
	    for host in `echo $NETSIMSERVERLIST`
    	do
			set_ips_on_host $host
    	done
   	fi
}

generateNodeFiles()
{
    for host in `echo $NETSIMSERVERLIST`
   	do
		generateNodeFilesOnHost $host
   	done
	
}

generateNodeFilesOnHost()
{
	local host=$1
	local SIMNAME=""
	# this is required for gran nodes to create the .info files
	# only used for SIU nodes on a sepereate box
	message $DEBUG "DEBUG: entering generateNodeFilesOnHost() $1\n"
	for SIMNAME in `getSimulationListForHostFiltered $host`
	do
        message $DEBUG "DEBUG: generating nodes.info files for sim $SIMNAME\n"
 	    $RSH -l netsim $host "/mnt/support/gran/list_picos.sh $host $SIMNAME" | $GREP -vi Display
        $RSH -l netsim $host "/mnt/support/gran/list_siu.sh $host $SIMNAME" | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_lans.sh $host $SIMNAME" | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_mlppp.sh $host $SIMNAME" | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_bsc.sh $host $SIMNAME" | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_msc.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_mscs_apg.sh $host $SIMNAME $SIM_KEY" | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_mscs_is.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_mscs_cp.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_mscs_spx.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_mscs_tsc.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_ts.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_fw.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_sdn.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_spnova.sh $host $SIMNAME " | $GREP -vi Display
		$RSH -l netsim $host "/mnt/support/gran/list_ml.sh $host $SIMNAME " | $GREP -vi Display
	done
}

set_ips_gran_siu()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
   	then
	    for host in `echo $NETSIMSERVERLIST`
    	do
            ###################################
	        # Parallel variable initialization
    	    ###################################
        	LOG_FILE=/tmp/${host}.$BASHPID.log
        	PARALLEL_STATUS_HEADER="Setting up IPs"
        	PARALLEL_STATUS_STRING="Setting up IPs on $host"
        	# SHOW_STATUS_UPDATES="NO"
        	# SHOW_OUTPUT_BORDERS="NO"
        	###################################
        	(
        		(
				set_ips_gran_siu_on_host $host
    		    ) > $LOG_FILE 2>&1;parallel_finish
	        ) & set_parallel_variables
    	done
	    parallel_wait
		return
   	else
	    for host in `echo $NETSIMSERVERLIST`
    	do
			set_ips_gran_siu_on_host $host
    	done
   	fi
}

### Function: set_ips ###
#
#   Configure IP addresses on SIMS
#
# Arguments:
#       none
# Return Values:
#       none

set_ips_gran_siu_on_host()
{
	# only required if SIU nodes are on a seperate box as the LTE/WRAN nodes hopefully obsolete in 12.4
	local host=$1
	local SIMLIST=`getSimulationListForHostFiltered "$host"`

	adaptSetIpsAutoContinuesArgsForHost $host
	
    setIpsToAllNodesOnNetsimServer.sh -n $host -g "$SIMLIST" -v 16 -j 250 -p STN $ARGS 
}

adaptSetIpsAutoContinuesArgsForHost()
{
	local host=$1
	message $DEBUG "DEBUG: entering adaptSetIpsAutoContinuesArgs $host\n"			
	local networkInterface=`$EGREP "^${host}_interface=" $CONFIGFILE | $AWK -F= '{print $2}'`
	ARGS=""
	if [[ -n $networkInterface ]]; then  ARGS="-i $networkInterface ";fi
	# we can only use either offset -o or startIp -x
	if [[ -n "$OFFSET" ]]; # -o  
	then 
		message $DEBUG "DEBUG: -o sim $OFFSET should start after ip "

		local fullSimList=(`getSimulationListForHost $host`)
		local myIndex=`expr $OFFSET - 1`
		local tmpSim=${fullSimList[$myIndex]}
		
		# getting last ip of simulation $myIndex ${tmpSim}
		local lastIp=`getIpsFromSimulation.sh $host ${tmpSim}|awk '{print $2}'|tail -1`
		message $DEBUG " $lastIp\n"
		ARGS+="-x $lastIp -y"
	elif [[ -n $STARTIP ]]
	then
		ARGS+="-x $STARTIP"
	fi
		
	message $DEBUG "DEBUG: setIpsToAllNodesOnNetsimServer.sh additional ARGS= $ARGS\n"
}	

set_ips_on_host()
{
	local host=$1

	#helge SIMLIST used twice in this function
	local SIMLIST=`getSimulationListForHostFiltered "$host"`
	message $DEBUG "DEBUG: entering set_ips_on_host() $host\n"			

	if [[ "$SIMLIST" == "" ]]
	then
		message $DEBUG "DEBUG: nothing in SIMLIST nothing to do for $host\n"
		return
	fi
	
	adaptSetIpsAutoContinuesArgsForHost $host

	TOTALIPS=`$RSH $host "$IFCONFIG -a | $GREP inet | $WC -l"`
	TOTALVIPS=`expr $TOTALIPS - 2`

	echo "INFO: Total IP address available on $host is $TOTALIPS"
	IPREQD=0
	for SIMNAME in `echo $SIMLIST`
	do
		CELLTEST=`$EGREP "^${host}_type=" $CONFIGFILE | $AWK -F= '{print $2}'`
		if [ -z "$CELLTEST" ]
        then
            echo "INFO: CELLTYPE is not set, so setting to \"C\""
            CELLTYPE="C"
        else
            CELLTYPE=$CELLTEST
        fi
        case "$CELLTYPE" in
            C) IPREQD=`expr $IPREQD + 250`
                ;;
            F) IPREQD=`expr $IPREQD + 1000`
                ;;
            auto) 
			    setIpsToAllNodesOnNetsimServer.sh -n $host -g "$SIMLIST" -v 16 -j 250 $ARGS
                return			
                ;;
            continues) 
			    setIpsToAllNodesOnNetsimServer.sh -n $host -g "$SIMLIST" -v 16 $ARGS
                return			
                ;;
            \?) echo -e "ERROR: SIM $SIMNAME on $host is not supported Cell Type (C, F or LTE)"
                exit 11
                ;;
        esac
    done

    echo "INFO: Total IPS needed to do rollout is $IPREQD before OFFSET is applied"
     #Now apply ip OFFSET to the check that was done above
    TMP_OFFSET=$OFFSET
    while [[ $TMP_OFFSET -gt 0 ]]
    do
        IPREQD=`expr $IPREQD + 250`
        TMP_OFFSET=`expr $TMP_OFFSET - 1`
    done
    echo "INFO: Total IPS needed to do rollout is $IPREQD after OFFSET is applied"

    if [ $IPREQD -le $TOTALVIPS ]
    then
        echo "INFO: Sufficient VIPS on $host for SIMS"
    else
        echo "ERROR: Insufficient VIPS on $host for SIMS"
        exit 11
    fi

    IPSUBS=`$RSH $host "/mnt/support/list_ip_subs.sh $host" | $GREP -vi Display`
    IPSUBSARRAY=()
    COUNT=1
    #If the OFFSET for ips is not set, default to 0
    if [[ -z $OFFSET ]]
    then
        OFFSET=0
    fi

    for ipsub in `echo $IPSUBS`
    do
        IPSUBSARRAY[$COUNT]=$ipsub
        COUNT=`expr $COUNT + 1`
        echo "INFO: Available Subnet is $ipsub"
    done

	for SIMNAME in `echo $SIMLIST`
	do
		#POSITION=`echo $line | awk -F: '{print $20}'`
		IPCOUNT=1
		echo "INFO: Getting number of RNC in SIM $SIMNAME on $host"
		NOOFRNC=`$RSH -l netsim $host "/mnt/support/get_num_rnc.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: Getting number of RBS in SIM $SIMNAME on $host"
		NOOFRBS=`$RSH -l netsim $host "/mnt/support/get_num_rbs.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: Getting number of RXI in SIM $SIMNAME on $host"
		NOOFRXI=`$RSH -l netsim $host "/mnt/support/get_num_rxi.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: Getting number of LTE in SIM $SIMNAME on $host"
		NOOFLTE=`$RSH -l netsim $host "/mnt/support/get_num_lte.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: Getting number of TDRNC in SIM $SIMNAME on $host"
		NOOFTDRNC=`$RSH -l netsim $host "/mnt/support/get_num_tdrnc.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: Getting number of TDRBS in SIM $SIMNAME on $host"
		NOOFTDRBS=`$RSH -l netsim $host "/mnt/support/get_num_tdrbs.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: Getting number of TBRXI in SIM $SIMNAME on $host"
		NOOFTDRXI=`$RSH -l netsim $host "/mnt/support/get_num_tdrxi.sh $host $SIMNAME" | $GREP -vi Display`
		echo "INFO: $NOOFRNC RNCs in SIM $SIMNAME on $host"
		echo "INFO: $NOOFRBS RBSs in SIM $SIMNAME on $host"
		echo "INFO: $NOOFRXI RXIs in SIM $SIMNAME on $host"
		echo "INFO: $NOOFTDRNC TDRNCs in SIM $SIMNAME on $host"
		echo "INFO: $NOOFTDRBS TDRBSs in SIM $SIMNAME on $host"
		echo "INFO: $NOOFTDRXI TDRXIs in SIM $SIMNAME on $host"
		echo "INFO: $NOOFLTE LTEs in SIM $SIMNAME on $host"
		TOTALNODES=`expr $NOOFRNC + $NOOFRBS + $NOOFRXI + $NOOFLTE + $NOOFTDRNC + $NOOFTDRBS + $NOOFTDRXI`
		if [ $TOTALNODES -eq 0 ]
		then
			echo "ERROR: There are no nodes in SIM $SIMNAME on $host. Exiting"
			exit 12
		fi
		echo "INFO: Setting up IP addresses on SIM $SIMNAME on $host"
		POSITION=`$RSH -l netsim $host "/mnt/support/get_position.sh $host $SIMNAME" | $GREP -vi Display`

		#Hack for sims already on the box and not part of rollout. ie the netsim box serves two OSS's
		#Only applied with NODEFILTER and OFFSET as arguments to run.sh
		if [[ $OFFSET != "" ]]
		then
			if [[ $NODEFILTER != "" ]]
			then
				POSITION=`expr $OFFSET + 1`
				echo "INFO: HACK for POSITION applied"
				echo "INFO: Using SUBNET ${IPSUBSARRAY[$POSITION]}"
			fi
		fi
		$RSH -l netsim $host "/mnt/support/setup_ip.sh $host $SIMNAME $NOOFRBS $NOOFRNC $NOOFRXI $NOOFLTE $NOOFTDRNC $NOOFTDRBS $NOOFTDRXI ${IPSUBSARRAY[$POSITION]} $formatedDate" | $GREP -vi Display
	done
#----------------------------
}

### Function: set_security ###
#
#   Configure security on
#
# Arguments:
#       none
# Return Values:
#       none

set_security_on_host()
{
	local host=$1
   	echo "INFO: Copying pem files to $host"
    $RSH -l netsim $host "/mnt/support/copyfiles.sh $host $SECURITY"
    #LSTEST=`$RSH -l netsim $host "ls /netsim/netsim_security 2>&1 | $GREP key.pem"`
	KEYTEST=`$RSH $host "/mnt/support/check_file.sh $host blank key $SECURITY"`

   	echo "$KEYTEST"
    echo $KEYTEST | $GREP "OK" >> /dev/null
    if [ $? -ne 0 ]
    then
  	    echo "ERROR: NETSim pem files not copied"
  	    exit 6
 	fi
    
    for SIMNAME in `getSimulationListForHostFiltered "$host"`
    do
        echo "INFO: Setting Security on for SIM $SIMNAME on $host"
        $RSH -l netsim $host "/mnt/support/set_security_v2.sh $host $SIMNAME $SECURITY | $NETSIMSHELL" | $GREP -vi Display
        echo "INFO: Security on for SIM $SIMNAME on $host"
    done
}

check_pem_files()
{
	local SECURITY=$1
	local ME="check_pm_sl2_files()"
	message $DEBUG "entering $ME\nDEBUG:Check .pem files are not of size 0 bytes\n"
	message $DEBUG "Check .pem files are not of size 0 bytes\n"

    local KEY_FILESIZE=$(stat -c%s "subscripts/security/${SECURITY}/key.pem")
    local CERT_FILESIZE=$(stat -c%s "subscripts/security/${SECURITY}/certs.pem")
    local CACERT_FILESIZE=$(stat -c%s "subscripts/security/${SECURITY}/cacerts.pem")
    if [[ $KEY_FILESIZE == "0" ]]
    then
        echo "ERROR: subscripts/security/${SECURITY}/key.pem is of size 0 bytes, exiting"
		exit_routine 1
    elif [[ $CERT_FILESIZE == "0" ]]
    then
        echo "ERROR: subscripts/security/${SECURITY}/certs.pem is of size 0 bytes, exiting"
		exit_routine 1
    elif [[ $CACERT_FILESIZE == "0" ]]
    then
        echo "ERROR: subscripts/security/${SECURITY}/cacerts.pem is of size 0 bytes, exiting"
		exit_routine 1
    fi
}

set_security()
{
	checkSecurityServer $SECURITY
	check_pem_files $SECURITY

    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
	    for host in `echo $NETSIMSERVERLIST`
    	do
			#   Parallelized code below
			###################################
			# Parallel variable initialization
			###################################
			LOG_FILE=/tmp/${host}.$BASHPID.log
			PARALLEL_STATUS_HEADER="Set Security"
			PARALLEL_STATUS_STRING="Set security on $host"
			# SHOW_STATUS_UPDATES="NO"
			# SHOW_OUTPUT_BORDERS="NO"
			###################################
			(
				(
					set_security_on_host $host
				) > $LOG_FILE 2>&1;parallel_finish
			) & set_parallel_variables
		done
		parallel_wait
    else
	    for host in `echo $NETSIMSERVERLIST`
    	do
			set_security_on_host $host
    	done
	fi    
}

checkSecurityServer()
{
	local SECURITY=$1
    message $DEBUG "DEBUG: entering checkSecurityServer() $1"
    echo $SECURITY | $EGREP "^atrc|^akita|^aty" >> /dev/null
    TEST=`echo $?`
    if [ $TEST -ne 0 ]
    then
        echo "ERROR: upload_pems_sl3 You must specify a supported security -a trcusXXX, -a atylXXX"
        exit 1
    else
        message $DEBUG "DEBUG: Security is $SECURITY"
    fi
}

upload_pems_sl3 ()
{
	checkSecurityServer $SECURITY
	check_pem_files $SECURITY

    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Copying pem files to $host"
        $RSH -l netsim $host "/mnt/support/upload_pems_sl3.sh $host $SECURITY"
    done
}

upload_pems_sl2 ()
{
	checkSecurityServer $SECURITY
	check_pem_files $SECURITY
	local host
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Copying pem files to $host"
        $RSH -l netsim $host "/mnt/support/upload_pems_sl2.sh $host $SECURITY"
    done
}

enable_corba_security()
{
    stop_all
	local host
	local SIMNAME
    for host in `echo $NETSIMSERVERLIST`
    do
        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="enable Security"
        PARALLEL_STATUS_STRING="enable security on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (

        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Enabling Security for SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/enable_corba_security.sh $host $SIMNAME $SECURITY | $NETSIMSHELL" | $GREP -vi Display
            echo "INFO: Security on for SIM $SIMNAME on $host"
        done
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
    start_all
}

set_caas_ip ()
{
    ssh_connection
    #CAAS_IP=`$SSH root@${SERVER} "grep \"^caas_servlet_names\" /opt/ericsson/scs/conf/scs.properties" |  awk 'BEGIN {FS = "="} {print $2}' | awk -F, '{print $1}'`
    local CAAS_IP=[`$SSH root@${SERVER} "grep \"^caas_servlet_names\" /opt/ericsson/scs/conf/scs.properties" |  awk 'BEGIN {FS = "="} {print $2}'`]

    #   CAAS_IP=`$SSH root@${SERVER} "ldapclient list | grep NS_LDAP_SERVERS | awk '{print \\$2} | sed 's/,//g'"`
    regex="\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
    if [[ `echo "$CAAS_IP" | $EGREP "^$regex$"` ]] || [[ `echo "$CAAS_IP" | $EGREP "^\[$regex,$regex\]$"` ]]  || [[ `echo "$CAAS_IP" | $EGREP "^\[$regex\]$"` ]]
    then
        echo "INFO: Read Caas IP from $SERVER"
    else
        echo "INFO: Couldn't read Caas IP from $SERVER"
        CAAS_IP=""
    fi

    while true
    do
        echo -n "Please enter the IP address of CAAS server, or a comma seperated list ($CAAS_IP): "
        if [[ $INTERACTION == "y" ]]
        then
            read caas_input
            if [[ "$caas_input" == "" ]]
            then
                final_ip="$CAAS_IP"
            else
                final_ip="$caas_input"
            fi
        else
            echo ""
            echo "INFO: Interaction Set to NO, Default answer here is the IP obtained from the master"
            final_ip="$CAAS_IP"
        fi

        regex="\b(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b"
        if [[ `echo "$final_ip" | $EGREP "^$regex$"` ]] || [[ `echo "$final_ip" | $EGREP "^\[$regex,$regex\]$"` ]] || [[ `echo "$final_ip" | $EGREP "^\[$regex\]$"` ]]
        then
            echo "CAAS IP is $final_ip"
            break
        else
            echo "INFO: $final_ip doesn't look like a valid IP address"
            if [[ $INTERACTION == "y" ]]
            then
                echo "INFO: Please retry to enter a valid IP address, or two ip addresses seperated by a comma"
            else
                echo "ERROR: No valid caas IP was given"
                exit_routine 24
            fi
        fi
    done

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIM in `getSimulationListForHostFiltered "$host"`
        do
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}_$SIM.$BASHPID.log
            PARALLEL_STATUS_HEADER="Setting caas IP"
            PARALLEL_STATUS_STRING="Setting caas IP for $SIM on $host"
            #SHOW_STATUS_UPDATES="NO"
            #SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            	$RSH -l netsim $host "/mnt/support/set_caas_ip.sh $final_ip $SIM"
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
    done
    parallel_wait
}

set_security_MO ()
{
    local sec_level=$1
    for host in `echo $NETSIMSERVERLIST`
    do
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Setting Security MOs"
        PARALLEL_STATUS_STRING="Setting Security MOs on $host"
        #SHOW_STATUS_UPDATES="NO"
        #SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Changing the Mo's for $SIMNAME"
            $RSH -l netsim $host "/mnt/support/set_security_MO.sh $sec_level $SIMNAME"
            echo "INFO: Running secmode -l $sec_level on $SIMNAME"
            $RSH -l netsim $host "/mnt/support/set_security_secmode.sh $sec_level $SIMNAME"
        done
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

function re-enrollment_sl3-sl1(){
    
    echo "INFO:Move FROM SL3 to SL?";
    echo -n "INFO: Level 2 or Level 1:(1/2)" 
    read LEVEL
    while [[ "$LEVEL" == "" ]]
    do
            echo -n "INFO: Level 2 or Level 1:(1/2)" 
            read LEVEL
    done
    for host in `echo $NETSIMSERVERLIST`
    do

        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
             echo "INFO: Changing $SIMNAME nodes to $LEVEL"
             $RSH -l netsim $host "/mnt/support/re-enrollment_sl3-to-sl1.sh $host $SIMNAME $LEVEL | $NETSIMSHELL" | $GREP -vi Display
        done
    done


}

### Function: check_relay ###
#
#  Checks netsim relay on each netsim 
#
# Arguments:
#       none
# Return Values:
#       none
check_relay()
{
    echo "#####################################################"
    echo "INFO: Checking relays, please wait..."
    echo "#####################################################"
    for host in `echo $NETSIMSERVERLIST`
    do
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER=""
        PARALLEL_STATUS_STRING=""
        SHOW_STATUS_UPDATES="NO"
        SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        #echo "INFO: Checking relay on $host"
        RETURN_CODE=`$RSH -l netsim $host "/mnt/support/check_relay.sh > /dev/null 2>&1;echo \\$?"`
        if [[ "$RETURN_CODE" == "1" ]]
        then
            echo "WARNING: The relay isn't started on $host"
        else
            echo "INFO: The relay is started on $host"
        fi
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
    echo "#####################################################"
    echo "INFO: All relay check processes are completed."
    echo "#####################################################"
}

### Function: start_all ###
#
#   Start all SIMs
#
# Arguments:
#       none
# Return Values:
#       none
start_all()
{
	local host=""
	message $DEBUG "DEBUG: entering start_all()\n"
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
    	start_all_v3
    	return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
			message $DEBUG "DEBUG: startSimulatoinNodesOnHost.sh $host $SIMNAME\n"
            startSimulationNodesOnHost.sh $host $SIMNAME
        done
    done
}

start_all_v3()
{
	message $DEBUG "DEBUG: start_all_v3()\n"
    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered $host`
        do
	        #   Parallelized code below
	        ###################################
	        # Parallel variable initialization
	        ###################################
	        LOG_FILE=/tmp/${host}.${SIMNAME}.$BASHPID.log
	        PARALLEL_STATUS_HEADER="Starting SIMS"
	        PARALLEL_STATUS_STRING="Starting $SIMNAME on $host"
	        ###################################
		    (
		        (
		            startSimulationNodesOnHost.sh $host "$SIMNAME" 
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
	    done
    done
    parallel_wait
}

change_pm_path()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Changing PM Path"
        PARALLEL_STATUS_STRING="Changing PM Path on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (

        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            $RSH -l netsim $host "/mnt/support/change_pm_path.sh $SIMNAME"
        done

        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

setup_internal_ssh()
{
    for host in `echo $NETSIMSERVERLIST`
    do

        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Setting up internal ssh"
        PARALLEL_STATUS_STRING="Setting up internal ssh on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (

	        $RSH $host "/mnt/support/setup_internal_ssh.sh"

        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

setup_external_ssh()
{
    for host in `echo $NETSIMSERVERLIST`
    do

        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Setting up external ssh"
        PARALLEL_STATUS_STRING="Setting up external ssh on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        	(
				$RSH $host "/mnt/support/setup_external_ssh.sh"

        	) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

enable_chrooted()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            #   Parallelized code below
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}_$SIMNAME.$BASHPID.log
            PARALLEL_STATUS_HEADER="Enabling chrooted environments"
            PARALLEL_STATUS_STRING="Enabling chrooted environment for SIM $SIMNAME on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            $RSH -l netsim $host "/mnt/support/setfspathtype.sh $SIMNAME relative"
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
    done
    parallel_wait
}

disable_chrooted()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            #   Parallelized code below
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}_$SIMNAME.$BASHPID.log
            PARALLEL_STATUS_HEADER="Enabling chrooted environments"
            PARALLEL_STATUS_STRING="Enabling chrooted environment for SIM $SIMNAME on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            $RSH -l netsim $host "/mnt/support/setfspathtype.sh $SIMNAME absolute"
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
    done
    parallel_wait
}

set_security_definitions_sl3()
{
    echo $SECURITY | $EGREP "^atrc|^akita|^aty" >> /dev/null
    TEST=`echo $?`
    if [ $TEST -ne 0 ]
    then
        echo "ERROR: set_security_definitions_sl3 You must specify a supported security -a trcusXXX, -a atylXXX"
        exit 1
    else
        echo "INFO: Security is $SECURITY"
    fi

    echo -n "Do you want to enable CORBA Security (y/n): "
    if [[ "$INTERACTION" == "y" ]]
    then
        read answer
    else
        answer="y"
        echo "INFO: Interaction Set to NO, Default answer here is (y)"
    fi

    if [[ "$answer" == "y" ]]
    then
        corba_security="yes"
    else
        corba_security="no"
    fi

    for host in `echo $NETSIMSERVERLIST`
    do

        echo "INFO: Creating security definition"
        $RSH -l netsim $host "/mnt/support/create_security_definition_sl3.sh $SECURITY"
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            #   Parallelized code below
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}_$SIMNAME.$BASHPID.log
            PARALLEL_STATUS_HEADER="Setting sl3 security definitions"
            PARALLEL_STATUS_STRING="Setting sl3 security definitions for $SIMNAME on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            echo "Calling set"
            $RSH -l netsim $host "/mnt/support/set_security_definitions_sl3.sh $SIMNAME $SECURITY $corba_security" > /tmp/test.log

            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
    done
    parallel_wait

}
setup_sl3_phase1 ()
{
    setup_internal_ssh
    enable_chrooted
    start_all
}

setup_sl3_phase2 ()
{
    if [[ "$1" != "y" ]]
    then
        echo -n "Has initial enrollment been completed yet for at least one node and pems stored on atrclin3? (y/n): "
        if [[ "$INTERACTION" == "y" ]]
        then
            read answer
        else
            answer="y"
            echo "INFO: Interaction Set to NO, Default answer here is (y)"
        fi
        if [[ "$answer" == "n" ]]
        then
            echo "INFO: Exiting because initial enrollment hasn't been completed yet"
            exit_routine 34
        fi
    fi
    upload_pems_sl3
    set_security_definitions_sl3
    set_caas_ip
    set_security_MO_sl3
    show_security_status
}

setup_sl2_phase1()
{
	create_pem_sl2          create the .pem files needed for rollout
}

setup_sl2_phase2()
{
     upload_pems_sl2
     setup_internal_ssh  #  Enables internal ssh
     set_security_MO_sl2 #  sets security to sl2 on sims (sftp secure without corba)
}

set_security_MO_sl1()
{
    set_security_MO 1
}
set_security_MO_sl2()
{
    set_security_MO 2
}
set_security_MO_sl3()
{
    set_security_MO 3
}

show_security_status()
{
    echo "INFO: Checking security status, please wait..."
	local $host
    for host in `echo $NETSIMSERVERLIST`
    do
	    echo "INFO: Security Status On $host"
   		rsh -l netsim $host "/mnt/support/show_secStatus.sh -summary" |egrep -vi Display | grep -v default
    done
}

show_security_status_pdsh()
{
    echo "INFO: Checking security status, please wait..."
	pdsh -l netsim -S -w "$NETSIMSERVERLIST" "/mnt/support/show_secStatus.sh -summary" |egrep -vi Display | grep -v default|sort -nr
}
### Function: stop_all ###
#
#   Stop all SIMs
#
# Arguments:
#       none
# Return Values:
#       none
stop_all()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        stop_all_v3
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "DEBUG: Sim name is $SIMNAME"
            echo "INFO: Stopping SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/stop_all.sh $host $SIMNAME | $NETSIMPIPE" | $GREP -vi Display
            echo "INFO: SIM $SIMNAME stopped on $host"
        done
    done
}

stop_all_v3()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}$SIMNAME.$BASHPID.log
            PARALLEL_STATUS_HEADER="Stopping SIMs"
            PARALLEL_STATUS_STRING="Stopping SIM $SIMNAME on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            echo "INFO: Stopping SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/stop_all.sh $host $SIMNAME | $NETSIMSHELL" | $GREP -vi Display
            echo "INFO: SIM $SIMNAME stopped on $host"
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
        echo "INFO: Please wait for other processes to finish.."
    done
    parallel_wait
}

restart_netsim()
{
	# MIND! that this gets overwritten when using GRAN!
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do
            echo "DEBUG: ReStarting netsim on $host"

            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Restarting netsim"
            PARALLEL_STATUS_STRING="Restart netsim on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
		        echo "INFO: restarting netsim on host $host"
		        $RSH -l netsim $host "/netsim/inst/restart_netsim" | $GREP -vi Display
		        echo "INFO: Netsim restarted on $host"
	        ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
        parallel_wait
        return
    else
        for host in `echo $NETSIMSERVERLIST`
        do
            echo "DEBUG: ReStarting netsim on $host"
            $RSH -l netsim $host "/netsim/inst/restart_netsim" | $GREP -vi Display
        done
    fi
}

restart_netsim_gui()
{
	# MIND! that this gets overwritten when using GRAN!
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do
            echo "DEBUG: ReStarting netsim_gui on $host"

            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Restarting netsim_gui"
            PARALLEL_STATUS_STRING="Restart netsim_gui on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
		        echo "INFO: restarting netsim on host $host"
		        $RSH -l netsim $host "/netsim/inst/restart_gui" | $GREP -vi Display
		        echo "INFO: Netsim giu restarted on $host"
	        ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
        parallel_wait
        return
    else
        for host in `echo $NETSIMSERVERLIST`
        do
            echo "DEBUG: ReStarting netsim_gui on $host"
            $RSH -l netsim $host "/netsim/inst/restart_gui" | $GREP -vi Display
        done
    fi
}

stop_netsim(){
	# MIND! that this gets overwritten when using GRAN!
	echo -n "INFO: stopping netsim on hosts $NETSIMSERVERLIST"
	if ! pdsh -l netsim -S -w "$NETSIMSERVERLIST" "/netsim/inst/stop_netsim"	
	then
		echo " OK"
	else
		echo " Failed to stop at least one of the netsims!"
	fi
}

start_netsim()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
	    for host in `echo $NETSIMSERVERLIST`
    	do
	        echo "DEBUG: Starting netsim on $host"

            # Parallelized version below
    	    ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Starting netsim"
            PARALLEL_STATUS_STRING="Starting netsim on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            $RSH -l netsim $host "/netsim/inst/start_netsim" | $GREP -vi Display
            echo "INFO: Netsim started on $host"
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
        parallel_wait
        return
    else
        for host in `echo $NETSIMSERVERLIST`
        do
            echo "DEBUG: Starting netsim on $host"
            $RSH -l netsim $host "/netsim/inst/start_netsim" | $GREP -vi Display
        done
	fi
}

reboot_host()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        reboot_host_v2
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        echo "DEBUG: Rebooting $host"
        $RSH -l root $host "bash;/sbin/shutdown -r now "
    done
}

reboot_host_v2()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "DEBUG: Rebooting $host"
        #$RSH -l root $host "bash;/sbin/shutdown -r now "

        # Parallelized version below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Rebooting netsims"
        PARALLEL_STATUS_STRING="Rebooting $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        $RSH -l root $host "bash;/sbin/shutdown -r now"
        echo "INFO: $host is rebooting"
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

### Function: create_scanners ###
#
#   Create scanners
#
# Arguments:
#       none
# Return Values:
#       none

create_scanners()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        create_scanners_v2
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Creating Scanners for SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/create_scanners.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Scanners for SIM $SIMNAME created on $host"
        done
    done
}

create_scanners_v2()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Creating Scanners for SIMS on $host"

        # Parallelized code below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Creating scanners"
        PARALLEL_STATUS_STRING="Creating scanners on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Creating Scanners for SIM $SIMNAME on $host"

            $RSH -l netsim $host "/mnt/support/create_scanners.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Scanners for SIM $SIMNAME created on $host"
        done
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

### Function: delete_scanners ###
#
#   Delete scanners
#
# Arguments:
#       none
# Return Values:
#       none
delete_scanners()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        delete_scanners_v2
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Deleting Scanners for SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/delete_scanners.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Scanners for SIM $SIMNAME deleted on $host"
        done
    done
}

delete_scanners_v2()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Deleting Scanners for SIMS on $host"

        # Parallelized code below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Deleting scanners"
        PARALLEL_STATUS_STRING="Deleting scanners on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Deleting Scanners for SIM $SIMNAME on $host"

            $RSH -l netsim $host "/mnt/support/delete_scanners.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Scanners for SIM $SIMNAME deleted on $host"
        done
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

### Function: create_scanners ###
#
#   Create scanners
#
# Arguments:
#       none
# Return Values:
#       none

copy_config_file_to_netsim_orig()
{
    #pm_rollout uses this ONLY
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Copy config file $CONFIGFILE to $host"
        $RCP $CONFIGFILE $host:/netsim/netsim_cfg
        $RSH -l root $host "/bin/chown netsim:netsim /netsim/netsim_cfg"
        echo "INFO: config file $CONFIGFILE copied to $host"
    done
}

copy_config_file_to_netsim()
{

    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Copy config file $CONFIGFILE to $host"
        $RCP $CONFIGFILE $host:/netsim/netsim_cfg
        $RSH -l root $host "/bin/chown netsim:netsim /netsim/netsim_cfg"
        echo "INFO: config file $CONFIGFILE copied to $host"
    done

    #Edit the netsim_cfg file is the -g option is set
    if [[ $NODEFILTER != "" ]]
    then
        echo "INFO: NODEFILTER applied for PM Rollout..."
        echo "INFO: /mnt/support/netsim_cfg_filter.sh $host $NODEFILTER"
        $RSH -l root $host "/mnt/support/netsim_cfg_filter.sh $host $NODEFILTER"	

    fi
}


### Function: setup_variables ###
#
#   Setup Variables
#
# Arguments:
#       none
# Return Values:
#       none
setup_variables()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        setup_variables_v2
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do

        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Variables for SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/setup_variables.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Variables for SIM $SIMNAME setup on $host"
        done
    done
}

setup_variables_v2()
{
    for host in `echo $NETSIMSERVERLIST`
    do

        echo "INFO: Setting up variables for SIMS on $host"
        # Parallelized code below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Setting up variables"
        PARALLEL_STATUS_STRING="Setting up variables on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Variables for SIM $SIMNAME on $host"

            $RSH -l netsim $host "/mnt/support/setup_variables.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Variables for SIM $SIMNAME setup on $host"
        done
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

### Function: save_and_compress ###
#
#   Setup Variables
#
# Arguments:
#       none
# Return Values:
#       none
save_and_compress()
{
    for host in `echo $NETSIMSERVERLIST`
    do

            echo "INFO: Setting up variables for SIMS on $host"
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Setting up variables"
            PARALLEL_STATUS_STRING="Setting up variables on $host"
            (
            (

        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Saving and compressing SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/save_and_compress.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: SIM $SIMNAME saved and compressed on $host"
        done
         ) > $LOG_FILE 2>&1;parallel_finish
                 ) & set_parallel_variables

    done
    parallel_wait
}

### Function: create_users ###
#
#   Create Users
#
# Arguments:
#       none
# Return Values:
#       none
create_users()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        create_users_v2
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Creating users for SIM $SIMNAME on $host"
            $RSH $host "/mnt/support/create_users.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Users created for SIM $SIMNAME on $host"
        done
    done
}

create_users_v2()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Creating users for SIMS on $host"

        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            # Parallelized code below
            ###################################
            LOG_FILE=/tmp/${host}_$SIMNAME.$BASHPID.log
            PARALLEL_STATUS_HEADER="Creating users"
            PARALLEL_STATUS_STRING="Creating users for SIM $SIMNAME on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (

            echo "INFO: Creating users for SIM $SIMNAME on $host"

            $RSH $host "/mnt/support/create_users.sh $host $SIMNAME" | $GREP -vi Display
            echo "INFO: Users created for SIM $SIMNAME on $host"
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
    done
    parallel_wait
}

### Function: disable_security ###
#
#   Disable Security
#
# Arguments:
#       none
# Return Values:
#       none
disable_security()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        disable_security_v2
        return
    fi
    stop_all
    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Disabling security for SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/disable_security.sh $host $SIMNAME $SERVER | $NETSIMSHELL" | $GREP -vi Display
            echo "INFO: Security disabled for SIM $SIMNAME on $host"
        done
    done
    start_all
}

disable_security_v2()
{
	checkSecurityServer $SECURITY

    stop_all
    for host in `echo $NETSIMSERVERLIST`
    do
        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Disabling Security"
        PARALLEL_STATUS_STRING="Disabling Security on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "INFO: Disabling security for SIM $SIMNAME on $host"
            $RSH -l netsim $host "/mnt/support/disable_security.sh $host $SIMNAME $SECURITY | $NETSIMSHELL" | $GREP -vi Display
            echo "INFO: Security disabled for SIM $SIMNAME on $host"
        done
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables

    done
    parallel_wait
    start_all
}

### Function: save_config ###
#
#   Saving Config
#
# Arguments:
#       none
# Return Values:
#       none
save_config()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
    	for host in `echo $NETSIMSERVERLIST`
		do
        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
	    PARALLEL_STATUS_HEADER="save_config"
        PARALLEL_STATUS_STRING="saving config on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        	(
    				save_config_on_host $host
		        ) > $LOG_FILE 2>&1;parallel_finish
	        ) & set_parallel_variables
   		done
	    parallel_wait
	else
	    for host in `echo $NETSIMSERVERLIST`
    	do
    		save_config_on_host $host
    	done
	fi

}

save_config_on_host()
{
	local $host=$1
	local ERRORS=0
	
   	local dateDir=`getNetsimSavedConfigDir.sh $host`
    local BACKUPDIR="$dateDir/config"

    if [ ! -d "$BACKUPDIR" ]
    then
		echo "DEBUG: Creating Backup dir ${BACKUPDIR}"
		$MKDIR -p "$BACKUPDIR" 
    fi

	if [ ! -d "$BACKUPDIR" ]
    then
		echo "ERROR: unable to create dir $BACKUPDIR"
    fi            

    echo "INFO: Copying config/ipFile/create users script for $host $SIM"
    $CP $CONFIGFILE $BACKUPDIR
	
	for SIMNAME in `getSimulationListForHostFiltered "$host"`
    do
    	local ERR=false

        if [ ! -d $BACKUPDIR/$SIMNAME ]
        then
            $MKDIR -p $BACKUPDIR/$SIMNAME
        fi

        echo -n "INFO: Saving config for $SIMNAME from $host"
        echo "SIMNAME=$SIMNAME" > $BACKUPDIR/${SIMNAME}/${SIMNAME}.cfg
        echo "NETSIMSERVER=$LINENETSIMSERVER" >> $BACKUPDIR/${SIMNAME}/${SIMNAME}.cfg
        echo "OSSSERVER=$LINEOSSSERVER" >> $BACKUPDIR/${SIMNAME}/${SIMNAME}.cfg
        echo "Chosen Deployment=$DEPLOYMENT" >> $BACKUPDIR/${SIMNAME}/${SIMNAME}.cfg
        echo "Chosen Security=$SECURITY" >> $BACKUPDIR/${SIMNAME}/${SIMNAME}.cfg

		local ipFile="$BACKUPDIR/${SIMNAME}_ip_addresses.txt"
		getIpsFromSimulation.sh $host $SIMNAME > $ipFile

		if ! scp "$BACKUPDIR/${SIMNAME}_ip_addresses.txt" $host:/netsim/
		then
			echo "ERROR: could not create/copy ipFile for $host $ipFile"
			ERR=true
		fi
			
        if ! scp $host:"/netsim/netsimdir/exported_items/create_users_${SIMNAME}.sh" ${BACKUPDIR}
		then
			echo "ERROR: could not scp $host:/netsim/netsimdir/exported_items/create_users_${SIMNAME}.sh"
			ERR=true
		fi

		if $ERR
		then
			local ERRORS=1
			echo " FAILED!"
		else
			echo " OK"
    	fi
	done    
	return $ERRORS
}


### Function: deploy_amos_and_c ###
#
#   Deploy AMOS
#
# Arguments:
#       none
# Return Values:
#       none

deploy_amos_and_c()
{
#deloy_amos and c planned to fade out in R25B
    #NR:2130 - Improvement Requirement: Deploy C (license) during install by linking to /c folder
	#http://netsim.lmera.ericsson.se/nr2130  
   
    #NR:2131 - Improvement Requirement: Deploy amos (userdefined scripts)
    #http://netsim.lmera.ericsson.se/nr2131
	
    echo "INFO: Deploying AMOS and C"

    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
	    for host in `getNetsimServerListFiltered`
    	do
        	###################################
        	# Parallel variable initialization
        	###################################
        	LOG_FILE=/tmp/${host}.$BASHPID.log
        	PARALLEL_STATUS_HEADER="Deploying amos and c"
       		PARALLEL_STATUS_STRING="Deploying amos and c on $host"
        	# SHOW_STATUS_UPDATES="NO"
        	SHOW_OUTPUT_BORDERS="NO"
        	###################################
        	(
	    	    (
					deploy_amos_and_c_on_host $host
    	    	) > $LOG_FILE 2>&1;parallel_finish
	        ) & set_parallel_variables

	    done
    	parallel_wait
	else
	    for host in `echo $NETSIMSERVERLIST`
    	do
			deploy_amos_and_c_on_host $host
    	done
	fi
}

show_sims(){
	
	echo "INFO: chegetSimulationsFromNetsimServer $NETSIMSERVERLIST"
	pdsh -R exec -S -w "$NETSIMSERVERLIST" getSimulationsFromNetsimServer %h	
}

deploy_amos_and_c_on_host()
{
	local host=$1
	echo "INFO: Deploying C on $host"

    $RSH $host "/mnt/support/deploy_c.sh $host" | $GREP -vi Display
    CTEST=`$RSH $host "/mnt/support/check_file.sh $host blank C"`
    echo $CTEST | $GREP "OK" > /dev/null
    if [ $? -ne 0 ]
    then
        echo "ERROR: C not deployed correctly"
        exit 15
    else
        echo "INFO: C deployed on $host"
    fi
	for SIMNAME in `getSimulationListForHostFiltered "$host"`
    do
        echo "INFO: Deploying AMOS for  SIM $SIMNAME on $host"
        $RSH -l netsim $host "/mnt/support/deploy_amos.sh $host $SIMNAME" | $GREP -vi Display
        AMOSTEST=`$RSH $host "/mnt/support/check_file.sh $host $SIMNAME AMOS"`
        echo $AMOSTEST | $GREP "OK" > /dev/null
        if [ $? -ne 0 ]
        then
            echo "ERROR: AMOS not deployed correctly"
            exit 15
        else
            echo "INFO: AMOS for $SIMNAME deployed on $host"
        fi
    done
}

### Function: generate_ip_map ###
#
#   Generate IP map for AMOS
#
# Arguments:
#       none
# Return Values:
#       none

generate_ip_map()
{   
	echo ""
    message $DEBUG "DEBUG: entering generate_ip_map generating ip Map for AMOS `getNetsimServerListFiltered`"
	
	if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
    	if ! pdsh -R exec -S -w "`getNetsimServerListFiltered`" generateIpMap.sh %h
		then
			echo "ERROR: generating ip map on one of the netsims!"
			exit_routine 4;
		fi
        return
    fi
	
    for host in `getNetsimServerListFiltered`
    do
	 	generateIpMap.sh $host
    done
}

upload_ip_map()
{
    if [[ ${SERVER} == "" ]]
    then
        echo "ERROR: Please include [ -s oss_server_name ] option"
        exit_routine 0
    fi

    #ejershe - Aug 2010
    #Upload ip_map.txt file to oss server - Called only as a -f option
    rm -rf /tmp/ip_map_${SERVER}.txt

    echo "INFO: Uploading IP Map for AMOS"
    for host in `echo $NETSIMSERVERLIST`
    do
    	#SIMLIST is probably not even used here looks like c&p
        SIMLIST=`getSimulationListForHostFiltered "$host"`

        #ejershe- This could be run anytime so we want to take the latest configuration that was rolled out
        saved_date_dir=`getNetsimSavedConfigDir.sh $host`
        upload="scp ./savedconfigs/$host/${saved_date_dir}/config/ip_map.txt root@${SERVER}:/home/nmsadm/${host}_ip_map.txt"
        cat ./savedconfigs/$host/${saved_date_dir}/config/ip_map.txt >> /tmp/ip_map_${SERVER}.txt

    done
    scp /tmp/ip_map_${SERVER}.txt root@${SERVER}:/home/nmsadm/tep/ip_map_${SERVER}.txt
    echo "INFO: ip_map_${SERVER}.txt is located on ${SERVER} in /home/nmsadm/tep"
    UPDATEBANNER="ip_map_${SERVER}.txt is located in /home/nmsadm/tep"
}

rollout_arne()
{
	generate_arne    # generates xmls from netsimboxs
    upload_arne      # uploads arne from savedconfig/$host/$date/arnefiles to $oss:/home/nmsadm/tep
	check_arne_files
    arne_validate    # validate all xmls on oss server
    arne_import      # import all xmls on oss server (Tracing is ON)
    arne_dump        # Dump the CS once import is finished
    start_adjust_maf # synchronizes nodes ONRM_CS and Seg_masterservice_CS
}

upload_arne()
{
    message $DEBUG "DEBUG: entering upload_arne()\n"
    echo "INFO: Checking /home/nmsadm/tep Directory on ${SERVER} exists"

    ssh -x root@${SERVER} 2>/dev/null "if [ ! -d /home/nmsadm/tep ];then echo 'INFO: Creating /home/nmsadm/tep'; mkdir /home/nmsadm/tep;fi"

    local files_to_upload=""
    for host in `getNetsimServerListFiltered`
    do	
    	local simFilter=`getSimulationListForHostFiltered $host|tr " " "|"`
    	if [[ "$simFilter" == "" ]]
    	then
    		message $DEBUG "DEBUG: nothing to be done for host $host\n"
    	else
    		local arneFilesDir=`getNetsimSavedConfigDir.sh $host`/arnefiles
    		local files_to_upload+=`ls -1 $arneFilesDir/import-v2*xml|egrep "$simFilter"|tr "\n" " "`
		fi
    done
	message $INFO "INFO: uploading list :\n"
	echo -e "$files_to_upload"|tr " " "\n"
	echo "INFO: uploading list please wait..."
    scp $files_to_upload root@${SERVER}:/home/nmsadm/tep/

    echo "INFO: Changing ownership of xml files to nmsadm"
    ssh -nx root@${SERVER} 2>/dev/null 'chown -R nmsadm /home/nmsadm/tep' 
    UPDATEBANNER="ARNE files are located in /home/nmsadm/tep on ${SERVER}"
}

smrs_query()
{
    message $DEBUG "DEBUG: entering function smrs_query()\n"
    message $DEBUG "DEBUG : trying to fetch SMRS SLAVE name from master server\n"
	local SMRSSLAVE_FROM_MASTER=`getSmrsSlavesFromMaster.sh $SERVER`

	if [ -n "$SMRSSLAVE_FROM_MASTER" ]
	then
		echo "INFO: Master server $SERVER has as FtpService SMRS_SLAVE" 
		echo "$SMRSSLAVE_FROM_MASTER"
	else
		echo "INFO: Master server $SERVER does not seem to have a SMRS Slave as FtpService\n"
	fi
	
    while [[ $SMRSSLAVE == "" ]]
    do
        printf "INPUT: PLEASE ENTER SMRS SLAVE LONG NAME (Enter none for no smrs setup):"
        read SMRSSLAVE
    done

    if [[ $SMRSSLAVE != "none" ]]
	then
		
    	while ! getent hosts $SMRSSLAVE
    	do
        	printf "ERROR: unable to lookup dns host $SMRSSLAVE\n"
        	printf "INPUT: please enter real SMRS SLAVE name for netsim hosts file:"
        	read SMRSSLAVE
    	done
		
		if [[ `expr length "$SMRSSLAVE"` -gt "9" ]]
		then
	    	while [[ $SHORT_SERVER_NAME == "" ]]
			do
        		printf "ERROR: SMRS SLAVE NAME is too long please enter short name:"
        		read SHORT_SERVER_NAME
    		done

	    	while [[ $ONLY_SHORT_NAMES == "" ]]
			do
	       		printf "ERROR: do you want to use only shortnames in xml's? y/n:"
    	   		read ONLY_SHORT_NAMES
			done
			
    	else
    		echo "DEBUG: SMRSSLAVE name is shorter then 9 chars making SHORT_SERVER_NAME the same"
			SHORT_SERVER_NAME=$SMRSSLAVE
    	fi

        # Get the smrs details to add to /etc/hosts on the netsim boxes
        SMRS_OUTPUT=`$GETENT hosts $SMRSSLAVE`

        SMRS_SERVER_IP=`echo "$SMRS_OUTPUT" | $AWK '{print $1}'`
        SMRS_FULL_NAME=`echo "$SMRS_OUTPUT" | $AWK '{print $2}'`
        ETC_HOSTS_STRING="$SMRS_SERVER_IP $SHORT_SERVER_NAME $SMRS_FULL_NAME"
    else
		   	echo "DEBUG: SMRSSLAVE set to none setting SHORT_SERVER_NAME also to none"
			SHORT_SERVER_NAME=$SMRSSLAVE
    fi
    
	if [[ $ONLY_SHORT_NAME == "y" ]]
	then
		echo "INFO: only using short names"
		SHORT_SERVER_NAME=$SMRSSLAVE
	fi
	
   	echo "DEBUG: SMRSSLAVE=$SMRSSLAVE SHORT_SERVER_NAME=$SHORT_SERVER_NAME"
}


xmlType_query()
{
	createNewDateDir=false
    message $DEBUG "DEBUG: entering function xmlType_query()\n"
	
    while [[ $XMLTYPE != "c" ]] &&  [[ $XMLTYPE != "m" ]]
    do
	    printf "QUERY: <Create> or <Modify> XMLTYPE:([c]/m):"
	    read XMLTYPE

	    if [[ $XMLTYPE != "c" ]] &&  [[ $XMLTYPE != "m" ]] 
		then
	        echo "ERROR: You must specify c/m"
		fi

	    if [[ $XMLTYPE == "c" ]] 
	    then
	        echo "INFO: Setting tag to <Create>"

			echo -n "QUERY: create a new date dir under savedconfig/hostname ([y]/n):"
			read ANSWER

			if [[ $ANSWER == "y" || $ANSWER == "Y" ]]
			then
				createNewDateDir=true
			else
				createNewDateDir=false
	    	fi
		fi
	
	    if [[ $XMLTYPE == "m" ]]
	    then
	        echo "INFO: Setting tag to <Modify>"
	    fi
	done
}

generate_arne()
{
	xmlType_query
	smrs_query

    message $DEBUG "DEBUG: entering function generate_arne()\n"

    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do
            #   Parallelized code below
            ###################################
            # Parallel variable initialization
            ###################################
            LOG_FILE=/tmp/${host}.$BASHPID.log
            PARALLEL_STATUS_HEADER="Generating ARNE XMLs"
            PARALLEL_STATUS_STRING="Generating ARNE XMLs on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
                (
                    generate_arne_with_host $host

                ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
        parallel_wait
    else
        for host in `echo $NETSIMSERVERLIST`
        do
            generate_arne_with_host $host
        done
    fi
}

createNewDateDirForHost()
{
	local host=$1

	if [[ ! -d ${SCRIPTDIR}/savedconfigs/${host} ]]; then mkdir ${SCRIPTDIR}/savedconfigs/${host};fi
	if ! mkdir ${SCRIPTDIR}/savedconfigs/${host}/$formatedDate; then return 1;fi
	if ! mkdir ${SCRIPTDIR}/savedconfigs/${host}/$formatedDate/arnefiles; then return 1;fi
	
}

generate_arne_with_host()
{
	message $DEBUG "entering generate_arne_with_host() $host\n"
	local host=$1
	
    BACKUPDIR="$MOUNTPOINT/savedconfigs/$host/"

	if [[ "$XMLTYPE" == "c" ]]
	then
		if $createNewDateDir
		then
			if ! createNewDateDirForHost $host
			then 
				message $ERROR "ERROR: could not create new date dir for host $host\n"
				exit_routine 2
			fi 
        fi
	fi		

	local saved_date_dir=`getNetsimSavedConfigDir.sh $host`

    #ejershe- This could be run anytime so we want to take the latest configuration that was rolled out
	message $DEBUG "DEBUG: using saved dir $saved_date_dir\n"

    if [[ $SMRSSLAVE != "none" ]]
    then
        # Add smrs slave to /etc/hosts on the netsim
        echo "INFO: Adding the SMRS Slave to /etc/hosts"
        $RSH $host "if [[ \`grep ^$SMRS_SERVER_IP /etc/hosts\` ]]; then echo INFO: Already exists; else echo $ETC_HOSTS_STRING >> /etc/hosts; fi"
    fi

    for SIMNAME in `getSimulationListForHostFiltered "$host"`
    do
    	RET=""
        echo "INFO: Generating ARNE xml file for $SIMNAME SMRS: $SMRSSLAVE Short:$SHORT_SERVER_NAME"
        $RSH $host "/mnt/support/create_arne1.003.sh $host $SIMNAME $BACKUPDIR $SMRSSLAVE $SHORT_SERVER_NAME"
        local RET=`$RSH $host ls -1 /netsim/netsimdir/exported_items/import-v2-${SIMNAME}_${host}_*.xml`
        if [[ "$RET" == "" ]]
        then
          	echo -e "$RET"
			echo "ERROR: xml for $host $SIMNAME did not create"
			return 24
        fi 
    done

    #Manipulate ARNE files with post steps
	#helge  its probably better to use the filtered list here
    SIMLIST=`getSimulationListForHost "$host"`

    echo "INFO: Post manipulation of ARNE"

    #Manipulate arne create files before upload
    ls ${saved_date_dir}/arnefiles/import-v2*create*xml  | grep -v post | while read ARNEFILE
    do
        echo "INFO: Applying post manipulation on $ARNEFILE"
        TMP_ARNE_FILE=`echo $ARNEFILE | awk -F/ '{print $NF}'| awk -F. '{print $1}'`

        support/manipulate_arne_post.pl $ARNEFILE $XMLTYPE > ${saved_date_dir}/arnefiles/${TMP_ARNE_FILE}_post.xml
        mv ${saved_date_dir}/arnefiles/${TMP_ARNE_FILE}_post.xml $ARNEFILE
    done

    #Manipulate the arne delete files to remove ftpServices
    ls ${saved_date_dir}/arnefiles/import-v2*delete*xml  | grep -v post | while read ARNEFILE
	do
	    echo "INFO: Applying post manipulation on $ARNEFILE"
	    TMP_ARNE_FILE=`echo $ARNEFILE | awk -F/ '{print $NF}'| awk -F. '{print $1}'`

	    support/manipulate_arne_delete_post.pl $ARNEFILE $XMLTYPE > ${saved_date_dir}/arnefiles/${TMP_ARNE_FILE}_post.xml
	    mv ${saved_date_dir}/arnefiles/${TMP_ARNE_FILE}_post.xml $ARNEFILE
	done
}

createAssociationsTextFile()
{
    message $DEBUG "DEBUG: entering createAssociationsTextFile()\n"

    ASSOCIATIONS_DIR=./subscripts/associations/$SERVER/
    ASSOCIATIONS_FILE=$ASSOCIATIONS_DIR/associations.txt
    SITES_LIST=$ASSOCIATIONS_DIR/sites.txt
    MES_LIST=$ASSOCIATIONS_DIR/mes.txt

    if [[ -f $ASSOCIATIONS_FILE ]]
    then
        echo -n "Do you want to start again with associations related work? y/n (n):"
        read response
        if [[ "$response" != "y" ]]
        then
            message $INFO "INFO: NOT recreating the associations file\n"
            return 0
        else
            message $INFO "INFO: Recreating the associations file\n"
            rm -rf $ASSOCIATIONS_DIR/* > /dev/null 2>&1
        fi
    else
        rm -rf $ASSOCIATIONS_DIR/* > /dev/null 2>&1
        mkdir -p $ASSOCIATIONS_DIR > /dev/null 2>&1
    fi
	# only required for SIU nodes sitting on a seperate netsimbox
	# this function does not need or use the  SIU assoc type $SIU_ASSOC_TYPE"
	VERBOSE=20
	
	local host
	local sim
	getSiuFromConfig
	
	local siuListFile=/tmp/siuList-$SERVER.$$.tmp

	message $INFO "INFO: building full list of available SIU's please wait...\n"
	#build a full list of SIU's
	for host in `echo "$SIU_netsim"`
 	do
        message $INFO "INFO: Getting information for $host\n"
		for sim in `getSimulationListForHostFiltered $host`
		do
            echo "There is a sim $sim"
			# make sure we have the long name
			simName=`getSimulationsFromNetsimServer "$host"|egrep $sim`
			getSimulationNodesFromNetsimServer.sh $host $simName |sort -V >> "$siuListFile"
		done
 	done
	echo "DEBUG: $siuListFile"

	local sim=""
	local siuCounter=0
	local subNetCounter=0
	##local siuAssociationsFile="/tmp/siuAcc-$SERVER.$$.tmp"

	message $INFO "INFO: building associations in: $ASSOCIATIONS_FILE\n"
	message $INFO "INFO: pulling live information please wait...\n"
	
	for host in `getNetsimServerList`
	do
		for sim in `getSimulationListForHost $host`
		do
			simLongName=`getSimulationsFromNetsimServer.sh $host|grep $sim|grep -v "SIU"`
			if [[ "$simLongName" == "" ]]
			then
				message $WARNING "WARNING: did not find simulation as its in config $sim on server $host or its a SIU sim\n"
			else
				(( subNetCounter++ ))

				message $INFO "$host: $simLongName subNet $subNetCounter "			
			
				if [[ $simLongName =~ "RNC" ]]
				then 
					local simType="WRAN"
				fi

				if [[ $simLongName =~ "LTE" ]]
				then 
					local simType="LTE"
				fi
				
				for node in `getSimulationNodesFromNetsimServer.sh $host $simLongName`
				do
					siuNode=""
					if [[ $node =~ "RBS" ]]
					then
						# get entry of file at linenumber:
						(( siuCounter++ ))
						siuNode=`awk -v nodeCounter="$siuCounter" 'NR==nodeCounter {print;exit}' $siuListFile`
					fi

					if [[ "$siuNode" == "" ]]
					then
   						echo "$sim $node $sim none none $simType" >> $ASSOCIATIONS_FILE
					else
   						echo $sim $node $sim SIU-SUBNW-${subNetCounter} $siuNode $simType >> $ASSOCIATIONS_FILE
					fi
					#message $DEBUG "."
				done
				message $INFO " done\n"
				#exit_routine 2
			fi
		done
	done
	
	#siuSavedConfigDir=`getNetsimSavedConfigDir.sh $SIU_netsim`

	#ASSOCIATIONS_FILE="${siuSavedConfigDir}/arnefiles/associations.txt"
	#echo "DEBUG mv -f $siuAssociationsFile $ASSOCIATIONS_FILE"
	#mv -f $siuAssociationsFile $ASSOCIATIONS_FILE


}

set_destination_siu()
{
		# only required for SIU nodes sitting on a seperate netsimbox
		local host
		getSiuFromConfig
		message $DEBUG "DEBUG: entering function set_destination_siu() for hosts in SIU_netsim $SIU_netsim\n"
		for host in `echo $SIU_netsim`
		do
			setDefaultDestination.sh -n $host -f STN
		done
}

getSiuFromConfig()
{
	message $DEBUG "DEBUG: entering getSiuFromConfig()\n"
	SIU_netsim=`$EGREP "^SIU_netsim=" $CONFIGFILE | $AWK -F\" '{print $2}'`
	SIU_sim=`$EGREP "^SIU_sim=" $CONFIGFILE | $AWK -F\" '{print $2}'`
	SIU_ASSOC_TYPE=`$EGREP "^SIU_ASSOC_TYPE=" $CONFIGFILE | $AWK -F\" '{print $2}'`

	message $DEBUG "DEBUG: Siu sim is $SIU_sim\n"
	message $DEBUG "DEBUG: Siu netsim is $SIU_netsim\n"
	message $DEBUG "DEBUG: SIU assoc type is $SIU_ASSOC_TYPE\n"

	# If it is none of these types exit
	if [[ "$SIU_netsim" == "" || "$SIU_sim" == "" ]]
	then
		echo "ERROR $ME: SIU_netsim or SIU_sim list not configured in config file exiting...!"
		exit_routine 24
	fi
}

check_siu_ftp()
{
	message $DEBUG "DEBUG: checkSiuFtpLocations.sh $SERVER\n"

	# without these ftp locations import would fail
	if ! checkSiuFtpLocations.sh $SERVER
	then
		if not_sure_to_continue 
		then 
			exit_routine 7
		fi
	fi
}

generate_arne_siu()
{
	message $DEBUG "DEBUG: entering function generate_arne_siu()\n"
	check_siu_ftp
	generate_arne
	#createAssociationsTextFile
	siu_xml_mod
}

siu_xml_mod()
{
	getSiuFromConfig
	siuSavedConfigDir=`getNetsimSavedConfigDir.sh $SIU_netsim`
    ASSOCIATIONS_DIR=./subscripts/associations/$SERVER/
    ASSOCIATIONS_FILE=$ASSOCIATIONS_DIR/associations.txt
    SITES_LIST=$ASSOCIATIONS_DIR/sites.txt
    MES_LIST=$ASSOCIATIONS_DIR/mes.txt


	# ------------------------------------------------------------------ 
    # Now for each sim, lets modify their xmls accordingly. Remember, the siu generate_arne must be done before wran / lte
    for host in `echo $NETSIMSERVERLIST`
    do
        saved_date_dir=`getNetsimSavedConfigDir.sh $host`
        #   Parallelized code below
        ###################################
        # Parallel variable initialization
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Adding subnetworks and associations for SIU"
        PARALLEL_STATUS_STRING="Adding subnetworks and associations for SIU $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            ls ${saved_date_dir}/arnefiles/import-v2*$SIMNAME*xml | grep -v post | while read ARNEFILE
        	do
            	echo "INFO: Adding SubNetworks to xml file for $SIMNAME, xml is $ARNEFILE"
            	support/addSubNetworksToXml.sh $ARNEFILE $ASSOCIATIONS_FILE $SIU_ASSOC_TYPE
        done
    done
    ) > $LOG_FILE 2>&1;parallel_finish
    ) & set_parallel_variables

done
parallel_wait
}

rollout-arne()
{
	generate_arne #  generates xmls from netsimboxs
	upload_arne   #  uploads arne from savedconfig/$host/$date/arnefiles to $oss:/home/nmsadm/tep
    arne_validate #  validate all xmls on oss server
    arne_import   #  import all xmls on oss server (Tracing is ON)
    arne_dump     #  Dump the CS once import is finished
}

post_scripts_on_host()
{
	local host=$1
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            SIM_CHECK=`echo $SIMNAME | grep LTE`
            if [[ $SIM_CHECK == "" ]]
            then
                echo "INFO: Running Create CV sw_install_variables.sh RNC Nodes"
                $RSH -l netsim $host "cp $MOUNTPOINT/support/sw_install* /netsim;chmod 755 /netsim/sw_install*;cd /netsim;./sw_install_variables.sh | /netsim/inst/netsim_shell"
            else
                echo "INFO: Running Create CV sw_install_variables_lte.sh LTE Nodes"
                $RSH -l netsim $host "cp $MOUNTPOINT/support/sw_install* /netsim;chmod 755 /netsim/sw_install*;cd /netsim;./sw_install_variables_lte.sh | /netsim/inst/netsim_shell;"
            fi
        done
}

post_scripts()
{
    if [[ "$NEWER_FUNCTIONS" == "y" ]]
    then
        post_scripts_v2 
        return
    fi

    for host in `echo $NETSIMSERVERLIST`
    do
		post_scripts_on_host $host
    done
}

post_scripts_v2()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        # Parallelized code below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Running Post Scripts"
        PARALLEL_STATUS_STRING="Running Post Scripts on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
	        (
				post_scripts_on_host $host
        	) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
}

#Handy for just checking that netsim is running
check_netsim_version()
{
    echo "#####################################################"
    for host in `echo $NETSIMSERVERLIST`
    do
        NETSIMVERSION=`rsh $host "/mnt/support/check_netsim_version.sh $host "`	
        echo "INFO: $NETSIMVERSION is running on $host"
    done
    echo "#####################################################"
}

#Check that eth0 has full speed
check_eth0_speed()
{
    echo "#####################################################"
    for host in `echo $NETSIMSERVERLIST`
    do
        NETSIMETH0SPEED=`rsh $host "/mnt/support/check_eth0_speed.sh $host "`	
        echo "INFO: eth0 $NETSIMETH0SPEED $host"
    done
    echo "#####################################################"
}

check_sftp()
{
    for host in `echo $NETSIMSERVERLIST`
	do
		local sims+=`getSimulationListForHostFiltered "$host"`
		sims+=" "
	done
	if [[ $SERVER =~ "ossfs" ]]
	then
		echo "ERROR: SERVER=$SERVER please target only one server with -s"
		exit_routine 2
	fi
	
	sims=`echo "$sims"|sed 's/ *$//g'`
    echo "#####################################################"
    echo "getting nodeslist from master $SERVER please wait..."
    check_sftp_nodes_from_master.sh "$SERVER" "$sims"
    echo "returned $?"
    echo "#####################################################"
}

check_import()
{
	local netsimBoxes=`getNetsimServerList`
    echo "#####################################################"
    echo "getting nodeslist from master $SERVER please wait..."
	checkImportOnMasterAgainstNetsims.sh $SERVER "$netsimBoxes"
    echo "#####################################################"
}


reboot()
{
	echo "ERROR: mind your words! this would reboot atrclin3"
	exit 1
}
iuantAntennaGain()
{
    echo "#####################################################"
    echo "Changing iuantAntennaGain to a random value between 0..255 for all 160 ERBS"    
    for host in `echo $NETSIMSERVERLIST`
    do
           for sim in `getSimulationListForHost $host`
           do
            echo "SIM NAME: $sim"        
            $RSH -n -l netsim $host "/mnt/support/iuantAntennaGain.sh $sim 1 160"
           done

    done
    echo "#####################################################"
}


#helge
check_nead_status_on_master()
{
    echo "#####################################################"
    check_nead_status_on_master.sh $SERVER
    echo "#####################################################"
}

all_final_checks()
{
    echo "****check_netsim_version*******"
    check_netsim_version
    echo "****check_installed_patches****"
    check_installed_patches
    echo "****show_started***************"
    show_started
    echo "****sim_summary_wran***********"
    sim_summary_wran
	if createPmEnabled
	then
	    echo "****check_pm*******************"
 	   check_pm
	fi
    echo "****show_security_status*******"
    show_security_status
    echo "****check_eth0_speed***********"
    check_eth0_speed
    echo "****verify_MAF*****************"
    verify_MAF
    echo "****check_nead_status_on_master*******"
    check_nead_status_on_master 
	echo "sec level `getSecurityLevel` "
	if [[ `getSecurityLevel` > "1" ]]
 	then
    	echo "****check_sftp_nodes_from_master.sh*******"
		check_sftp_nodes_from_master.sh $SERVER
    	echo "****cello_ping nodes from master*******"
		cello_ping	
    fi
    
    echo "#####################################################"
}

#each netsim will have its own personalised login message
login_banner()
{

    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Setting up login Banner on $host"

		#helge this should probably be filter simlist
		# in the for loop head and unfiltered within the for loop
        SIMLIST=`getSimulationListForHost "$host"`

        for SIMNAME in `echo $SIMLIST`
        do
            SIM_KEY=`$EGREP "^${host}_key=" $CONFIGFILE  | grep $SIMNAME | $AWK -F\" '{print $2}' | $AWK '{print $2}'`
            #GRAN ONLY -Pass through all the sim keys to the login banner 
            SIM_KEYS="$SIM_KEYS $SIM_KEY"
        done
        SIM_KEYS_FORMATTED=`echo $SIM_KEYS | sed "s/ /-/g"`
        SIMLIST_FORMATTED=`echo $SIMLIST | sed "s/ /\//g"`
        `rsh $host "/mnt/support/login_banner.sh $host "$SIMLIST_FORMATTED" "$USERID" $SERVER $SIM_KEYS_FORMATTED"`
    done
}

update_login_banner()
{
    #update the login banner if a function is run post rollout 
    #This function will run only when you pass through a function using -f option
    #In order then for the banner to update, you must have the variable USERBANNER="Text" in a function
    #Also then you must have an if loop below to cover that function - upload_ip_map is an example

    if [[ $FUNCTIONS == "upload_ip_map" ]]
    then

        for host in `echo $NETSIMSERVERLIST`
        do
            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done

    elif [[ $FUNCTIONS == "pm_rollout" ]]
    then

        for host in `echo $NETSIMSERVERLIST`
        do
            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done
    elif [[ $FUNCTIONS == "install_patch" ]]
    then

        for host in `echo $NETSIMSERVERLIST`
        do
            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done
    elif [[ $FUNCTIONS == "upload_arne" ]] 
    then
        for host in `echo $NETSIMSERVERLIST`
        do
            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done

    elif [[ $FUNCTIONS == "install_netsim" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do

            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done



    elif [[ $FUNCTIONS == "arne_dump" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do

            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done
        #######################
        # GRAN function updates
        #######################
    elif [[ $FUNCTIONS == "setup_msc_smo" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do

            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done
    elif [[ $FUNCTIONS == "setup_msc_smia" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do

            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done
    elif [[ $FUNCTIONS == "setup_bsc_gprs" ]]
    then
        for host in `echo $NETSIMSERVERLIST`
        do

            echo "INFO: Updating login Banner on $host"
            UPDATEBANNER_FORMATTED=`echo $UPDATEBANNER | sed "s/ /-/g"`
            rsh $host "/mnt/support/update_login_banner.sh $UPDATEBANNER_FORMATTED $USERID"
        done

    fi
}

stop_relay()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Stopping relay on $host"
        $RSH -l root $host "/netsim/inst/bin/relay stop" | $GREP -vi Display
    done
}
### Function: restart_relay ###
#
#  Restarts the netsim relay on each netsim
#
# Arguments:
#       none
# Return Values:
#       none
restart_relay()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: ReStarting relay on $host"
        $RSH -l root $host "/netsim/inst/bin/relay stop;/netsim/inst/bin/relay start" | $GREP -vi Display
    done
}

pm_rollout()
{
    #Copy over the config file again just in case
    #echo "INFO: Copying $CONFIGFILE to $host again"
    #copy_config_file_to_netsim

    #echo $NETSIMSERVERLIST
    for host in `echo $NETSIMSERVERLIST`
    do

        echo "INFO: Rolling out PM on $host"
        echo "INFO: Moving necessary files from atrclin3 to $host"
        LOCALDIR=`pwd`

        CONFIGFILE_FULLPATH="${LOCALDIR}/${CONFIGFILEARG}"
        /var/www/html/scripts/automation_wran/netsim_pm_setup/pm_move_files.sh $host $CONFIGFILE_FULLPATH

        if [ $? -eq 99 ]
        then
            echo "ERROR: pm_move_files.sh exited with an error"
            exit 123
        fi

        #/var/www/html/scripts/automation_wran/netsim_pm_setup/pm_setup_on_site.sh $host $CONFIGFILEARG
        UPDATEBANNER="PM Rollout"

        # Parallelized code below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="PM Rollouts"
        PARALLEL_STATUS_STRING="PM Rollout on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        /var/www/html/scripts/automation_wran/netsim_pm_setup/pm_setup_on_site.sh $host $CONFIGFILE_FULLPATH
        echo "INFO: Completed PM rollout on $host.."
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables
    done
    parallel_wait
    #echo "INFO: Copying back orignal netsim_cfg file to $host"
    copy_config_file_to_netsim_orig
}

install_patch()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Checking netsim version on $host"
        NETSIMVERSION=`rsh $host "/mnt/support/check_netsim_version.sh $host "`
        echo "INFO: $NETSIMVERSION is running on $host"
        echo "INFO: Retrieving list of patches for $NETSIMVERSION"

        #R22 is 6.2 and R23 is 6.3 - Could change in the future
        if [[ `echo "$NETSIMVERSION" | grep "R24"` != "" ]]
        then
            #R23*
            GENERATION="6.4"
        elif [[ `echo "$NETSIMVERSION" | grep "R23"` != "" ]]
        then
            #R23*
            GENERATION="6.3"

        elif [[ `echo "$NETSIMVERSION" | grep "R22"` != "" ]] 
        then
            #R22*
            GENERATION="6.2"
        fi

        echo "INFO: Netsim Generation is $GENERATION"
        #This came for a script on atrclin2 which is part of netsim install page. It retrieves a list of patches from the netsim Respository

        #Get the patch list
        PATCHLIST=`/usr/bin/wget -q -O - --no-proxy http://netsim.lmera.ericsson.se/tssweb/netsim${GENERATION}/released/NETSim_UMTS.${NETSIMVERSION}/Patches/index.html | /bin/grep -e P*\.zip\< -e P*tar\.Z\< | awk -F\" '{print $2 " "}' | tr -d '\n'`
        #Get the patch description list
        `/usr/bin/wget -q -O - --no-proxy http://netsim.lmera.ericsson.se/tssweb/netsim${GENERATION}/released/NETSim_UMTS.${NETSIMVERSION}/Patches/index.html | grep -e "lmera.ericsson.se" | awk -F".html\">" '{print $2}' | awk -F "<" '{print $1}'> .description.$host.delete`

        #Get patch create date
        `/usr/bin/wget -q -O - --no-proxy http://netsim.lmera.ericsson.se/tssweb/netsim${GENERATION}/released/NETSim_UMTS.${NETSIMVERSION}/Patches/index.html | egrep  '^<td>([0-9].*)</td>' | awk -F"td>" '{print $2}' | awk -F"</" '{print $1}' > .date.$host.delete`


        #Print out patch name and patch description
        count_patch=1
        echo "INFO: Available patches for $NETSIMVERSION"
        if [[ $PATCHLIST == "" ]]
        then
            echo "ERROR: Unable to retrieve patch list"
            exit_routine 1	
        fi 
        for patch in $PATCHLIST
        do
            count_description=1
            count_date=1
            DESCRITION_TO_USE=""
            DATE_TO_USE=""
            while read line	
            do	
                if [[ $count_description == $count_patch ]]
                then
                    DESCRITION_TO_USE=`sed -n ${count_description}p ".description.$host.delete"`
                    DATE_TO_USE=`sed -n ${count_date}p ".date.$host.delete"`
                else
                    count_description=`expr $count_description + 1`
                    count_date=`expr $count_date + 1`
                fi

            done<.description.$host.delete
            printf  "$patch      $DATE_TO_USE\t $DESCRITION_TO_USE\n"	

            count_patch=`expr $count_patch + 1`		
        done
        rm -rf .description.$host.delete
        rm -rf .date.$host.delete

        echo "INPUT: Please specify which patch you wish to install (example P01499_UMTS_R23D.zip ):"
        read PATCHINSTALL

        #Retrieve and install patch from netsim eth website
        PATCHLOCATION="$SCRIPTDIR/patches"

        if [[ ! -f $PATCHLOCATION/${PATCHINSTALL} ]]
        then
            echo "INFO: Downloading $PATCH"
            /usr/bin/wget --no-proxy -O "$PATCHLOCATION/${PATCHINSTALL}" "http://netsim.lmera.ericsson.se/tssweb/netsim${GENERATION}/released/NETSim_UMTS.${NETSIMVERSION}/Patches/$PATCHINSTALL"
            echo "http://www.netsim.eth.ericsson.se/tssweb/netsim${GENERATION}/released/NETSim_UMTS.${NETSIMVERSION}/Patches/$PATCHINSTALL"

            if [[ $? -ne 0 ]]
            then
                echo "ERROR: Error downloading $PATCHINSTALL"
                exit_routine 0
            fi
        else
            echo "INFO: $PATCHINSTALL already exists on atrclin3, not downloading"
        fi

        echo "INFO: Transfering $PATCHINSTALL to $host"
        $RCP $PATCHLOCATION/$PATCHINSTALL root@${host}:/netsim	

        if [[ $? -ne 0 ]]
        then
            echo "ERROR: Error Transfering  patch to $host"
            exit_routine 0
        fi

        #Check patch is not of size 0 bytes
        PATCH_FILESIZE=$(stat -c%s "$PATCHLOCATION/$PATCHINSTALL")
        if [[ $PATCH_FILESIZE == "0" ]]
        then
            echo "ERROR: Patch is of size 0 bytes, exiting"
            #remove bogus file
            rm -rf $PATCHLOCATION/$PATCHINSTALL
            exit_routine 0		
        fi

        echo "INFO: Installing $PATCHINSTALL on $host..."
        $RSH -l netsim  -n $host "echo \".install patch /netsim/$PATCHINSTALL force\" | /netsim/inst/netsim_shell"
        UPDATEBANNER="Patch Installed $PATCHINSTALL"
    done
}

check_installed_patches()
{
    echo "#####################################################"
    echo "INFO: Checking installed patches "	
    for host in `echo $NETSIMSERVERLIST`
    do
        $RSH -l netsim  -n $host "echo \".show installation\" | /netsim/inst/netsim_shell" > .show_patches.$host
        RETURNED_ERROR=`cat .show_patches.$host | grep -i ERROR | grep -v logtool`
        INSTALLEDPATCHES=`cat .show_patches.$host | egrep "^P"`

        echo "---------------------------------------------------------"
        echo "$host"
        if [[ $INSTALLEDPATCHES == "" ]]
        then
            if [[ "$RETURNED_ERROR" != "" ]]
            then
                echo "DEBUG: An error may have occured retrieving patches, see below output from netsim"
                cat .show_patches.$host
            else
                echo "INFO: No patches installed"
            fi
        else 
            cat .show_patches.$host | egrep ^P
        fi

        rm -rf .show_patches.$host
    done
    echo "#####################################################"
}

install_netsim()
{
    echo "INPUT: Installing netsim"
    printf "INPUT:Enter Version of netsim you wish to install (example R23H):"
    read INSTALLVERSION
    TYPE=ST
    PROJECT=R7

    echo -n "QUERY: Would you like to run setup_internal_ssh (for sl3) after netsim is installed? (y/n): "
    read SETUP_INTERNAL_SSH

    for host in `echo $NETSIMSERVERLIST`
    do
        echo "INFO: Installing Netsim $INSTALLVERSION on $host"
        #echo "INFO: Installing in BACKGROUND...WAIT 10 MINUTES"
        UPDATEBANNER="TEP Installed $INSTALLVERSION"
        NETSIMSERVERIP=`$GETENT hosts $host | $AWK '{print $1}'`

        # Parallelized code below
        ###################################
        LOG_FILE=/tmp/${host}.$BASHPID.log
        PARALLEL_STATUS_HEADER="Installing netsim $INSTALLVERSION"
        PARALLEL_STATUS_STRING="Installing netsim $INSTALLVERSION on $host"
        # SHOW_STATUS_UPDATES="NO"
        # SHOW_OUTPUT_BORDERS="NO"
        ###################################
        (
        (
        wget --no-proxy -q -O - "http://atrclin2.athtem.eei.ericsson.se/TCM3/NetsimSite/Include/installnetsim.php?machine=${NETSIMSERVERIP}&userid=${USERID}&p=${PROJECT}&v=${INSTALLVERSION}&t=${TYPE}&e=${USERID}" > /dev/null 2>&1
        echo "INFO: Netsim installation on $host completed"
        ) > $LOG_FILE 2>&1;parallel_finish
        ) & set_parallel_variables

    done 
    parallel_wait

    if [[ "$SETUP_INTERNAL_SSH" == "y" ]]
    then
        setup_internal_ssh
    fi
	check_netsim_version
}

setup_rsh()
{
    NETSIMSERVERLIST=`$EGREP "^SERVERS=" $CONFIGFILE | $AWK -F\" '{print $2}'`
    if [ -n "$NETSIMSERVER"  ]
    then
        NETSIMSERVERLIST=$NETSIMSERVER
    fi
    for host in `echo $NETSIMSERVERLIST`
    do

        echo "INFO: Setting up rsh on $host"
        NETSIMSERVERIP=`$GETENT hosts $host | $AWK '{print $1}'`
        echo "INFO: $host IP address is $NETSIMSERVERIP"
        if [[ $NETSIMSERVERIP == "" ]]
        then
            echo "ERROR: nslookup for $host failed. Exiting..."
            exit 1
        fi
        RSHTEST=`$RSH $host "/bin/ls / | $GREP etc"`
        echo $RSHTEST | $GREP etc >> /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "INFO: First rsh test failed on $host, attempting to setup rsh using shroot as password"
            PASSWORD=shroot
            wget --no-proxy -O - "http://atrclin2.athtem.eei.ericsson.se/TCM3/NetsimSite/Include/Setup_rsh.php?password=${PASSWORD}&machine=${NETSIMSERVERIP}" > /dev/null 2>&1 & 

            RSHTEST=`$RSH $host "/bin/ls / | $GREP etc"`
            echo $RSHTEST | $GREP etc >> /dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo "INFO: Second rsh test failed on $host using shroot, please enter its password"
                echo -n "INPUT: Enter $host root password: "
                read PASSWORD

                wget --no-proxy -O - "http://atrclin2.athtem.eei.ericsson.se/TCM3/NetsimSite/Include/Setup_rsh.php?password=${PASSWORD}&machine=${NETSIMSERVERIP}" > /dev/null 2>&1 &
                RSHTEST=`$RSH $host "/bin/ls / | $GREP etc"`
                echo $RSHTEST | $GREP etc >> /dev/null 2>&1
                if [ $? -ne 0 ]; then
                    echo "ERROR: $host does not trust me. Exiting. Check if its contactable and hasn't got a full root disk."
                    exit 3
                else
                    echo "INFO: RSH setup looks ok now on $host"
                fi
            else
                echo "INFO: RSH setup looks ok now on $host"
            fi
        else
            echo "INFO: RSH setup looks ok already on $host"
        fi
    done
}

show_subnets_wran()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        TOTALIPS=`$RSH $host "$IFCONFIG -a | $GREP inet | $WC -l"`
        TOTALVIPS=`expr $TOTALIPS - 2`

        echo "INFO: Total IP address available on $host is $TOTALIPS"
        IPREQD=0
        IPSUBS=`$RSH $host "/mnt/support/list_ip_subs.sh $host" | $GREP -vi Display`
        IPSUBSARRAY=()
        COUNT=1

        for ipsub in `echo $IPSUBS`
        do
            IPSUBSARRAY[$COUNT]=$ipsub
            COUNT=`expr $COUNT + 1`
            echo "INFO: ipsub is $ipsub" 
        done
    done
}

ssh_connection_omsas()
{
    OMSAS_SERVER="$1"

    ssh-keygen -R "$OMSAS_SERVER" > /dev/null 2>/dev/null

    #This is a special case for ssh so dont put in $SSH
    SSHCONNECTION_root=`ssh -o BatchMode=yes -o LogLevel=QUIET -oStrictHostKeyChecking=no root@${OMSAS_SERVER} 'hostname ; echo $? ' | tail -n 1`

    #root account
    if [[ $SSHCONNECTION_root == "0" ]]
    then
        message $DEBUG "DEBUG $ME: root SSH Is PASSWORDLESS\n"
    else
        echo "WARNING: root SSH is not PASSWORDLESS to OMSAS - Will I set it up(y/n)"
        read SSHSETUP
        echo "INFO: You will be prompted for $OMSAS_SERVER root password"
        perl -e "select(undef, undef, undef, 0.2)"

        if [[ $SSHSETUP == "y" ]]
        then
            echo "INFO: Adding atrclin3 trusted key to .ssh/authorized_keys for root"

                        echo "INFO: Adding atrclin3 trusted key to .ssh/authorized_keys for root"
                   $SSH root@${SERVER} 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzkNZsz3EgUCuDXR83CCz2RkxDpr9WQ+qlUJpXNHE5QbcrB6QCLfykxGOzk5akio7eh0JDgNaaowoXp74bCK44gA2tf/zVBFg0E1zsaoWjn4WDOrfxLLJpMigkYGp6JaJdXIM3KFdnotEg27UDFMmyJ9MKcs3hy5u9GtvuMSbITbYXeWeLjguzVFshY4+2K4XYTzA5SkELUyzvybSjZTWMBev1UFPCEpiJ1ZyQVf6Bsk4bSSA/49fotxH7I+GAv4YWuzsz800y1c8yNDuokmhiMm/noEVT0x8VfvIXDw0DxeU7a5rLrvDhPlZ6/1crsCKffVSa7hT33sie0SMhZ+hCQ== root@atrclin3" >> .ssh/authorized_keys'
                                                                        #authorised_keys2
                   $SSH root@${SERVER} 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzkNZsz3EgUCuDXR83CCz2RkxDpr9WQ+qlUJpXNHE5QbcrB6QCLfykxGOzk5akio7eh0JDgNaaowoXp74bCK44gA2tf/zVBFg0E1zsaoWjn4WDOrfxLLJpMigkYGp6JaJdXIM3KFdnotEg27UDFMmyJ9MKcs3hy5u9GtvuMSbITbYXeWeLjguzVFshY4+2K4XYTzA5SkELUyzvybSjZTWMBev1UFPCEpiJ1ZyQVf6Bsk4bSSA/49fotxH7I+GAv4YWuzsz800y1c8yNDuokmhiMm/noEVT0x8VfvIXDw0DxeU7a5rLrvDhPlZ6/1crsCKffVSa7hT33sie0SMhZ+hCQ== root@atrclin3" >> .ssh/authorized_keys2'


        else
            echo "INFO: Not setting up passwordless ssh on $OMSAS_SERVER"
        fi
    fi
}

ssh_connection()
{
    message $DEBUG "DEBUG: entering function ssh_connection()\n"	
    if [ -z "$SERVER" ] 
    then
        echo "ERROR: You must specify a OSS Server -s"
        exit_routine 1
    fi

    if ! timeout 10s canPing.sh $SERVER;
    then
        echo "ERROR: cant ping oss server -s $SERVER exiting"
        exit_routine 1
    fi

    #Or run this ssh-keygen -R
    ssh-keygen -R "$SERVER" > /dev/null 2>/dev/null

    #This is a special case for ssh so dont put in $SSH
    SSHCONNECTION_root=`ssh -o BatchMode=yes -o LogLevel=QUIET -oStrictHostKeyChecking=no root@${SERVER} 'hostname ; echo $? ' | tail -n 1`

    #root account
    if [[ $SSHCONNECTION_root == "0" ]]
    then
        message $DEBUG "DEBUG $ME: root SSH Is PASSWORDLESS\n"
    else
        echo "WARNING: root SSH is not PASSWORDLESS - Will I set it up(y/n)"
        read SSHSETUP
        echo "INFO: You will be prompted for $SERVER root password"
        perl -e "select(undef, undef, undef, 0.2)"

        if [[ $SSHSETUP == "y" ]]
        then
            echo "INFO: Adding atrclin3 trusted key to .ssh/authorized_keys for root"
                        $SSH root@${SERVER} 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzkNZsz3EgUCuDXR83CCz2RkxDpr9WQ+qlUJpXNHE5QbcrB6QCLfykxGOzk5akio7eh0JDgNaaowoXp74bCK44gA2tf/zVBFg0E1zsaoWjn4WDOrfxLLJpMigkYGp6JaJdXIM3KFdnotEg27UDFMmyJ9MKcs3hy5u9GtvuMSbITbYXeWeLjguzVFshY4+2K4XYTzA5SkELUyzvybSjZTWMBev1UFPCEpiJ1ZyQVf6Bsk4bSSA/49fotxH7I+GAv4YWuzsz800y1c8yNDuokmhiMm/noEVT0x8VfvIXDw0DxeU7a5rLrvDhPlZ6/1crsCKffVSa7hT33sie0SMhZ+hCQ== root@atrclin3" >> .ssh/authorized_keys'
                        #authorised_keys2
                        $SSH root@${SERVER} 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzkNZsz3EgUCuDXR83CCz2RkxDpr9WQ+qlUJpXNHE5QbcrB6QCLfykxGOzk5akio7eh0JDgNaaowoXp74bCK44gA2tf/zVBFg0E1zsaoWjn4WDOrfxLLJpMigkYGp6JaJdXIM3KFdnotEg27UDFMmyJ9MKcs3hy5u9GtvuMSbITbYXeWeLjguzVFshY4+2K4XYTzA5SkELUyzvybSjZTWMBev1UFPCEpiJ1ZyQVf6Bsk4bSSA/49fotxH7I+GAv4YWuzsz800y1c8yNDuokmhiMm/noEVT0x8VfvIXDw0DxeU7a5rLrvDhPlZ6/1crsCKffVSa7hT33sie0SMhZ+hCQ== root@atrclin3" >> .ssh/authorized_keys2'

            #atrclin2 entry
            echo "INFO: Adding atrclin2 trusted key to .ssh/authorized_keys for root"
            $SSH root@${SERVER} 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq4GeO+KFCsV0mcy3/A6RL7TBHIhirS5FppE+Boz6/Yu6/mSSCVEMb21ekYlKmOCqVebPQRBpprD3dO5zEvWROXL0SRFFGEmSyTt9NlCI0S7W6N/uNv3DGjxj+ukx4O65twhJUqXomike8ILo8OR6g9z5+Qj5HNi3RenP8+IP1MjuXEjGAzs8ZfN/RvyzxnDwlT/Lp8mw5QSBvcytAnCYLIlnlcFYxAaUhcg+rqFcT4OgSJEbWjnVSm8uDsZGMCJ1EvTwl6ny2KvzbmTjbFTyva6uKthMeHxvA2dS1mKO08PJZHqYf/5NSrD/ygU36b0qkw3RQQ15EEV7ET3p1Y1BbQ== root@atrclin2.athtem.eei.ericsson.se" >> .ssh/authorized_keys'

        else
            echo "INFO: Not setting up passwordless ssh on $SERVER"
        fi
    fi

    #nmsadm account
    message $DEBUG "DEBUG: testing nmsadm SSH Is PASSWORDLESS"	
    SSHCONNECTION_nmsadm=`timeout 20 ssh -o BatchMode=yes -o LogLevel=QUIET -oStrictHostKeyChecking=no nmsadm@${SERVER} 'hostname ; echo $? ' | tail -n 1`

    if [[ $SSHCONNECTION_nmsadm == "0" ]]	
    then
        message $DEBUG " OK\n"	
    else
        message $DEBUG " Failed!\n"	
        message $WARNING "WARNING: nmsadm SSH is not PASSWORDLESS - Will I set it up(y/n)\n"
        read SSHSETUP
        echo "INFO: You will be prompted for $SERVER root password"
        perl -e "select(undef, undef, undef, 0.2)"

        if [[ $SSHSETUP == "y" ]]
        then

            #check is .ssh dir exists
            $SSH root@${SERVER} 'if [ ! -d /home/nmsadm/.ssh ];then echo "INFO: Creating /home/nmsadm/.ssh"; mkdir /home/nmsadm/.ssh;chown nmsadm /home/nmsadm/.ssh;fi'
            echo "INFO: Unlocking nmadm account"
            $SSH root@${SERVER} 'passwd -u nmsadm'

            echo "INFO: Adding trusted key to .ssh/authorized_keys for nmsadm"
            echo "INFO: chown and chmod 700  .ssh/authorized_keys for nmsadm"

             $SSH root@${SERVER} 'echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAzkNZsz3EgUCuDXR83CCz2RkxDpr9WQ+qlUJpXNHE5QbcrB6QCLfykxGOzk5akio7eh0JDgNaaowoXp74bCK44gA2tf/zVBFg0E1zsaoWjn4WDOrfxLLJpMigkYGp6JaJdXIM3KFdnotEg27UDFMmyJ9MKcs3hy5u9GtvuMSbITbYXeWeLjguzVFshY4+2K4XYTzA5SkELUyzvybSjZTWMBev1UFPCEpiJ1ZyQVf6Bsk4bSSA/49fotxH7I+GAv4YWuzsz800y1c8yNDuokmhiMm/noEVT0x8VfvIXDw0DxeU7a5rLrvDhPlZ6/1crsCKffVSa7hT33sie0SMhZ+hCQ== root@atrclin3" >> /home/nmsadm/.ssh/authorized_keys;chown nmsadm /home/nmsadm/.ssh/authorized_keys;chmod 700 /home/nmsadm/.ssh/authorized_keys'
        else
            echo "INFO: Not setting up passwordless ssh on $SERVER"
        fi
    fi
}

create_pem_sl2()
{
    #check can you ssh to OSS server
    ssh_connection
    SSHCONNECTION=`ssh -o BatchMode=yes -o LogLevel=QUIET -oStrictHostKeyChecking=no root@${SERVER} 'hostname ; echo $? '`
    if [[ $? != "0" ]]
    then
        echo "ERROR: Cannot ssh to $SERVER exiting..."
        exit_routine 1
    fi		

    #SCP over the createpem.* files

    #First check to see if the /home/nmsadm/tep dir exists, if not create it
    $SSH root@${SERVER} 'if [ ! -d /home/nmsadm/tep ];then echo "INFO: Creating /home/nmsadm/tep"; mkdir /home/nmsadm/tep;chown nmsadm /home/nmsadm/tep;fi' 

    echo "INFO: Copying over support/createpem.* to $SERVER"   
    $SCP support/createpem.* root@${SERVER}:/home/nmsadm/tep      

    echo "INFO: Verifying that the ossrc.p12 exists in /ericsson/config"
    VERIFYOSSRC_P12=`$SSH root@${SERVER} 'ls /ericsson/config/ossrc.p12 > /dev/null 2>&1;echo $? '`
    if [[ $VERIFYOSSRC_P12 != "0" ]]
    then
        echo "ERROR: Cannot find the /ericsson/config/ossrc.p12 file  exiting..."
        exit_routine 1
    else
        echo "INFO: Found /ericsson/config/ossrc.p12"
    fi 

    echo "INFO: Running createpem.sh on $SERVER"
    $SSH root@${SERVER} 'cd /home/nmsadm/tep;chmod 755 createpem.*;./createpem.sh /ericsson/config/ossrc.p12'

    #New perl script to parse total.pem
    $SSH root@${SERVER} 'cd /home/nmsadm/tep;rm -rf key.pem certs.pem cacerts.pem;./createpem.pl -certfile total.pem -certdir .'

    echo "INFO: Retrieving remote .pem files"
    echo "INFO: Verify subscripts/security/${SERVER} exists on atrclin3"
    if [ ! -d subscripts/security/${SERVER} ]
    then 
        echo "INFO: Creating subscripts/security/${SERVER}"; 
        mkdir subscripts/security/${SERVER}
    else
        echo "INFO: subscripts/security/${SERVER} exists on atrclin3"
    fi
    $SCP root@${SERVER}:/home/nmsadm/tep/*pem subscripts/security/${SERVER}
    echo "INFO: Pem file created - Specify -a ${SERVER} as part of rollout"
}

cello_ping()
{
	echo "DEBUG: entering cello_ping()"
	local host
	local ERR=0;
	local celloPing="celloping-001.sh"
	
    #check is tep dir created and copy celloping
 	
    if ! $SSH -nx root@${SERVER} 'if [ ! -d /home/nmsadm/tep ];then echo "INFO: Creating /home/nmsadm/tep"; mkdir /home/nmsadm/tep;chown nmsadm /home/nmsadm/tep;fi';
    then 
    	echo "ERROR: unable to mkdir /home/nmsadm/tep on master $SERVER"
		exit_routine 23
    fi
    
    $SCP support/${celloPing}  root@${SERVER}:/home/nmsadm/tep > /dev/null  2>&1
	$SSH root@${SERVER} chmod 755 /home/nmsadm/tep/${celloPing} >/dev/null 2>&1
	
    echo "####################################################"

    for host in `echo ${NETSIMSERVERLIST}`;
	do
		SIMLIST=`getSimulationListForHostFiltered "$host"|sort -V`

		if [[ -n "$SIMLIST" ]]
		then
			# a bit of a trick to speed up get whole list for host and grep first node by simname

			echo ""
			echo "INFO: $host getting ips for first node in \"$SIMLIST\" from $SERVER" 

			simAndIpList=`getNodeIpsFromMaster.sh $SERVER "$SIMLIST"`

	        for SIMNAME in `echo $SIMLIST`
	        do
	        	echo -n "$host "

				simAndIp=`echo -e "$simAndIpList"|grep -vi "RXI"|grep -i "$SIMNAME"|head -1`
				simName=`echo $simAndIp|awk '{print $1}'`
				NODEIPADDRESS=`echo -e "$simAndIp"|awk '{print $2}'`

	        	echo -n "$simName "

	            CHECKIP=`echo $NODEIPADDRESS | egrep ^[0-9]`
	            if [[ $CHECKIP == "" ]]
	            then
	                echo "ERROR: failed to get ip for node=$SIMNAME from server=$SERVER!" 
					((ERR++));
	            else
	                echo -n "ssh $SERVER "
	                
	                if ! ssh -nx $SERVER 2>/dev/null "/home/nmsadm/tep/${celloPing} ${NODEIPADDRESS}"
	                then 
	                	((ERR++));
	                fi
	            fi
	        done
		fi
    done

	if [[ "$ERR" == "0" ]]
	then 
		echo -e "\nINFO: no trouble found :)z\n"
	else
		echo -e "\nERROR: could not ping $ERR of the nodes :(\n"
	fi
    echo "####################################################"
	return $ERR;	
}

show_started()
{
	message $DEBUG "getStartedStoppedNodes.sh \"$NETSIMSERVERLIST\"\n"
	
	if ! pdsh -N -R exec -S -w "$NETSIMSERVERLIST" getStartedStoppedNodes.sh %h
	then 
		message $ERROR "$host: total=$totalNodes started=$startedNodes stopped=$stoppedNodes\n"
	fi
}

cstest_me()
{
    #Always check you can ssh without a password
    ssh_connection

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            echo "####################################################"
            echo "INFO: cstest for ${SIMNAME}'s ManagedElement"
            $SSH root@${SERVER} "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt ManagedElement  | grep  ${SIMNAME}"

        done
    done
}

cstest_all()
{
    #Always check you can ssh without a password
    ssh_connection

    echo "####################################################"
    echo "INFO: cstest for all  ManagedElement"
    $SSH root@${SERVER} "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt ManagedElement  "
}

check_mims()
{
    ssh_connection
    if [ -z "$SERVER" ]
    then
        echo "ERROR: You must specify either OSS Server -s or NETSim Server -n"
        exit_routine 1
    fi
    echo "INFO: Copying across support/sort_mim_versions.sh to ${SERVER}"
    $SSH root@${SERVER} 'if [ ! -d /home/nmsadm/tep ];then echo "INFO: Creating /home/nmsadm/tep"; mkdir /home/nmsadm/tep;chown nmsadm /home/nmsadm/tep;fi'
    $SCP support/sort_mim_versions.sh root@${SERVER}:/home/nmsadm/tep

    echo "INFO: Running sort_mim_versions.sh on ${SERVER}"
    $SSH root@${SERVER} "chmod 755 /home/nmsadm/tep/sort_mim_versions.sh;/home/nmsadm/tep/sort_mim_versions.sh"
}

cstest_ftp()
{
    #Always check you can ssh without a password
    ssh_connection

    echo "INFO: cstest retrieving FtpServices from ${SERVER}"
    echo "INFO: Command used /opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt  FtpService"
    $SSH root@${SERVER} "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt  FtpService"
}

validate_arne()
{
	arne_validate
}

arne_validate()
{
    ssh_connection
    local validateScript=support/arne_validate.001.sh
    local remoteValidateScript=/home/nmsadm/tep/arne_validate.001.sh
    echo "INFO: Uploading $validateScript to $remoteValidateScript"
    
    $SSH $SERVER rm -f $remoteValidateScript
    $SCP $validateScript  nmsadm@${SERVER}:$remoteValidateScript > /dev/null  2>&1

	$SSH ${SERVER} "chown -R nmsadm /home/nmsadm/tep/*.xml"
	$SSH ${SERVER} "chmod 755 $remoteValidateScript"
	 
    echo "INFO: Attempting to validate the ARNE xml files on $SERVER"
    if [ -n "$ROLLOUT" ] && [ -n "$NODEFILTER" ]
    then
        $SSH ${SERVER} "$remoteValidateScript -r '$ROLLOUT' -g '$NODEFILTER'"
    elif [ -n "$NODEFILTER" ]
    then
        $SSH ${SERVER} "$remoteValidateScript -g '$NODEFILTER'"
    elif [ -n "$ROLLOUT" ]
    then
        $SSH ${SERVER} "$remoteValidateScript -r '$ROLLOUT'"
    else

        $SSH ${SERVER} "$remoteValidateScript "

    fi
}

getFirstNode()
{
	local host
	
	for host in `getNetsimServerListFiltered`
	do
		local simList=`getSimulationListForHostFiltered $host`
#		echo "checking host $host simlist $simList"
		if [[ $simList != "" ]]
		then 
			for shortSimName in `echo "$simList"`
			do 
				local longSimName=`getSimulationsFromNetsimServer.sh $host|grep "$shortSimName"`
				local nodeAndIp=`getIpsFromSimulation.sh $host $longSimName|sort -V|head -1`
				if [[ $nodeAndIp != "" ]]
				then
					echo "$host $longSimName $nodeAndIp"
					return 0
				fi
			done
		fi
	done
	return 1
}

initial_enrollment()
{
	checkSecurityServer $SECURITY
    message $DEBUG "DEBUG: entering function initial_enrollment()\n"

    #---------------------
     message $INFO "INFO: fetching omsas information from HW tracker oss=$SECURITY\n"

	getMasterServerFromHwTracker.sh $SECURITY|grep -i omsas|awk '{print "deployment=" $3 "        omsas="$2 }'

	echo ""
	message $INFO "INFO: checking if security is enabled on $SECURITY"
	
	local RETURN=`ssh -nx $SECURITY 2>/dev/null /opt/ericsson/saoss/bin/security.ksh -settings|egrep "security|set to"`

	if [[ "$RETURN" =~ "OFF" ]];
	then
		echo "************************************************"
		echo -e "$RETURN"
		echo "************************************************"
		echo "ERROR: Please turn on secruity on $SECURITY (will restart all MC's!)"
		echo "ssh -nx $SECURITY 2>/dev/null /opt/ericsson/saoss/bin/security.ksh -change"
		echo "ERROR: cant do initial enrolement without it exiting..."
		exit_routine 1;
	fi

    message $DEBUG "DEBUG: fetching omsas information from security server $SECURITY\n"
 	local RETURN=`ssh -nx $SECURITY 2>/dev/null "$smtool selftest scs 7"`
	if [[ "$RETURN" =~ "empty" ]];
	then
		echo "ERROR: SCS IOR Files not setup on $SECURITY cant do initial enrolement without exiting..."
		exit_routine 1;
	fi
	
	onrmIp=`echo -e "$RETURN"|grep size|awk -F{ '{ print $1}'`
	onrmServer=`dig -x "$onrmIp" +short`
	echo ""
	echo "INFO: omsas from oss is $onrmServer with ip $onrmIp"

    echo -n "QUERY: Please give the hostname of the omsas ($onrmIp): "
    read OMSAS_SERVER
	if [[ "$OMSAS_SERVER" == "" ]]
	then
		OMSAS_SERVER=$onrmIp
	fi

    ssh_connection_omsas $OMSAS_SERVER

    #---------------------

    # Get the caas user from the omsas
    CAAS_USER_OUTPUT_FULL=`$SSH $OMSAS_SERVER "egrep 'caas|csa|casa' /etc/passwd | grep -v "caas:" | grep -v "csa:" | awk -F: '{print \\$1}'"`
    CAAS_USER_OUTPUT=`echo "$CAAS_USER_OUTPUT_FULL" | tail -1`
    echo "INFO: Possible caas users found"
    echo "$CAAS_USER_OUTPUT_FULL"
    echo "-------------------------------"
    echo -n "QUERY: Whats the caas user name on the omsas? ($CAAS_USER_OUTPUT): "
    read CAAS_USER

    if [[ "$CAAS_USER" == "" ]]
    then
        CAAS_USER=$CAAS_USER_OUTPUT
    fi

    echo "INFO: Caas user is $CAAS_USER"

    # Making sure the caas user has security management tss profile on the master
    ssh_connection
    echo "INFO: Making sure this user has security management role on the master server $SERVER"
    $SSH $SERVER "/opt/ericsson/bin/userAdmin -create $CAAS_USER"
    $SSH $SERVER "/opt/ericsson/bin/roleAdmin -add Security_Management $CAAS_USER"

    #---------------------
    echo "INFO: Checking OMSAS Server ($SERVER) IOR exists on omsas ($OMSAS_SERVER)"
    IOR_LS=`$SSH $OMSAS_SERVER "ls /opt/ericsson/cadm/conf/masterserver.iors/* > /dev/null;echo \"Return\\$?\""`
    if [[ `echo "$IOR_LS" | grep Return0` ]]
    then
        echo "INFO: The IOR file exists, looks good"
    else
        echo "ERROR: The IOR file doesn't exist in /opt/ericsson/cadm/conf/masterserver.iors/ on $OMSAS_SERVER, exiting..."
        exit_routine 45
    fi

    echo -n "INFO: fetching SubNetwork name from the $SERVER CS please wait... "
	SubNetwork=`ssh -n $SERVER 2>/dev/null "$CSTEST -s Seg_masterservice_CS lt ManagedElement|head -1"| awk -F, '{ print $1 }' | awk -F= '{ print $2 }'`
	echo "$SubNetwork"

	# get first node of first simulation
    IE_IP=""
    IE_NODE=""
    IE_NETSIM=""
    echo -n "INFO: Need a node that is imported on the master to create pem please wait..."
	
	local firstNode=(`getFirstNode`)
	local nodeNetsim=${firstNode[0]}
	local nodeName=${firstNode[2]}
	local nodeIp=${firstNode[3]}

	echo "node=$nodeName ip=$nodeIp on netsimbox $nodeNetsim"
	
    echo -n "QUERY: Please enter a node name to try to initial enroll ($nodeName) :"
    read IE_NODE

    if [[ "$IE_NODE" == "" ]]
    then
        IE_NODE="$nodeName"
    fi

    echo -n "QUERY: Please enter $nodeName ip ($nodeIp) :"
    read IE_IP

    if [[ "$IE_IP" == "" ]]
    then
        IE_IP="$nodeIp"
    fi

    echo -n "QUERY: Please enter netsimserver of $nodeName ($nodeNetsim) :"
    read IE_NETSIM

    if [[ "$IE_NETSIM" == "" ]]
    then
        IE_NETSIM="$nodeNetsim"
    fi

    # since we can rollout sl3 without having to be able to cello_ping the node
    # we just check that the ip exists on the masterserver
    # also we dont need a working DDC package this way
    
	echo -n "INFO: checking that ip on netsimbox is same as on masterserver please wait..."
	IE_IP_FROM_MASTER=`getNodeIpsFromMasterOnrm.sh $SERVER $IE_NODE|head -1|awk '{print $2}'`
    if [[ "$IE_IP_FROM_MASTER" == "$IE_IP" ]]
    then
        echo " OK"
    else
    	echo " failed!"
    	echo "ERROR: IE on master for $IE_NODE on netsim is $IE_IP but on master its $IE_IP_FROM_MASTER"
		if not_sure_to_continue
		then
		    exit_routine 24
		fi	
    fi

	echo "INFO: creating pem with omsas:\"$OMSAS_SERVER\" caas user:\"$CAAS_USER\" node:\"$IE_NODE\" node ip:\"$IE_IP\" on \"$IE_NETSIM\""
  
    # Clean up existing pems on this netsim
    echo "INFO: Cleaning up any old ie pems generated towards $IE_NODE on $IE_NETSIM"
    $RSH $IE_NETSIM "rm -rf /netsim/netsim_dbdir/simdir/netsim/netsimdir/*/$IE_NODE/db/corbacreds"

    # Get the name of the master server as known by the omsas
    OSS_NAME=`$SSH $OMSAS_SERVER "ls /opt/ericsson/cadm/conf/masterserver.iors/ | grep -v core"`

    # Do initial enrollment
    echo "INFO: Attempting initial enrollment using command below"
    INIT_ENROLL_COMMAND="caasAdmin init_enroll $OSS_NAME:$IE_NODE"
    echo "INFO: $INIT_ENROLL_COMMAND"
    $SSH root@${OMSAS_SERVER} "su - $CAAS_USER -c \"$INIT_ENROLL_COMMAND\""
    JOB_IDS=`$SSH root@${OMSAS_SERVER} "su - $CAAS_USER -c \"caasAdmin list jobs\"" |grep -v "Sun Microsystems"`
    echo "INFO: Jobs output is below"
    echo "$JOB_IDS"
    LAST_JOB_ID=`echo "$JOB_IDS" | grep init | tail -1 | awk '{print $1}'|sed 's/init//'`
    echo "INFO: Last Job ID Is $LAST_JOB_ID"

    TRY_NO=1
    IE_SUCCEEDED="no"

    while [[ $TRY_NO -le 5 ]]
    do
        # Check are the credentials there from initial enrollment
        echo "======================================================="
        echo "INFO: Lets check did the ie pems get created on the netsim $IE_NETSIM, attempt number $TRY_NO"
        PEMS_CHECK_OUTPUT=`$RSH $IE_NETSIM "ls /netsim/netsim_dbdir/simdir/netsim/netsimdir/*/$IE_NODE/db/corbacreds/ 2> /dev/null"`

        if [[ `echo "$PEMS_CHECK_OUTPUT" | grep pem` ]]
        then
            echo "INFO: The pems got created!"
            #---------------------
            # Clean up existing pems on atrclin3
            echo "INFO: Deleting any existing pems from atrclin3"
            rm -rf subscripts/security/$SECURITY
            echo "INFO: Copying the IE pems from $IE_NETSIM to subscripts/security/${SECURITY}"
            mkdir -p subscripts/security/${SECURITY}
            $RCP root@${IE_NETSIM}:/netsim/netsim_dbdir/simdir/netsim/netsimdir/*/$IE_NODE/db/corbacreds/* subscripts/security/${SECURITY}/
            cd subscripts/security/${SECURITY}/
            mv privkey.pem key.pem
            mv cert.pem certs.pem
            mv cacert.pem cacerts.pem
            # Need to update this to save as correct filenames
            IE_SUCCEEDED="yes"
            break
        else
            TRY_NO=$(( $TRY_NO+1 ))
            echo "WARNING: The ie pems didn't seem to get created (yet) on the netsim, see job status below"
            echo "======================================================="
            $SSH root@${OMSAS_SERVER} "su - $CAAS_USER -c \"caasAdmin describe job $LAST_JOB_ID\"" | grep -v "Sun Microsystems"
            echo "======================================================="
            echo "INFO: Waiting another 20 seconds before trying again..."
            sleep 20
        fi
    done

    # Report whether IE worked or not
    if [[ "$IE_SUCCEEDED" != "yes" ]]
    then
        echo "ERROR: The ie pems didn't seem to get created on the netsim after 3 minutes, please try initial enrollment manually"
        exit_routine 47
    fi
}

email_log ()
{
    LOG_CONTENTS=`cat $SCRIPT_LOGFILE`
    LOG_CONTENTS_SUMMARY=`cat $SCRIPT_LOGFILE | grep -v "Cleanup complete" | grep -v "Cleaning"| grep -v Unmounting | grep -v atrclin3 | grep -v "Exiting script" | grep -v "exports" | grep -v "mountpoints" | grep -v "is a Linux server" | grep -v "Checking rsh" | grep -v "trusts me" | grep -v "is Linux" | grep -v "write access" | grep -v "Pinging" | grep -v "netsim list" | grep -v "is alive" | grep -v "####" | grep -v "Import logs" | grep -v arne_dump | grep -v umount | grep -vi "Config File" | grep -vi email| tail -5`
    EMAIL_ADDRESSES=`echo "$EMAIL_ADDRESS" | sed 's/,/\n/g'`

    echo "$EMAIL_ADDRESSES" | while read ADDRESS
do
    SCRIPT_LOGFILE_SHORT=`echo $SCRIPT_LOGFILE | awk -F/ '{print $8}'`
    if [[ `echo $ADDRESS | grep sms.ericsson.se` ]]
    then
        echo "INFO: Sending short format notification to $ADDRESS"
        TOSEND="$LOG_CONTENTS_SUMMARY"
    else
        echo "INFO: Sending email notification to $ADDRESS"
        TOSEND="$LOG_CONTENTS"
    fi
    /usr/sbin/sendmail -oi -t << "    EOF"
    From: noreply@ericsson.com
    To:$ADDRESS
    Subject: run.sh script completed - Log:$SCRIPT_LOGFILE_SHORT - $0 $ALL_COMMAND_ARGUMENTS
    $TOSEND
    EOF
done
}

setup_sl3_complete()
{
    setup_sl3_phase1
    initial_enrollment
    setup_sl3_phase2 y
}

not_sure_to_continue(){

    echo -n " sure you want to continue? (y/n): "
    while true
    do
    	read CONTINUE
	    if [[ "$CONTINUE" == "y" ]] 
    	then
    		return 1
    	else
    		return 0
    	fi
    done
}

arne_import()
{
    ssh_connection
    local importScript=support/arne_import_v2.002.sh
    local remoteImportScript=/home/nmsadm/tep/arne_import_v2.002.sh
	local userName=root
	    
    echo "INFO: Uploading arne_import.sh to $remoteImportScript"
    $SSH ${SERVER} "rm -f $remoteImportScript"
    $SCP $importScript  nmsadm@${SERVER}:$remoteImportScript > /dev/null  2>&1
    $SSH ${SERVER} "chmod 755 $remoteImportScript"

    echo -n "QUERY: Do you want to enable ARNE rules, (ARNEServer, ONRM_CS and MAF mc's) level 8 tracing? (y/[n]): "
    read TRACING_ANS

    echo -n "QUERY: Do you want to offline MAF (if its on) for the duration of the import (this offlines it twice to make sure its off)? ([y]/n): "
    read MAF_ANS

    if [[ "$MAF_ANS" == "y" ]]
    then
        echo -n "QUERY: Do you want to reonline MAF and do the start adjust after the import? (y/[n]): "
        read MAF_ONLINE_ANS
    fi
    echo -n "QUERY: Do you want to try to brute force the import in, in the event of a failure, ie restart ARNE_SERVER, ONRM_CS and MAF mc's and try again? (y/[n]): "
    read BRUTE_ANS

	while importActiveOnMaster.sh $SERVER
	do
		echo "WARNING: there is an import already active on the master waiting until its finished!"
		sleep 5
	done

    if [[ "$MAF_ANS" == "y" ]]
    then
        echo "INFO: Offlining MAF (twice) to make sure it goes offline"
        $SSH ${userName}@${SERVER} "/opt/ericsson/nms_cif_sm/bin/smtool offline MAF -reason=other -reasontext=ARNE_Import_Workaround;/opt/ericsson/nms_cif_sm/bin/smtool prog;/opt/ericsson/nms_cif_sm/bin/smtool online MAF;/opt/ericsson/nms_cif_sm/bin/smtool prog;/opt/ericsson/nms_cif_sm/bin/smtool offline MAF -reason=other -reasontext=ARNE_Import_Workaround;/opt/ericsson/nms_cif_sm/bin/smtool prog"
    fi

    if [[ "$TRACING_ANS" == "y" ]]
    then
        arne_tracing
    fi

    #~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    echo "INFO: Attempting to import the ARNE xml files on $SERVER"
	   
    if [ -n "$ROLLOUT" ] && [ -n "$NODEFILTER" ]
    then
        $SSH ${userName}@${SERVER} "$remoteImportScript -g '$NODEFILTER' -r '$ROLLOUT'  -b '$BRUTE_ANS' -t '$TRACING_ANS'"

    elif [ -n "$ROLLOUT" ]
    then
        $SSH ${userName}@${SERVER} "$remoteImportScript -r '$ROLLOUT'  -b '$BRUTE_ANS' -t $TRACING_ANS"
    elif [[ -n "$NODEFILTER" ]]
    then
        $SSH ${userName}@${SERVER} "$remoteImportScript -g '$NODEFILTER'  -b '$BRUTE_ANS' -t '$TRACING_ANS'"

    else
        $SSH ${userName}@${SERVER} "$remoteImportScript -b '$BRUTE_ANS' -t '$TRACING_ANS'"

    fi

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # Stop arne tracing
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    if [[ "$TRACING_ANS" == "y" ]]
    then
        arne_tracing_stop
    fi

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	
    if [[ "$MAF_ONLINE_ANS" == "y" ]]
    then
    	echo "INFO: starting startAdjust in 5 seconds"
    	sleep 5
        start_adjust_maf
    fi
    echo "NOTICE: If import was sucessful please run -f arne_dump"

}

arne_delete()
{
	local ME="arne_delete()"
	message $DEBUG "DEBUG $ME: *** arne_delte_nodes: deleting selected nodes $NODEFILTER\n"
	local tepDir=/home/nmsadm/tep
	message $DEBUG "DEBUG $ME: looking for xmls in $tepDir\n"

	# we only want to get xmls as requested:
	filterNodes=`echo "$NODEFILTER"|tr " " "|"`
    filterNetsims=`echo "$NETSIMSERVERLIST"|tr " " "|"`
	listXmls=`ssh -nx $SERVER 2>/dev/null ls -1 $tepDir/*delete.xml|egrep "$filterNodes"|egrep "$filterNetsims"`

	echo "$listXmls"
	echo -n "QUERY: do you want to delete all of above xmls? (y/n):"
	read goAhead

	if [[ $goAhead == "n"  || $goAhead == "N" ]]
	then
		echo "exiting"
		return
	fi

	echo -n "QUERY: shell I offline MAF? ([y]/n)";
	read offlineMaf

	echo -n "QUERY: shell I turn on ARNE tracing? (y/[n])";
	read arneTracing

	if [[ $offlineMaf == "y" || $offlineMaf == "Y" ]]
	then
		ssh -nx $SERVER 2>/dev/null /opt/ericsson/nms_cif_sm/bin/smtool offline MAF -reason=\"other\" -reasontext=\"TEP Arne import\"
		ssh -nx $SERVER 2>/dev/null /opt/ericsson/nms_cif_sm/bin/smtool prog

		sleep 3

		if ! ssh -nx $SERVER 2>/dev/null /opt/ericsson/nms_cif_sm/bin/smtool -l|grep MAF|grep online
		then
			echo "ERROR: MAF did not go offline"
			return
		fi
	fi

	if [[ $arneTracing == "y" || $arneTracing == "Y" ]]
	then
		arne_tracing
	fi

	while importActiveOnMaster.sh $SERVER
	do
		echo "WARNING: there is an import already active on the master waiting until its finished!"
		sleep 5
	done

	for xmlFile in `echo $listXmls`
	do
		echo "deleting xml $xmlFile on $SERVER"
		ssh -nx $SERVER 2>/dev/null /opt/ericsson/arne/bin/import.sh -import -i_nau -f $xmlFile
	done

	if [[ $arneTracing == "y" || $arneTracing == "Y" ]]
	then
		arne_tracing_stop
	fi
	echo "INFO: finished"
	return 0
}

arne_tracing()
{
    echo "INFO: Setting on tracing on $SERVER"
    $SCP support/arne_tracing.sh  nmsadm@${SERVER}:/home/nmsadm/tep > /dev/null  2>&1
    $SCP support/arne_tracing_backup.sh  nmsadm@${SERVER}:/home/nmsadm/tep > /dev/null  2>&1
    $SSH nmsadm@${SERVER} "chmod 755 /home/nmsadm/tep/arne_tracing.sh; /home/nmsadm/tep/arne_tracing.sh "
}

arne_tracing_stop()
{
    $SCP support/arne_tracing_stop.sh  nmsadm@${SERVER}:/home/nmsadm/tep > /dev/null  2>&1
    $SSH nmsadm@${SERVER} "chmod 755 /home/nmsadm/tep/arne_tracing.sh; /home/nmsadm/tep/arne_tracing_stop.sh "
}

verify_MAF()
{
    echo "INFO: Verifying ONRM and SEG_CS"
    MAF_ADJUST=`$SSH nmsadm@${SERVER} "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s Seg_masterservice_CS lt ManagedElement | egrep -i '(rnc|lte)' | wc -l"`
    ONRM_CONTENTS=`$SSH nmsadm@${SERVER} "/opt/ericsson/nms_cif_cs/etc/unsupported/bin/cstest -s ONRM_CS lt ManagedElement  | egrep -i '(rnc|lte)' | wc -l"`
    if [[ $MAF_ADJUST == "0" ]]
    then
        echo "WARNING: startAdjust seems to have been Unsucessfull"
    else
        echo "INFO: Number of RNC|RXI|RBS|ERBS nodes synced in MAF is $MAF_ADJUST"
        echo "INFO: Number of RNC|RXI|RBS|ERBS nodes in ONRM is       $ONRM_CONTENTS"
    fi
}

start_adjust_maf()
{
    ssh_connection
    echo "INFO: launching startAjustOnMaster.sh date=${formatedDate}"
	if ! startAdjustOnMaster.sh $SERVER
	then
		echo "ERROR: with StartAdjust date=${formatedDate}"
		return 1
	fi
    echo "INFO: startAdjust stoped/finished ${formatedDate}"
	echo "INFO: Verifying if MAF adjust ran successfully"
	verify_MAF
}

arne_dump()
{
    date=`date`
    formated_date=`echo $date  | awk '{print $2 "_" $3 "_" $NF}'`

    ssh_connection
    echo "INFO: Dumping the CS on $SERVER"
    $SCP support/arne_dump.sh  nmsadm@${SERVER}:/home/nmsadm/tep > /dev/null  2>&1

    $SSH nmsadm@${SERVER} "chmod 755 /home/nmsadm/tep/arne_dump.sh; /home/nmsadm/tep/arne_dump.sh "
    UPDATEBANNER="The CS dump is located in /home/nmsadm/tep/CS_dump_${formated_date}.log"
}

check_pm()
{
    for host in `echo $NETSIMSERVERLIST`
    do
        for SIM in `getSimulationListForHostFiltered "$host"`
        do
            #Retrieve netsim MO 	
            echo "INFO: Running pm check for $SIM"
            performanceDataPath=`$RSH -l netsim $host "/mnt/support/check_pm.sh $SIM $host" | grep performanceDataPath= | grep netsim_users`

            #Check if performanceDataPath is poing to netsim_users
            if [[ $performanceDataPath == "" ]]
            then
                echo "WARNING: PM for $SIM on $host does not appear to be setup correctly"
            else
                echo "INFO: PM for $SIM on $host appears to be setup correctly"
            fi
        done
    done
}

### Function: restart_arne_mcs ###
#
#   Cold Restarts the arne related mcs
#
# Arguments:
#       none
# Return Values:
#       none
restart_arne_mcs()
{

    ARNE_MCS="ARNE MAF ONRM"
    RESTART_COMMAND="/opt/ericsson/nms_cif_sm/bin/smtool -coldrestart $ARNE_MCS -reason=other -reasontext='For ARNE Import';/opt/ericsson/nms_cif_sm/bin/smtool prog"

    ssh_connection
    echo "INFO: Cold Restarting the arne related MC's, $ARNE_MCS"
    echo "INFO: Command $RESTART_COMMAND"

    $SSH nmsadm@${SERVER} "$RESTART_COMMAND"

    echo "INFO: Cold Restart completed"
}

sim_summary_wran()
{
    #Summary of sims

    for host in `echo $NETSIMSERVERLIST`
    do
    	#helge dead code this SIMLIST here probably not needed
        SIMLIST=`getSimulationListForHostFiltered "$host"`
        
        saved_date_dir=`ls -1rt ./savedconfigs/$host/ | tail -n 1`

        ############## Available Subnets  ##############

        TOTALIPS=`$RSH $host "$IFCONFIG -a | $GREP inet | $WC -l"`
        TOTALVIPS=`expr $TOTALIPS - 2`

        #echo "INFO: Total IP address available on $host is $TOTALIPS"
        IPREQD=0

        IPSUBS=`$RSH $host "/mnt/support/list_ip_subs.sh $host" | $GREP -vi Display`
        IPSUBSARRAY=()
        COUNT=1

        for ipsub in `echo $IPSUBS`
        do
            IPSUBSARRAY[$COUNT]=$ipsub
	        for SIM in `getSimulationListForHostFiltered "$host"`
            do
                ARNE_FILE=`ls ./savedconfigs/$host/${saved_date_dir}/arnefiles/import-v2*create*xml | grep "$SIM"`

                if [[ $ARNE_FILE != "" ]]
                then

                    SUBNET_CHECK=`cat $ARNE_FILE | $GREP "<ipAddress ip"  | grep $ipsub`
                    MIM_VERSION=`cat $ARNE_FILE | $GREP "<neMIMVersion" | $AWK -F"\"v" '{print $2}' | $AWK -F"\"" '{print $1}' | head -n 1`
                    if [[ $SUBNET_CHECK != "" ]]
                    then
                        echo "INFO: $SIM --> MimType $MIM_VERSION Subnet${COUNT}: $ipsub $host "
                    fi
                else
                    echo "WARNING: No Arne file found for $SIM..bypassing"	
                fi
            done
            COUNT=`expr $COUNT + 1`
        done
    done
}

last_run_command()
{
    # ********************************************************************
    # Log commands that are run
    # ********************************************************************

    date=`date`
    formated_date=`echo $date  | awk '{print $2 "_" $3 "_" $NF}'`
    time_now=`echo $date | awk '{print $4}'`
    logging_dir="/home/rollout/logs/${USERID}"
    if [ ! -d $logging_dir ]
    then
        $MKDIR -p $logging_dir
        chown rollout $logging_dir
    fi
    if [[ $USERID == "" ]]
    then
        echo "WARNING: Problem logging run.sh arguments"
    else
        LAST_COMMAND_RUN="$0 $ALL_COMMAND_ARGUMENTS"
        echo "$time_now    $LAST_COMMAND_RUN">>${logging_dir}/${formated_date}.log
        #echo "INFO: Last Command Logged to ${logging_dir}/${formated_date}.log $LAST_COMMAND_RUN"
    fi

    # ********************************************************************
}

history()
{
    # ********************************************************************
    # commands that were run
    # ********************************************************************

    date=`date`
    formated_date=`echo $date  | awk '{print $2 "_" $3 "_" $NF}'`
    time_now=`echo $date | awk '{print $4}'`
    logging_dir="/home/rollout/logs/${USERID}"
    if [[ $USERID == "" ]]
    then
        echo "ERROR: USERID required -u "
        exit 1
    else
        echo "INFO: History for $USERID (limt 10 log files)"
        $LS -rt ${logging_dir}/* | tail -n 10 | while read line
    	do
        	echo "FILE: $line"
        	$CAT $line
    	done
	fi
}

### Function: exit_routine ###
#
#   Perform exiting routine
#
# Arguments:
#       none
# Return Values:
#       none

exit_routine()
{
	# if any function used required netsim /mnt mount unmount it
    
    if $isScriptsDirectoryMounted
    then 
        echo -n "INFO: unmounting on all hosts"
        with_each_netsim_server umount_scripts_directory_on_host
		if [[ "$?" -gt "0" ]]
		then
			echo " failed!"
			echo "ERROR: while unmounting at least one host"
			exit $1;
		else
			isScriptsDirectoryMounted=false
			echo " OK"
			exit 0;
		fi	
   	else
    	echo "INFO: no need to unmount netsims for functions $FUNCTIONS"
   		exit 0;
    fi
}

sim_patch_rollout()
{
    if [ -z "$PATCH_LIST" ]
    then
        echo "ERROR: You must give a list of patch names using the -p option"
        exit_routine 24
    fi

    start_all

    for host in `echo $NETSIMSERVERLIST`
    do
        for SIMNAME in `getSimulationListForHostFiltered "$host"`
        do
            # Parallelized code below
            ###################################
            LOG_FILE=/tmp/${host}_$SIMNAME.$BASHPID.log
            PARALLEL_STATUS_HEADER="Rolling Out Patches"
            PARALLEL_STATUS_STRING="Rolling Out Patches for SIM $SIMNAME on $host"
            # SHOW_STATUS_UPDATES="NO"
            # SHOW_OUTPUT_BORDERS="NO"
            ###################################
            (
            (
            for PATCH in `echo $PATCH_LIST`
            do
                echo "Running patch $PATCH"
                # do something here
                #sleep 30
            done
            ) > $LOG_FILE 2>&1;parallel_finish
            ) & set_parallel_variables
        done
    done
    parallel_wait
}

cleanup_pipe()
{
    # Remove the temporary named pipe used to log output to file
    rm $npipe > /dev/null 2>&1
}

rollout(){
	if [[ $ROLLOUT == "GRAN" || $ROLLOUT == "gran" ]] # -r option makes it a GRAN rollout
	then
	    echo "ERROR: rollout please use : -f rollout_gran"
        exit_routine 24
	fi
	check_netsim_shell
	delete_sims
    make_ports
    get_sims
    set_ips
    deploy_amos_and_c  
    # deloy_amos and c planned to fade out in R25B
    # NR:2130 - Improvement Requirement: Deploy C (license) during install by linking to /c folder
	# http://netsim.lmera.ericsson.se/nr2130  
   
    #NR:2131 - Improvement Requirement: Deploy amos (userdefined scripts)
    #http://netsim.lmera.ericsson.se/nr2131

    start_all
    setup_variables     #these vars need to be moved into the simulation design
    create_users 
    copy_config_file_to_netsim # required for AMOS PM FM
    generate_ip_map	           # required for AMOS
	upload_ip_map              # upload amos file
    post_scripts
    login_banner
    save_config 
	show_sims
    exit_routine 0
}

rollout_gran(){
	message $INFO "INFO: rollout_gran()"
	check_netsim_shell
    delete_sims
    get_sims_gran
    make_ports_gran
    make_destination
    rename_all
    generateNodeFiles
    set_ips_gran
    set_cpus
    start_all
    lanswitch_acl
    check_ssh_setup
    create_users_gran
}

rollout_gran_siu(){
	message $DEBUG "DEBUG: rollout_gran_siu()"
	check_netsim_shell
    delete_sims
    get_sims_gran
    make_ports_gran
    make_destination
    rename_all
	set_destination_siu
	set_ips_gran_siu
    set_cpus
    start_all
    lanswitch_acl
    check_ssh_setup
    create_users_gran
}

functions_exist() {
	local methods=$1
	local name;
	
	for name in "$methods";
	do
		if ! type $name &>/dev/null;
		then
			echo "**************************************************"		
			echo "ERROR: function $name does not seem to exist typo?"
			echo ""
			echo "ERROR: might want to try one of below?"
			name=`echo $name|tr "_" "|"`
   	    	usage_msg|egrep -i "$name"

			return 1;
		fi
	done
	return 0;
}

#######
#MAIN##
#######

if [[ -z $2 ]] #there should be at least two arguments
then
	echo "ERROR: there should be at least two arguments please look at the help"
	usage_msg
	exit 1
fi

while getopts "f:s:n:a:d:c:i:o:u:g:p:r:z:e:h:v:x:" arg
do
    case $arg in
        d) DEPLOYMENT="$OPTARG"
            ;;
        s) SERVER="$OPTARG"    
            ;;
        n) NETSIMSERVER="$OPTARG"    
            ;;
        a) SECURITY="$OPTARG"
            ;;
        c) CONFIGFILEARG="$OPTARG"
            ;;
        f) FUNCTIONS="$OPTARG"
            ;;
        i) INTERACTION="$OPTARG"
            ;;
        o) OFFSET="$OPTARG"
            ;;
        x) STARTIP="$OPTARG"
            ;;
        u) USERID="$OPTARG"
            ;;
        g) NODEFILTER="$OPTARG"
            ;;
        p) PATCH_LIST="$OPTARG"
            ;;
        r) ROLLOUT="$OPTARG"
            ;;
        z) NEWER_FUNCTIONS="$OPTARG"
            ;;
        e) EMAIL_ADDRESS="$OPTARG"
            ;;
        v) VERBOSE="$OPTARG"
            ;;
        h) GET_HELP="$OPTARG"
	       	if [[ "$GET_HELP" == "" ]]
        	then
    			usage_msg
    		else
	        	echo "DEBUG:help searching for function in help $GET_HELP"
    	    	usage_msg|grep -i "$GET_HELP"
    		fi
        	exit 0
        	;;
        \?) usage_msg
            exit 1
            ;;
    esac
done

check_config_file
load_config
check_args
get_netsim_servers

#Source GRAN functions
if [[ $ROLLOUT == "GRAN" || $ROLLOUT == "gran" || $FUNCTIONS =~ "gran" ]] # -r option makes it a GRAN rollout
then
	message 0 "INFO: sourcing GRAN functions..."
	source /var/www/html/scripts/automation_wran/gran.sh
	GRAN_SCRIPT=/var/www/html/scripts/automation_wran/gran.sh
	message 0 " done\n"
	message $DEBUG "DEBUG: setting ROLLOUT to uppercase GRAN\n"
	ROLLOUT="GRAN"
fi

#make newer functions (parallel) default can be overwritten with -z n
if [[ -z "$NEWER_FUNCTIONS" ]]
then
	NEWER_FUNCTIONS=y
fi

trap ctrl_c INT
trap cleanup_pipe EXIT TERM

# store command for user alias last command function
if [[ $FUNCTIONS != "history" ]]
then
    last_run_command
fi

#exit if the -f function does not exist in rollout.sh or gran.sh
if ! functions_exist "$FUNCTIONS"
then
	exit 1
fi

# legacy support let the user know to use rollouts as functions
if [[ $FUNCTIONS == "" ]]
then
	if [[ $ROLLOUT == "GRAN" ]] # -r option makes it a GRAN rollout
	then
	    echo -n "ERROR: rollout please use : -f rollout_gran"
	else
	    echo -n "ERROR: rollout please use : -f rollout"
	fi	
	echo " use -h for help"
	exit 1
fi

#List of functions that dont need netsim boxes to mount:
FUNCTION_NO_NETSIM_MOUNT="create_pem_sl2 
cstest_ftp
cstest_me
cello_ping
ssh_connection
arne_validate
arne_import
cstest_all
check_mims
arne_delete
restart_arne_mcs
start_adjust_maf
verify_MAF
check_master
check_master_ips
last_run_command
check_sftp
check_onrm_cs
check_seg_cs
check_omsas
check_nead_status_on_master
check_os_details
generate_ip_map
"

#List of functions that dont need a masterserver:
FUNCTION_NO_MASTER="show_started 
show_security_status 
show_subnets_wran start_netsim 
login_banner 
install_netsim 
install_patch 
stop_netsim
start_netsim
restart_netsim
restart_netsim_gui  
setup_rsh 
check_installed_patches 
check_netsim_version
setup_internal_ssh
check_os_details
rollout
generate_ip_map
start_all
copy_config_file_to_netsim
get_sims
check_netsim_shell
show_sims
setup_netsim_ftp
sim_summary_wran
netsim_dance
netsim_dance_root
save_config
"
#grep function needs netsimserver or master can only whitelist
FUNCTIONS_FILTER=`echo "$FUNCTIONS"|tr " " "|"`
FUNCTION_CHECKER_NO_NETSIM_MOUNT=`echo -e "$FUNCTION_NO_NETSIM_MOUNT" | egrep "$FUNCTIONS_FILTER"` 
FUNCTION_CHECKER_NO_MASTER=`echo -e "$FUNCTION_NO_MASTER" | egrep "$FUNCTIONS_FILTER"` 

message $DEBUG "$ME: FUNCTION_CHECKER_NO_NETSIM=$FUNCTION_CHECKER_NO_NETSIM\n"
message $DEBUG "$ME: FUNCTION_CHECKER_NO_MASTER=$FUNCTION_CHECKER_NO_MASTER\n"

if [[ -z "$FUNCTION_CHECKER_NO_MASTER" ]]
then
	message $DEBUG "$ME:function needs passwordless ssh to Masterserver\n"
    ssh_connection
fi

if [[ -z "$FUNCTION_CHECKER_NO_NETSIM_MOUNT" ]]
then
	message $DEBUG "$ME: function on netsim server\n"
    mount_scripts_directory
fi

if [ `echo "$FUNCTIONS" | wc -w` -gt 1 ] 
then
	echo "DEBUG: more then one function could be both master and netsim"
    ssh_connection
	get_netsim_servers
    mount_scripts_directory
fi

if [ -n "$FUNCTIONS" ]
then
    for FUNCTION in `echo "$FUNCTIONS"`
    do
    	time $FUNCTION
    done
	
	if [[ $FUNCTION_CHECKER_NO_NETSIM == "" ]]
	then
	    update_login_banner
	fi
    exit_routine 0
fi

echo "ERROR: something went wrong in the main body of the script"
exit 1

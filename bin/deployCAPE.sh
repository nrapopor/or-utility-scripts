#!/bin/bash
#Functions
function required_parameter() {
    #Usage  required_parameter <arg name> <arg value>
    if [ -z "${2}" ]; then
        /bin/echo 
        /bin/echo -e "######################################"
        /bin/echo -e ERROR:\\t\"$1\" is a required parameter
        /bin/echo -e "######################################"
        usage;
    fi
}
function usage() {
    /bin/echo -e  ################################################ USAGE ########################################
    /bin/echo -e  usage:\\t${SCRIPT_NAME}\\t \{-c\[=\]\|--cape\[=\]\} \<cape name\> [\{-h\|-help\|--help\] 
    /bin/echo 	
    /bin/echo -e Description 	
    /bin/echo -e \\tThis script will permanently add a cape to the BBB initialization 	
    /bin/echo -e	
    /bin/echo -e Parameters 	
    /bin/echo -e \\tcape name\\trequired parameter, the name of the cape to add to the init			
    /bin/echo -e
    /bin/echo -e \\t-h\|-help\|--help\\t\\toptional parameter, display this usage message and "exit"
    /bin/echo -e
    exit 1
}
while [[ $# -gt 0 ]]
do
	key="$1"
	#echo key=$key

	case $key in
	    -c=*|--cape=*)
	    NEW_CAPE="${key#*=}"
	    shift # past argument=value
	    ;;
	    -c=*|--cape=*)
	    NEW_CAPE="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -h|--help|-help)
	    usage
	    exit 0
	    ;;
	    *)
		# unknown option
		echo Unknown Option: $key
		usage
	    ;;
	esac
done
required_parameter cape "${NEW_CAPE}"

. /etc/default/capemgr
if [ "${CAPE/${NEW_CAPE}}" == "${CAPE}" ]; then
    if [ ! -z "${CAPE}" ]; then 
        CAPE=${CAPE},${NEW_CAPE}
    else 
        CAPE=${NEW_CAPE} 
    fi
    sudo echo CAPE=${CAPE} | sudo tee -a /etc/default/capemgr 
fi
echo default capes: ${cat /etc/default/capemgr}

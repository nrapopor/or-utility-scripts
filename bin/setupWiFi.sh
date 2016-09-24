#!/bin/bash 
SCRIPT_NAME=$(basename $0)
DNS_NAMES_DEFAULT=8.8.8.8,8.8.4.4
IP_CONFIG_DEFAULT=

DNS_NAMES=${DNS_NAMES_DEFAULT}
IP_CONFIG=${IP_CONFIG_DEFAULT}


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
    /bin/echo -e  usage:\\t${SCRIPT_NAME}\\t\{-s\[=\]\|--service\[=\]\} \<service\> \{-n\[=\]\|--name\[=\]\} \<SSID name\>
    /bin/echo -e \\t\\t\\t\{-p\[=\]\|--passphrase\[=\]\} \<passphrase\> [\{-i\[=\]\|--ipv4\[=\]\} \<static ip\>]
    /bin/echo -e \\t\\t\\t[\{-d\[=\]\|--nameservers\[=\]\} \<dns servers\>] [\{-l\|--list\}] [\{-h\|--help\}]
    /bin/echo 	
    /bin/echo -e Description 	
    /bin/echo -e \\tThis script configure will the \"connman\" service with WPA2 secured wifi service
    /bin/echo -e  
    /bin/echo -e Parameters 	
    /bin/echo -e \\tservice\\t\\trequired parameter, the \"wifi_*_managed_psk\" name of the wifi service 
    /bin/echo -e \\t\\t\\tfrom \'connmanctl services\' command
    /bin/echo -e
    /bin/echo -e \\tSSID name\\trequired parameter, the SSID of the wifi service
    /bin/echo -e
    /bin/echo -e \\tpassphrase\\trequired parameter, the wpa2 passphrase of the wifi service 
    /bin/echo -e
    /bin/echo -e \\tstatic ip\\toptional parameter, the static ip configuration "for" this service 
    /bin/echo -e \\t\\t\\tDefault : ${IP_CONFIG_DEFAULT}
    /bin/echo -e \\t\\t\\tFormat  : \<ip\>/\<mask\>/\<gateway\>  Ex. 192.168.1.136/255.255.255.0/192.168.1.1
    /bin/echo -e
    /bin/echo -e \\tdns servers\\toptional parameter, the list \(comma delimited\) dns servers "for" 
    /bin/echo -e \\t\\t\\t this service 
    /bin/echo -e \\t\\t\\tDefault : ${DNS_NAMES_DEFAULT}
    /bin/echo -e
    /bin/echo -e \\t-l\|--list\\toptional parameter, display the list of available services and "exit"
    /bin/echo -e
    /bin/echo -e \\t-h\|--help\\toptional parameter, display this usage message and "exit"
    /bin/echo -e
    exit 1
}
while [[ $# -gt 0 ]]
do
	key="$1"
	#echo key=$key

	case $key in
	    -s=*|--service=*)
	    SERVICE_PSK_NAME="${key#*=}"
	    shift # past argument=value
	    ;;
	    -s|--service)
	    SERVICE_PSK_NAME="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -n=*|--name=*)
	    SSID_NAME="${key#*=}"
	    shift # past argument=value
	    ;;
	    -n|--name)
	    SSID_NAME="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -p=*|--passphrase=*)
	    PASSPHRASE="${key#*=}"
	    shift # past argument=value
	    ;;
	    -p|--passphrase)
	    PASSPHRASE="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -i=*|--ipv4=*)
	    IP_CONFIG="${key#*=}"
	    shift # past argument=value
	    ;;
	    -i|--ipv4)
	    IP_CONFIG="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -d=*|--nameservers=*)
	    DNS_NAMES="${key#*=}"
	    shift # past argument=value
	    ;;
	    -d|--nameservers)
	    DNS_NAMES="$2"
	    shift # past argument
	    shift # past value
	    ;;
	    -l|--list|-list)
	    connmanctl services
	    exit 0
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
required_parameter service "${SERVICE_PSK_NAME}"
required_parameter passphrase "${PASSPHRASE}"
required_parameter name "${SSID_NAME}"

if [ -z "${IP_CONFIG}" ]; then
    IPV4=EOF
    EOF=
else
    IPV4=IPv4=${IP_CONFIG}
    EOF=EOF
fi

cat << EOF | sudo tee -a /var/lib/connman/wifi.config 
[service_${SERVICE_PSK_NAME}]
Type=wifi
Security=psk
Name=nickhome
Passphrase=${PASSPHRASE}
Nameservers=${DNS_NAMES}
AutoConnect=true
Favorite=true
${IPV4}
${EOF}


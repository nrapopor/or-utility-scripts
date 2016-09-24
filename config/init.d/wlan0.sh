#!/bin/sh
### BEGIN INIT INFO
# Provides:
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start wifi wlan0 at boot time because for some reason it does not autostart
# Description:       just run wireless.
### END INIT INFO

is_running() {
    RUNNING=$(connmanctl technologies | grep /net/connman/technology/wifi -A 5 | grep Powered | tr -s ' ' | cut -f 4 -d ' ')
    [ "${RUNNING}" = "True" ] && return 0 || return 1 
}
is_connected() {
    CONNECTED=$(connmanctl technologies | grep /net/connman/technology/wifi -A 5 | grep Connected | tr -s ' ' | cut -f 4 -d ' ')
    [ "${CONNECTED}" = "True" ] && return 0 || return 1 
}


case "$1" in
    start)
    if is_running; then
        echo "WiFi Already started"
    else
        connmanctl enable wifi
    fi
    if is_connected; then
        echo "WiFi Already connected"
    else
        echo "Scanning wifi"
        connmanctl scan wifi
        SERVICE_NAME=$(connmanctl services | grep -E "\*A[^O].*wifi_" | tr -s ' ' | cut -d ' ' -f 3)
        echo "Connecting to ${SERVICE_NAME}"
        connmanctl connect ${SERVICE_NAME}
    fi
    ;;
    stop)
    is_running
    if is_running; then
        if is_connected; then
            connmanctl scan wifi
            SERVICE_NAME=$(connmanctl services | grep -E "\*AR.*wifi_" | tr -s ' ' | cut -d ' ' -f 3)
            if [ ! -z  "${SERVICE_NAME}" ]; then
                echo "Disconnecting from ${SERVICE_NAME}"
                connmanctl disconnect ${SERVICE_NAME}
            else
                echo "${SERVICE_NAME} Already disconnected"
            fi
        else
            echo "WiFi Already disconnected"
        fi
    else
        echo "WiFi Already stopped"
    fi
    ;;
    restart)
    $0 stop
    $0 start
    ;;
    status)
    if is_running; then
        if is_connected; then
            echo "Running and connected"
        else
            echo "Running and disconnected"
            exit 1
        fi
    else
        echo "Stopped"
        exit 1
    fi
    ;;
    *)
    echo "Usage: $0 {start|stop|restart|status}"
    exit 1
    ;;
esac

exit 0
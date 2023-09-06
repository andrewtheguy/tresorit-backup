#!/bin/bash
set -eou pipefail

SYNC_ONLY=${SYNC_ONLY:-false}

tresorit-cli status
echo "Starting tresorit cli…"
tresorit-cli start
tresorit-cli status

#echo "Disabling logging…"
#tresorit-cli logging --disable-log-sending
#tresorit-cli logging --disable-metrics
tresorit-cli logging --status

PID=`pgrep tresorit-daemon`

echo $PID

function finish {
    echo "asking to stop"
    #
    tresorit-cli stop

    status=""

    while [ "unreachable" != "$status" ]
    do
    echo "stopping"
        ps -ef
    status=$(tresorit-cli status -p | grep "Tresorit daemon:" | awk '{ print $3}')
    sleep 1
    done
}
trap finish EXIT


while [ -e /proc/$PID ]; do sleep 1; done


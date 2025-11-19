#!/bin/bash
# Written by Shannon B. Hill
# Description: Function to send a notification to the ntfy.krabs.me service

# Variables BEGIN --------------------------------------------------------------
vScript_Name="${0##*/}"
vScript_Working_Directory="$(pwd)"
vDate_Text_Display="$(date '+%m-%d-%Y')"
vDate_Name_Compatible="$(date '+%Y%m%d')"
vTime_Text_Display="$(date '+%r')"
vTime_Name_Compatible="$(date '+%H%M%S')"
vHostname="$(hostname)"
vHost_IP_Address="$(hostname -I | awk '{print $1}')"
vNTFY_Host="https://ntfy.krabs.me"
# Variables END ----------------------------------------------------------------

# FUNCTIONS BEGIN --------------------------------------------------------------
fNTFY ()
{
    # Usage: fNTFY <Topic> <Title> <Tags> <Priority> <Message>
    if [ -z ${1} ] || [ -z ${2} ] || [ -z ${3} ] || [ -z ${4} ] || [ -z ${5} ]
        then
            echo "ERROR: Missing parameter to fNTFY function"
        else
            curl -d "${5}" -H "Title: ${2}" -H "Priority: ${4}" -H "Tags: ${3}" ${vNTFY_Host}/${1}
    fi
}

fCleanLogs ()
{
    journalctl --rotate
    vVacuumTime="3d"
    journalctl --vacuum-time=${vVacuumTime}
}

fRemoveSnaps ()
{
    set -eu
    snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        snap remove "$snapname" --revision="$revision"
    done
}

fRemoveOldKernels ()
{
    IN_USE=$(uname -a | awk '{ print $3 }')
    echo "Your in use kernel is $IN_USE"

    OLD_KERNELS=$(
        dpkg --list |
            grep -v "$IN_USE" |
            grep -Ei 'linux-image|linux-headers|linux-modules' |
            awk '{ print $2 }'
    )
    if [ "1" == "1" ]; then
        for PACKAGE in $OLD_KERNELS; do
            yes | apt purge "$PACKAGE"
        done
    fi    
}

fAptClean ()
{
    apt -y autoremove
    apt -y clean
}
# FUNCTIONS END ----------------------------------------------------------------

# Actions BEGIN ----------------------------------------------------------------
fRemoveOldKernels
fCleanLogs
fRemoveSnaps
fAptClean
# Actions END ------------------------------------------------------------------

# Exit -------------------------------------------------------------------------
exit 0
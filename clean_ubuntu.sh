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
    vVacuumTime="3d"
    journalctl --vacuum-time=${vVacuumTime}
}

fAptClean ()
{
    apt-get auto-remove
    apt-get clean
}
# FUNCTIONS END ----------------------------------------------------------------

# Actions BEGIN ----------------------------------------------------------------
fCleanLogs
fAptClean
# Actions END ------------------------------------------------------------------

# Exit -------------------------------------------------------------------------
exit 0
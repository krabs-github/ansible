#!/bin/bash
# Written by Shannon B. Hill
# Description: Function to send a notification to the ntfy.krabs.me service

# Variables BEGIN --------------------------------------------------------------
vScript_Name="${0##*/}"
vScript_Working_Directory="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
vScript_Log_Directory="${vScript_Working_Directory}/logs"
vDate_Text_Display="$(date '+%m-%d-%Y')"
vDate_Name_Compatible="$(date '+%Y%m%d')"
vTime_Text_Display="$(date '+%r')"
vTime_Name_Compatible="$(date '+%H%M%S')"
vHostname="$(hostname)"
vHost_IP_Address="$(hostname -I | awk '{print $1}')"
vNTFY_Host="https://ntfy.krabs.me"
# Variables END ----------------------------------------------------------------

# FUNCTIONS BEGIN --------------------------------------------------------------
fMakeLogDirectory ()
{
    if [ ! -d "${vScript_Log_Directory}" ]
        then
            mkdir -p "${vScript_Log_Directory}"
    fi
}

fNTFY ()
{
    # Usage: fNTFY <Topic> <Title> <Tags> <Priority> <Message>
    # Priority: min, low, default, high, max or ugent
    if [ -z ${1} ] || [ -z ${2} ] || [ -z ${3} ] || [ -z ${4} ] || [ -z ${5} ]
        then
            echo "ERROR: Missing parameter to fNTFY function"
        else
            curl -d "${5}" -H "Title: ${2}" -H "Priority: ${4}" -H "Tags: ${3}" ${vNTFY_Host}/${1} &> /dev/null
    fi
}
# FUNCTIONS END ----------------------------------------------------------------

# Actions BEGIN ----------------------------------------------------------------
fMakeLogDirectory
# Check for Root (Required for dropping caches)
if [[ $EUID -ne 0 ]]; then
   echo "Error: This script must be run as root to clear memory caches."
   exit 1
fi
# Check MemCache and Clear
vLoad_Threshold=8
vMemLoadAvg=$(cat /proc/loadavg | awk '{print $3}')
vIsHighLoad=$(awk -v load="$vMemLoadAvg" -v limit="$vLoad_Threshold" 'BEGIN {print (load > limit) ? 1 : 0}')
if [ "$vIsHighLoad" -eq 1 ]
	then
		sync && echo 3 > /proc/sys/vm/drop_caches
        echo "${vDate_Text_Display} ${vTime_Text_Display} MemCache cleared. Load Average was ${vMemLoadAvg}" >> ${vScript_Log_Directory}/ClearMemCache.log
fi
# fNTFY "General" "Test Notification" "Test" "Normal" "This is a test notification from the fNTFY function"
# Actions END ------------------------------------------------------------------

# Exit -------------------------------------------------------------------------
exit 0
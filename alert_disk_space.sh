#!/bin/bash
vScript_Name="${0##*/}"
vScript_Working_Directory="$(echo $PWD)"
vScript_Log_File="${vScript_Working_Directory}/${vScript_Name}.log"
vDate_Text_Display="$(date '+%m-%d-%Y')"
vDate_Name_Compatible="$(date '+%Y%m%d')"
vTime_Text_Display="$(date '+%r')"
vTime_Name_Compatible="$(date '+%H%M%S')"
vHostname="$(hostname)"
vHost_IP_Address="$(hostname -I | awk '{print $1}')"
vNTFY_Host="https://ntfy.krabs.me"

# Usage: fNTFY <Topic> <Title> <Tags> <Priority> <Message>
fNTFY ()
{
    if [ -z ${1} ] || [ -z ${2} ] || [ -z ${3} ] || [ -z ${4} ] || [ -z ${5} ]
        then
            echo "ERROR: Missing parameter to fNTFY function"
        else
            curl -d "${5}" -H "Title: ${2}" -H "Priority: ${4}" -H "Tags: ${3}" ${vNTFY_Host}/${1}
    fi
}
#--------------------------------
vDisk_Usage_Above_90="$(df -h --output=pcent,used,source | grep 9[0-9]%)"
if [ ! "${vDisk_Usage_Above_90}" = "" ]
    then
        fNTFY "Alerts" "Disk Usage on ${vHostname} is >90%" "red_square,computer" "high" "${vDisk_Usage_Above_90}"
fi
#--------------------------------
touch ${vScript_Log_File}
exit 0
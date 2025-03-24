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
fSetSystemDNS ()
{
    if [ -s /etc/systemd/resolved.conf ]
        then
cat<<heredoc > /etc/systemd/resolved.conf
#  This file is part of systemd.
#
#  systemd is free software; you can redistribute it and/or modify it under the
#  terms of the GNU Lesser General Public License as published by the Free
#  Software Foundation; either version 2.1 of the License, or (at your option)
#  any later version.
#
# Entries in this file show the compile time defaults. Local configuration
# should be created by either modifying this file, or by creating "drop-ins" in
# the resolved.conf.d/ subdirectory. The latter is generally recommended.
# Defaults can be restored by simply deleting this file and all drop-ins.
#
# Use 'systemd-analyze cat-config systemd/resolved.conf' to display the full config.
#
# See resolved.conf(5) for details.

[Resolve]
# Some examples of DNS servers which may be used for DNS= and FallbackDNS=:
# Cloudflare: 1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com 2606:4700:4700::1111#cloudflare-dns.com 2606:4700:4700::1001#cloudflare-dns.com
# Google:     8.8.8.8#dns.google 8.8.4.4#dns.google 2001:4860:4860::8888#dns.google 2001:4860:4860::8844#dns.google
# Quad9:      9.9.9.9#dns.quad9.net 149.112.112.112#dns.quad9.net 2620:fe::fe#dns.quad9.net 2620:fe::9#dns.quad9.net
DNS=192.168.86.4
FallbackDNS=127.0.0.53
#Domains=
#DNSSEC=no
#DNSOverTLS=no
#MulticastDNS=no
#LLMNR=no
#Cache=no-negative
#CacheFromLocalhost=no
#DNSStubListener=yes
#DNSStubListenerExtra=
#ReadEtcHosts=yes
#ResolveUnicastSingleLabel=no
heredoc
        systemctl restart systemd-resolved
    fi
}
# FUNCTIONS END ----------------------------------------------------------------

# Actions BEGIN ----------------------------------------------------------------
fSetSystemDNS
# Actions END ------------------------------------------------------------------

# Exit -------------------------------------------------------------------------
exit 0
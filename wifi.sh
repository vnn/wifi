#!/bin/ksh

# Copyright (c) 2014, Vincent Tantardini
# All rights reserved.

# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
# 3. All advertising materials mentioning features or use of this software
#    must display the following acknowledgement:
#    This product includes software developed by the <organization>.
# 4. Neither the name of the <organization> nor the
#    names of its contributors may be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY <COPYRIGHT HOLDER> ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Wifi 0.1

# wifi is a simple command line tool designed to easily connect to a list of
# predefined access points and hotspots. To be able to use new access points,
# simply add a case in the "Access Points" section. The new network name should
# also be added to the list of avalaible networks.

version="0.1"
usage="usage: wifi [list] network_name"


################################################################################
# Configuration
################################################################################

# Interface & network names
interface=iwn0
set -s -A list nico boy droid free home sfr

# Paths
ifconfig="/sbin/ifconfig"
dhclient="/sbin/dhclient"
pfctl="/sbin/pfctl"
pfconf="/etc/pf.conf"
route="/sbin/route"
curl="/usr/local/bin/curl"

# Reload firewall
fwreload() {
    $pfctl -d  >/dev/null 2>&1;
    $pfctl -e -F all -f $pfconf >/dev/null 2>&1;
    if [ !$? -eq 0 ]; then
        echo "error: unable to setup network interface correctly"
        $ifconfig $interface down
        exit 1
    fi
}

# Generate a sorted list of avalaible networks
listCount=0
listLenght=${#list[@]}
while [ $listCount -lt $listLenght ]
do
    wifilist="${wifilist}$((listCount+1))) ${list[$listCount]} "
    listCount=$listCount+1
done

################################################################################
# Basic controls
################################################################################

if [[ $# -eq 0 ]]; then
    echo $usage
    exit 1
fi

if [ $2 ]; then
    echo "error: too much arguments"
    echo $usage
    exit 1
fi

################################################################################
# Access Points
################################################################################

case $1 in
    home)
	access_point="HOME_WIFI"
	password="000000000000000"
	static=1
	ip="192.168.0.109"
	netmask="255.255.255.0"
	broadcast="192.168.0.255"
	gateway="192.168.0.254"
	dns="nameserver 212.27.40.240\nnameserver 212.27.40.241"
	;;
    droid)
	access_point="mydroid"
	password="000000000000000"
	;;
    boy)
	access_point="NUMERICABLE-4ZI2"
	password="000000000000000"
	;;
    nico)
	access_point="nicobox"
	password="000000000000000"
	;;
    free)
	access_point="FreeWifi"
	username="1234567890"
	password="000000000000000"
	url="https://wifi.Free.fr/Auth"
	okmatch="CONNEXION AU SERVICE REUSSIE"
	hotspot="free"
	;;
    sfr)
	access_point="SFR WiFi FON"
	username="you@sfr.fr"
	password="000000000000000"
	url="https://hotspot.wifi.sfr.fr/nb4_crypt.php"
	jspopupurl="http://192.168.2.1:3990/logon?username=ssowifi.neuf.fr"
	userurl="http%3A%2F%2Fwww.fon.com%2Ffr%2Flanding%2Ffoneroneufbox%3Bfon%3B%3B"
	okmatch="http://192.168.2.1:3990"
	hotspot="sfr"
	;;
    list)
	echo "available networks:"
	echo $wifilist
	exit 0
	;;
    help)
	echo $usage
	exit 0
	;;
    version)
        echo "wifi $version"
        exit 0
        ;;
    *)
	echo "error: unknown access point"
	exit 1
	;;
esac

################################################################################
# Setup network
################################################################################

$ifconfig $interface down

# if static
if [ $static ]; then

    $ifconfig $interface nwid $access_point wpakey $password >/dev/null 2>&1
    $ifconfig $interface inet $ip netmask $netmask \
	broadcast $broadcast >/dev/null 2>&1
    $route add default $gateway >/dev/null 2>&1
    echo $dns > /etc/resolv.conf
    fwreload

# if hotspot
elif [ $hotspot ]; then

    $ifconfig $interface nwid $access_point -wpa >/dev/null 2>&1
    $dhclient $interface > /dev/null 2>&1
    fwreload

    case $hotspot in
	free)
	    $curl -s -F "login=${username}" -F "password=${password}" "${url}" | \
		grep -q "${okmatch}" && success="yes"
	    ;;
	sfr)
	    challenge=`$curl -L http://www.google.com`
	    challenge=`echo $challenge | grep challenge= | \
                sed -r 's/.*challenge=([0-9a-z]+).*/\1/'`
	    response=`$curl -d "username=${username}&password=${password}&cond=on&challenge=${challenge}" \
		${url} | grep response= | sed -r 's/.*response=([0-9a-z]+).*/\1/'`
	    $curl "${jspopupurl}/${username}&response=${response}&uamip=192.168.2.1&userurl=${userurl}" | \
		grep -q "${okmatch}" && success="yes"
	    ;;
    esac

    if [[ -z $success ]]; then
	if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
	     echo "error: username/password pair incorrect"
	fi
    fi

# others (dhcp)
else

    $ifconfig $interface nwid $access_point wpakey $password >/dev/null 2>&1
    $dhclient $interface >/dev/null 2>&1
    fwreload

fi

################################################################################
# Test Connexion, clean variables and exit
################################################################################

while ! ping -c 1 8.8.8.8 >/dev/null 2>&1
do
    sleep 1
done
echo "connected"

unset username password access_point success okmatch challenge response
exit 0

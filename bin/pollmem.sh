#!/bin/sh

ME=$1
CF=$2

LIMIT=`grep "^$ME.limit=" $CF | cut -d"=" -f2-`
IP=`grep "^$ME.ip=" $CF | cut -d"=" -f2-`
OID=`grep "^$ME.oid=" $CF | cut -d"=" -f2-`
COMM=`grep "^$ME.community=" $CF | cut -d"=" -f2-`
STATEFILE=`grep "^$ME.statefile=" $CF | cut -d"=" -f2-`

mem=`snmpget -v2c -c $COMM $IP $OID | awk '{print $NF}'`
isfault=`cat $STATEFILE`
if [ "$isfault" != "1" ]; then
	isfault=0
fi

msg=
if [ "$mem" -gt $LIMIT ]; then
	if [ "$isfault" != "1" ]; then
		isfault=1
		msg="Firewall memory usage is too high at $mem%"
	fi
else
	if [ "$isfault" = "1" ]; then
		isfault=0
		msg="Firewall memory is back to normal at $mem%"
	fi
fi

echo $isfault > $STATEFILE

if [ "$msg" != "" ]; then
	echo $msg
fi


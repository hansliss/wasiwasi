#!/bin/sh

ME=$1
CF=$2

TARGET=`grep "^$ME.target=" $CF | cut -d"=" -f2-`
STATEFILE=`grep "^$ME.statefile=" $CF | cut -d"=" -f2-`

isfault=`cat $STATEFILE`
if [ "$isfault" != "1" ]; then
	isfault=0
fi

msg=
if ping > /dev/null 2>&1 -4 -c 5 -q $TARGET; then
	if [ "$isfault" = "1" ]; then
		isfault=0
		msg="Can ping $TARGET again"
	fi
else
	if [ "$isfault" != "1" ]; then
		isfault=1
		msg="Can't ping $TARGET"
	fi
fi

echo $isfault > $STATEFILE

if [ "$msg" != "" ]; then
	echo $msg
fi


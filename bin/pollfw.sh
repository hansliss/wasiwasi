#!/bin/sh

CF=/root/etc/poll.conf
BD=`dirname $0`
AGENTS="`grep '^agents=' $CF | cut -d'=' -f2-`"
RCPTS="`grep '^rcpts=' $CF | cut -d'=' -f2-`"

for agent in $AGENTS; do
	name=`echo $agent | cut -d: -f1`
	script=`echo $agent | cut -d: -f2`
	msg=`$BD/$script $name $CF`

	if [ "$msg" != "" ]; then
		for rcpt in $RCPTS; do
			echo "$msg" > /var/spool/gammu/outbox/OUT$rcpt.txt
		done
	fi
done


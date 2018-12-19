# wasiwasi
A very rudimentary shellscript-based monitoring system.

This may be good enough as a starting point if you want to experiment with building your own scripts and not rely on a massive application.

It's somewhat modularized, using a main script and a common configuration file to identify and execute a number of "sub-scripts", each doing its own check and status handling, and outputting a message string if, and only if, a notification should be sent out.

The package includes a simple "ping" script, which only requires a normal "ping" command, and an SNMP-based memory check script for a Fortigate firewall. You can easily adapt the latter script for other kinds of SNMP monitoring - just find an OID and a level on which to trigger an alarm. The SNMP monitoring requires snmpget, part of the "snmp" package in Ubuntu.

Notifications are based on the gammu-smsd package, using its default path for the outbox. I highly recommend having a local SMS transmitter as opposed to using network-based SMS services - especially if you want to send an SMS when the network goes down. Think about it. I know you'll get it.

The current state is maintained in a separate state file for each monitoring script.

Obvious improvements, as an exercise for the avid user:
* Change the configuration code for sub-scripts to extract all parameters with the correct prefix and set them as environment variables automatically. Maybe add a function that does that?
* Add email alerts as an option
* Add a notification "level", and possibly a filter to control how notifications at different levels are sent out. A simple method would be to require the monitor scripts to output the level as a colon-separated prefix to the message.
* Split data fetch and analysis into two different modules - here we only have a single threshold and don't keep track of history, but you might want to record a number of previous values and do trend analysis for some data.
* Add data logging - for this you may need to somehow consolidate the raw data from all sub-scripts into a single log entry.
* Update my archaic "sh" syntax to bash syntax - it's 2018, after all.

Some general observations on monitoring:
* Consider trend analysis. If you want to monitor disk or memory usage, just warning at a threshold might be a bad idea, since the rate of change is probably far more important than the current level.
* Again, do use a local GSM modem of some kind to send SMS messages.
* It's not the size of the monitoring system, it's how you use it. Monitoring systems should send alerts only when an action should be taken. They need to be tuned! Almost any system will be usable - the need for tuning is the bottleneck.
* When you are monitoring equipment behind routers or firewalls, or with other dependencies (e.g. an application dependent on a db server), implement hierarchical dependencies and only alert for the primary point of failure. Use https://github.com/hansliss/shaip for icmp monitoring, for example.

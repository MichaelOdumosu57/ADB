#!/bin/bash
### BEGIN INIT INFO
#chkconfig:2345 98 5
# Provides:        mtpdaemon.sh  
# Required-Start:
# Required-Stop:     
# Default-Start:
# Default-Stop:      0 6
# Short-Description: mtpdaemon 
# Description:script to start mtpdaemon
### END INIT INFO
umask 022
case "$1" in
  start)
	sudo /usr/bin/mtpdaemon &
	;;
  restart|reload|force-reload)
	echo "Error: no this options, only start or stop supported!" >&2
	exit 3
	;;
  stop)
	ps -ef |grep mtpdaemon |grep -vn "grep" |awk '{print $2}'| xargs kill -9
	;;
  *)
	echo "Usage: $0 start|stop" >&2
	exit 3
	;;
esac

exit 0

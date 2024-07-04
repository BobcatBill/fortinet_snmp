#!/bin/sh
SNMPSTRING=public

for HOSTNAME in `grep -E "fw|sw0|faz|fmg|fsa|fac" /etc/xymon/hosts.cfg | awk '{print $2}'`; do
	UPTIME=$(snmpget -Ov -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.2.1.1.3.0 2>/dev/null | awk '{printf($3" "$4" "$5)}')
 	if [ "$UPTIME" = "" ]; then
		echo "Error on host $HOSTNAME"
 		continue
	fi
	MSG=/tmp/${HOSTNAME}.MSG.out
	echo "client $HOSTNAME.linux linux"  >  $MSG
	echo "[date]" >> $MSG
	date >> $MSG
	echo "[uptime]" >> $MSG
	XTIME=$(uptime | awk '{print $1}')
 	case "$HOSTNAME" in
  		*fw*)
    			LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME .1.3.6.1.4.1.12356.101.4.1.3.0)
       			;;
	  	*sw*)
    			LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.106.4.1.2.0)
       			;;
	  	*faz*)
    			LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.103.2.1.1.0)
       			;;
	  	*fmg*)
    			LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.103.2.1.1.0)
       			;;
	  	*fsa*)
    			LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.118.3.1.2.0)
       			;;
	  	*fac*)
    			LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.113.1.4.0)
       			;;
	esac
	echo "$XTIME up $UPTIME, 0 users, load=$LOAD%" >> $MSG
	$BB $BBDISP "@" < $MSG
 	rm $MSG
done


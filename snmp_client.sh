#!/bin/sh
SNMPSTRING=public

for HOSTNAME in `grep fw /etc/xymon/hosts.cfg | awk '{print $2}'`; do
	MSG=/tmp/${HOSTNAME}.MSG.out
	echo "client $HOSTNAME.linux linux"  >  $MSG
	echo "[date]" >> $MSG
	date >> $MSG
	echo "[uptime]" >> $MSG
	XTIME=$(uptime | awk '{print $1}')
	UPTIME=$(snmpget -Ov -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.2.1.1.3.0 | awk '{printf($3" "$4" "$5)}')
 	if [ "$?" != 0 ]; then
		exit 1
  	fi
#	if [ "$UPTIME" = "" ]; then
#		break
#	fi
	LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME .1.3.6.1.4.1.12356.101.4.1.3.0)
	echo "$XTIME up $UPTIME, 0 users, load=$LOAD%" >> $MSG
	$BB $BBDISP "@" < $MSG
	echo "\tSensor Name\t\tCelsius\tFahrenheit" > /tmp/$HOSTNAME.temp
	for TARGET in $(snmpwalk -Oq -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.101.4.3 | grep -i tempera | awk '{print $1}' ); do
		SENSOR=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME $TARGET | sed 's/"//g' | sed 's/ /_/g')
		if [ "$SENSOR" = "" ]; then
			break
		fi
		TARGET2=$(echo $TARGET | sed 's/.101.4.3.2.1.2./.101.4.3.2.1.3./g')
		TEMPERATURE=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME $TARGET2 | sed 's/"//g')
		TEMPERATURE2=$(echo "scale=1; $TEMPERATURE/1" | bc)
		TEMPERATUREF=$(echo "scale=1; $TEMPERATURE2*1.8+32" | bc)
		echo "&green\t$SENSOR\t$TEMPERATURE2\t$TEMPERATUREF" >> /tmp/$HOSTNAME.temp
	done
	$BB $BBDISP "status $HOSTNAME.temperature green `date`
`cat /tmp/$HOSTNAME.temp`
"
done

for HOSTNAME in `grep sw0 /etc/xymon/hosts.cfg | awk '{print $2}'`; do
        MSG=/tmp/${HOSTNAME}.MSG.out
        echo "client $HOSTNAME.linux linux"  >  $MSG
        echo "[date]" >> $MSG
        date >> $MSG
        echo "[uptime]" >> $MSG
        XTIME=$(uptime | awk '{print $1}')
        UPTIME=$(snmpget -Ov -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.2.1.1.3.0 | awk '{printf($3" "$4" "$5)}')
        if [ "$UPTIME" = "" ]; then
                break
        fi
	LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.106.4.1.2.0)
        echo "$XTIME up $UPTIME, 0 users, load=$LOAD%" >> $MSG
        $BB $BBDISP "@" < $MSG
done

for HOSTNAME in `grep -E "faz|fmg" /etc/xymon/hosts.cfg | awk '{print $2}'`; do
        MSG=/tmp/${HOSTNAME}.MSG.out
        echo "client $HOSTNAME.linux linux"  >  $MSG
        echo "[date]" >> $MSG
        date >> $MSG
        echo "[uptime]" >> $MSG
        XTIME=$(uptime | awk '{print $1}')
        UPTIME=$(snmpget -Ov -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.2.1.1.3.0 | awk '{printf($3" "$4" "$5)}')
        if [ "$UPTIME" = "" ]; then
                break
        fi
	LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.103.2.1.1.0)
        echo "$XTIME up $UPTIME, 0 users, load=$LOAD%" >> $MSG
        $BB $BBDISP "@" < $MSG
done

for HOSTNAME in `grep fsa /etc/xymon/hosts.cfg | awk '{print $2}'`; do
        MSG=/tmp/${HOSTNAME}.MSG.out
        echo "client $HOSTNAME.linux linux"  >  $MSG
        echo "[date]" >> $MSG
        date >> $MSG
        echo "[uptime]" >> $MSG
        XTIME=$(uptime | awk '{print $1}')
        UPTIME=$(snmpget -Ov -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.2.1.1.3.0 | awk '{printf($3" "$4" "$5)}')
        if [ "$UPTIME" = "" ]; then
                break
        fi
        LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.118.3.1.2.0)
        echo "$XTIME up $UPTIME, 0 users, load=$LOAD%" >> $MSG
        $BB $BBDISP "@" < $MSG
done

for HOSTNAME in `grep fac /etc/xymon/hosts.cfg | awk '{print $2}'`; do
        MSG=/tmp/${HOSTNAME}.MSG.out
        echo "client $HOSTNAME.linux linux"  >  $MSG
        echo "[date]" >> $MSG
        date >> $MSG
        echo "[uptime]" >> $MSG
        XTIME=$(uptime | awk '{print $1}')
        UPTIME=$(snmpget -Ov -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.2.1.1.3.0 | awk '{printf($3" "$4" "$5)}')
        if [ "$UPTIME" = "" ]; then
                break
        fi
        LOAD=$(snmpget -Oqv -v2c -c $SNMPSTRING $HOSTNAME 1.3.6.1.4.1.12356.113.1.4.0)
        echo "$XTIME up $UPTIME, 0 users, load=$LOAD%" >> $MSG
        $BB $BBDISP "@" < $MSG
done


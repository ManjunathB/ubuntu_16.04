#!/bin/bash
STAT=`netstat -na | grep 8092 | awk '{print $6}'`
echo $STAT
if [ "$STAT" = "LISTEN" ]; then
echo "TOMCAT IS UP AND RUNNING"
else
echo "Tomcat is down"
#mailx -s "Tomcat is down!"  Manjunath.B.Badiger@tatatechnologies.com
#.

`cat <<'EOF' - mailcontent.html | /usr/sbin/sendmail -t
To: abhijit.rajput@tatatechnologies.com
Subject: Tomcat Down
Content-Type: text/html
EOF`
fi


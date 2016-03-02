#!/bin/bash

set -e
SERVICE=’postgres’

echo "Starting postgres"
#is_init=`su - postgres -c 'echo "ps -ef" | psql | grep dcd_odasa | wc -l'`
su - postgres -c "/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data"
echo "starting logs"

su - postgres -c "/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &"


# check if postgres service is running
if ps ax | grep -v grep | grep $SERVICE > /dev/null
then
   echo “$SERVICE service running, everything is fine”
else
   echo “$SERVICE is not running”
   #echo “$SERVICE is not running!” | mail -s “$SERVICE down” root
fi


# moving this to test.sh
#echo "creating test DB..."
#su - postgres -c "/usr/local/pgsql/bin/createdb test -U postgres"

#echo "chance to test DB"
#su - postgres -c "/usr/local/pgsql/bin/psql test"

exit

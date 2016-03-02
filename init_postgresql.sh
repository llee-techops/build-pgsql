#!/bin/bash

set -e
echo "Starting postgres"
#is_init=`su - postgres -c 'echo "ps -ef" | psql | grep dcd_odasa | wc -l'`
su - postgres -c "/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data"
echo "starting logs"

su - postgres -c "/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &"
echo "creating test DB..."
su - postgres -c "/usr/local/pgsql/bin/createdb test"

echo "chance to test DB"
su - postgres -c "/usr/local/pgsql/bin/psql test"

exit

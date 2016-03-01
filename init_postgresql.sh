#!/bin/bash

set -e

#is_init=`su - postgres -c 'echo "ps -ef" | psql | grep dcd_odasa | wc -l'`
su - postgres -c "/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data"
su - postgres -c "/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &"
su - postgres -c "/usr/local/pgsql/bin/createdb test"
su - postgres -c "/usr/local/pgsql/bin/psql test"

exit

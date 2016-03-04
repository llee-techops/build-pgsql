#!/bin/bash

set -e

cd git-postgres
./configure
gmake

echo "========= running gmake check ============="
su postgres -c "make check"

# su
echo "========= running gmake install ============="
gmake install

#adduser --disabled-password --gecos ""  postgres
mkdir -p /usr/local/pgsql/data
chown -R postgres /usr/local/pgsql/data

echo "Starting postgres"
su postgres -c "/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data"



echo "start postgres and logs"
su postgres -c "/usr/local/pgsql/bin/pg_ctl start -l logfile -D /usr/local/pgsql/data"

echo "===============   check postgres installations  ======================="
echo "======================================================================="
gmake installcheck
#su - postgres
#/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
#/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
#/usr/local/pgsql/bin/createdb test
#/usr/local/pgsql/bin/psql test
exit

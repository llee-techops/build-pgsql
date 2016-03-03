#!/bin/bash

set -e

adduser --disabled-password --gecos ""  postgres
#mkdir -p /usr/local/pgsql/data
#chown -R postgres /usr/local/pgsql/data
chown -R postgres ./git-postgres
#su postgres -c "./ci-scripts/scripts/build_postgresql.sh"
./ci-scripts/scripts/build_postgresql.sh
exit

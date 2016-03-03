#!/bin/bash

set -e

adduser --disabled-password --gecos ""  postgres
mkdir /usr/local/pgsql/data
chown postgres /usr/local/pgsql/data

su - postgres -c "./ci-scripts/scripts/build_postgresql.sh"
#./ci-scripts/scripts/init_postgresql.sh
exit

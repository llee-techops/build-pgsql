#!/bin/bash

set -e
./ci-scripts/build_pgsql.sh
./ci-scripts/init_postgresql.sh
exit

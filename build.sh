#!/bin/bash

set -e
./build_pgsql.sh
./init_postgresql.sh
exit

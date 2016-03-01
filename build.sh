#!/bin/bash

set -e
./ci-scripts/build_postgresql.sh
./ci-scripts/init_postgresql.sh
exit

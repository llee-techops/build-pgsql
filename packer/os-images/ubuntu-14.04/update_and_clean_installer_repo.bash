#! /bin/bash

set -eu

_main() {
  export DEBIAN_FRONTEND=noninteractive
  apt-get update
  apt-get install -y software-properties-common
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
}

_main

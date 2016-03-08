#!/bin/bash -l

set -euo pipefail

print_bar() {
  for ((x = 0; x < 80; x++)); do
    printf %s -
  done
  echo
}

print_kernel() {
  print_bar
  whoami
  id
}

print_kernel() {
  print_bar
  head -n1 < /etc/issue
  uname -a
  sysctl -a
}

print_environment() {
  print_bar
  env
}

print_versions() {
  print_bar
  gcc --version
  g++ --version
  # GNU Make bug: https://cygwin.com/ml/cygwin/2009-07/msg01009.html
  for ((x = 0; x < 100; x++)); do make --version | head -n1 && break; done
  for ((x = 0; x < 100; x++)); do autoconf --version | head -n1 && break; done
  java -version
  sleep 1
}

print_diskspace() {
  print_bar
  df -h
}

print_memory() {
  print_bar
  free -m
}

print_cpu_info() {
  print_bar
  cat /proc/cpuinfo
}

_main() {
  print_kernel
  print_environment
  print_versions
  print_diskspace
  print_memory
  print_cpu_info
}

_main "$@"

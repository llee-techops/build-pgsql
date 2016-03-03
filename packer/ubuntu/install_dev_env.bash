#!/bin/bash
apt-get update -qq
apt-get install -qq build-essential libreadline-dev zlib1g-dev flex bison libxml2-dev libxslt-dev libssl-dev
add-apt-repository -y ppa:ubuntu-toolchain-r/test
apt-get install -qq gcc-4.9 g++-4.9 software-properties-common
update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 90
update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 90
ln -s /usr/bin/make /usr/bin/gmake

echo "--- Build Enviroment ---"
cat /etc/lsb-release
gcc --version | grep gcc
g++ --version | grep g++
perl --version | grep version
echo "------------------------"

apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

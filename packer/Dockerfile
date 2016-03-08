FROM alpine:3.3

# Install prerequisites
RUN apk add --update unzip jq iptables build-base ruby ruby-dev ruby-io-console ruby-json ruby-bundler docker && rm -rf /var/cache/apk/*

# Fetch packer executable
ADD https://releases.hashicorp.com/packer/0.9.0/packer_0.9.0_linux_amd64.zip /tmp/packer.zip
RUN unzip /tmp/packer.zip -d /usr/local/bin && rm /tmp/packer.zip

ADD scripts/packer-build.sh /opt/bin/packer-build.sh
ADD scripts/common.bash /opt/bin/common.bash
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --gemfile=/tmp/Gemfile
RUN apk del build-base
RUN rm -f /usr/local/bin/packer-builder-digitalocean \
  /usr/local/bin/packer-builder-googlecompute \
  /usr/local/bin/packer-builder-null \
  /usr/local/bin/packer-builder-openstack \
  /usr/local/bin/packer-builder-parallels-* \
  /usr/local/bin/packer-builder-qemu \
  /usr/local/bin/packer-builder-virtualbox-* \
  /usr/local/bin/packer-builder-vmware-* \
  /usr/local/bin/packer-post-processor-artifice \
  /usr/local/bin/packer-post-processor-atlas \
  /usr/local/bin/packer-post-processor-vsphere \
  /usr/local/bin/packer-provisioner-ansible-local \
  /usr/local/bin/packer-provisioner-chef-* \
  /usr/local/bin/packer-provisioner-powershell \
  /usr/local/bin/packer-provisioner-puppet-* \
  /usr/local/bin/packer-provisioner-salt-masterless \
  /usr/local/bin/packer-provisioner-windows-*
RUN ln /bin/sh /bin/bash

ENTRYPOINT ["/bin/sh"]

#! /bin/sh

main() {
  . ci-infrastructure/packer/scripts/common.bash
  run_docker
  run_rspec "packer_build/ubuntu-14.04-image.tar" "ci-infrastructure/packer/os-images/ubuntu-14.04/ubuntu_14.04_spec.rb"
}

main "$@"

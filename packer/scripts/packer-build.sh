#!/bin/sh

set -e

get_repository_from_json() {
  local packer_template_json=${1}
  jq .builders[0].image < "${packer_template_json}"
}

main() {
  echo "Preparing for packer build..."

  . /opt/bin/common.bash
  local template=${1}
  local repository
  repository=$(get_repository_from_json "${template}")
  start_docker "${repository}"

  local export_basepath=${2}

  local export_path
  local template_dir
  local template_basename

  export_path="$(pwd)/${export_basepath}"
  template_dir="$(dirname "${template}")"
  template_basename="$(basename "${template}")"
  cd "${template_dir}"

  echo "About to run packer build with export_path=${export_path} and template_basename=${template_basename} from dir=${PWD}"
  packer build -color=false -var "export_path=${export_path}" "${template_basename}"
}

main "$@"

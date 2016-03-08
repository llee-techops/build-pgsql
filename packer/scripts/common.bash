#!/bin/sh

run_docker() {
  local payload
  payload="$(mktemp -t packer_tmp.XXXXXX)"
  echo "Packer temp file: ${payload}"
  start_docker "${payload}"
}

run_rspec() {
  export BUNDLE_GEMFILE=/tmp/Gemfile
  local image
  local spec_file
  image="${1}"
  spec_file="${2}"
  env TEMPLATE_IMAGE="${image}" bundle exec rspec --color --format documentation "${spec_file}"
}

start_docker() {
  mkdir -p /var/log
  mkdir -p /var/run
  local payload="${1}"

  # set up cgroups
  mkdir -p /sys/fs/cgroup
  mountpoint -q /sys/fs/cgroup || \
    mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup

  while read line; do
    local d
    d=$( echo "$line" | cut -f1 | grep -v subsys_name || echo "INVALID" )
    if [ "$d" = "INVALID" ]; then
      continue
    fi

    mkdir -p "/sys/fs/cgroup/${d}"
    mountpoint -q "/sys/fs/cgroup/${d}" || \
      mount -n -t cgroup -o "$d" cgroup "/sys/fs/cgroup/${d}"
  done < /proc/cgroups

  mkdir -p /var/lib/docker
  mount -t tmpfs -o size=100G none /var/lib/docker

  local repository=${1-}
  echo "$repository"
  if [[ -n "${repository}" ]] && private_registry "${repository}" ; then
    echo "This registry is private!"
    local registry
    registry=$(extract_registry "${repository}")
    echo "Running the docker daemon with --insecure-registry..."
    docker daemon --insecure-registry "$registry" >/dev/null 2>&1 &
  else
    docker daemon >/dev/null 2>&1 &
  fi

  sleep 1

  until docker info >/dev/null 2>&1; do
    echo waiting for docker to come up...
    sleep 1
  done
}

private_registry() {
  local repository
  repository=$(echo "${1}" | sed -e 's/^"//'  -e 's/"$//')

  if echo "${repository}" | fgrep -q '/' ; then
    local registry
    registry="$(extract_registry "${repository}")"
    if echo "${registry}" | fgrep -q '.' ; then
      return 0
    fi
  fi

  return 1
}

extract_registry() {
  local repository
  repository=$(echo "${1}" | sed -e 's/^"//'  -e 's/"$//')

  echo "${repository}" | cut -d/ -f1
}

extract_repository() {
  local long_repository="${1}"

  echo "${long_repository}" | cut -d/ -f2-
}

docker_image() {
  docker images --no-trunc "$1" | awk "{if (\$2 == \"$2\") print \$3}"
}

docker_pull() {
  GREEN='\033[0;32m'
  RED='\033[0;31m'
  NC='\033[0m' # No Color

  pull_attempt=1
  max_attempts=3
  while [ "$pull_attempt" -lt "$max_attempts" ]; do
    printf "Pulling ${GREEN}%s${NC}" "$1"

    if [ "$pull_attempt" != "1" ]; then
      printf " (attempt %s of %s)" "$pull_attempt" "$max_attempts"
    fi

    printf "...\n"

    if docker pull "$1"; then
      printf "\nSuccessfully pulled ${GREEN}%s${NC}.\n\n" "$1"
      return
    fi

    echo

    pull_attempt=$(( "$pull_attempt" + 1))
  done

  printf "\n${RED}Failed to pull image %s.${NC}" "$1"
  exit 1
}

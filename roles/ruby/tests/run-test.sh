#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/run-test.sh
#   - distro: a supported Docker distro version (default = "xenial")
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - cleanup: whether to remove the Docker container (default = true)
#   - container_id: the --name to set for the container (default = timestamp)
#   - test_idempotence: whether to test playbook's idempotence (default = true)
#   - test_suite: whether to run role-related tests (default = true)
#
# License: MIT

# Exit on any individual command failure.
set -e

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
distro=${distro:-"xenial"}
playbook=${playbook:-"test.yml"}
cleanup=${cleanup:-"true"}
container_id=${container_id:-$timestamp}
test_idempotence=${test_idempotence:-"true"}
test_suite=${test_suite:-"false"}

## Set up vars for Docker setup.
# GalliumOS
if [ $distro = 'gallium' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
# Ubuntu 16.04
elif [ $distro = 'xenial' ]; then
  init="/lib/systemd/systemd"
  opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
fi

# Run the container using the supplied OS.
printf ${green}"Starting Docker container: polymimetic/docker-$distro-ansible."${neutral}"\n"
docker pull polymimetic/docker-$distro-ansible:latest
docker run --detach --volume="$PWD":/etc/ansible/roles/role_under_test:rw --name $container_id $opts polymimetic/docker-$distro-ansible:latest $init

printf "\n"

# Install requirements if `requirements.yml` is present.
if [ -f "$PWD/tests/requirements.yml" ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  docker exec --tty $container_id env TERM=xterm ansible-galaxy install -r /etc/ansible/roles/role_under_test/tests/requirements.yml
fi

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec --tty $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook"${neutral}
docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook

# Run Ansible playbook again (idempotence test).
if [ "$test_idempotence" = true ]; then
  printf ${green}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  docker exec $container_id ansible-playbook /etc/ansible/roles/role_under_test/tests/$playbook | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

# Run system test suite.
if [ "$test_suite" = true ]; then
  printf ${green}"Running test suite"${neutral}"\n"

  # Make sure ruby is installed and at the correct version.
  docker exec --tty ${container_id} env TERM=xterm which ruby
  docker exec --tty ${container_id} env TERM=xterm ruby --version

  # Make sure bundler is installed.
  docker exec --tty ${container_id} env TERM=xterm ls -lah /usr/local/bin
  docker exec --tty ${container_id} env TERM=xterm which bundle

  # Make sure user installed gems are available.
  docker exec --tty ${container_id} env TERM=xterm bash --login -c "which sass"

fi

# Remove the Docker container (if configured).
if [ "$cleanup" = true ]; then
  printf "Removing Docker container...\n"
  docker rm -f $container_id
fi

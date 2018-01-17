#!/bin/bash
#
# Ansible role test shim.
#
# Usage: [OPTIONS] ./tests/run-tests.sh
#   - playbook: a playbook in the tests directory (default = "test.yml")
#   - cleanup: whether to remove the Docker container (default = true)
#   - dockerfile: the source dockerfile to build from (default = tests/Dockerfile)
#   - container_id: the --name to set for the container (default = timestamp)
#   - verbose: the verbosity [1-3] when running the playbook (default = false)
#   - tag: Run the playbook using only specific tag(s) (default = false)
#   - test_idempotence: whether to test playbook's idempotence (default = true)
#   - test_suite: whether to run role-related tests (default = true)
#
# Example: playbook=test.yml verbose=2 ./tests/run-tests.sh
# License: MIT

# Exit on any individual command failure.
set -e

# Script variables.
readonly SCRIPT_SOURCE="${BASH_SOURCE[0]}"
readonly SCRIPT_PATH="$( cd -P "$( dirname "${SCRIPT_SOURCE}" )" && pwd )"

# Pretty colors.
red='\033[0;31m'
green='\033[0;32m'
neutral='\033[0m'

timestamp=$(date +%s)

# Allow environment variables to override defaults.
playbook=${playbook:-"test.yml"}
cleanup=${cleanup:-"true"}
dockerfile=${dockerfile:-$SCRIPT_PATH}
container_id=${container_id:-$timestamp}
verbose=${verbose:-"false"}
tag=${tag:-"false"}
test_idempotence=${test_idempotence:-"true"}
test_suite=${test_suite:-"false"}

## Set up vars for Docker setup.
init="/lib/systemd/systemd"
opts="--privileged --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro"
image="ansible-testshim"

# Run the container using the supplied OS.
printf ${green}"Starting Docker container."${neutral}"\n"
docker build -t $image $dockerfile
docker run --detach --volume="$PWD":/etc/ansible/roles/playbook_under_test:rw -t --name $container_id $opts $image $init

printf "\n"

# Set playbook verbosity.
if [ "$verbose" != "false" ]; then
  if [ "$verbose" = "1" ]; then
    verbose="-v"
  elif [ "$verbose" = "2" ]; then
    verbose="-vv"
  elif [ "$verbose" = "3" ]; then
    verbose="-vvv"
  else
    verbose=""
  fi
else
  verbose=""
fi

# Check for tests directory.
if [ ! -d "$PWD/tests" ]; then
  printf ${red}"Test directory is missing! Aborting...."${neutral}"\n"
  docker rm -f $container_id
fi

# Install requirements if `requirements.yml` is present.
if [ -f "$PWD/tests/requirements.yml" ]; then
  printf ${green}"Requirements file detected; installing dependencies."${neutral}"\n"
  docker exec --tty $container_id env TERM=xterm ansible-galaxy install -r /etc/ansible/roles/playbook_under_test/tests/requirements.yml
fi

printf "\n"

# Test Ansible syntax.
printf ${green}"Checking Ansible playbook syntax."${neutral}
docker exec --tty $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/playbook_under_test/tests/$playbook --syntax-check

printf "\n"

# Run Ansible playbook.
printf ${green}"Running command: docker exec $container_id env TERM=xterm ansible-playbook /etc/ansible/roles/playbook_under_test/tests/$playbook"${neutral}
if [ "$tag" = false ]; then
  docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/roles/playbook_under_test/tests/$playbook ${verbose}
else
  docker exec $container_id env TERM=xterm env ANSIBLE_FORCE_COLOR=1 ansible-playbook /etc/ansible/roles/playbook_under_test/tests/$playbook -t ${tag} ${verbose}
fi

# Run Ansible playbook again (idempotence test).
if [ "$test_idempotence" = true ]; then
  printf ${green}"Running playbook again: idempotence test"${neutral}
  idempotence=$(mktemp)
  docker exec $container_id ansible-playbook /etc/ansible/roles/playbook_under_test/tests/$playbook | tee -a $idempotence
  tail $idempotence \
    | grep -q 'changed=0.*failed=0' \
    && (printf ${green}'Idempotence test: pass'${neutral}"\n") \
    || (printf ${red}'Idempotence test: fail'${neutral}"\n" && exit 1)
fi

# Run system test suite.
if [ "$test_suite" = true ]; then
  printf ${green}"Running test suite"${neutral}"\n"

  # Ensure nano is installed.
  # docker exec --tty ${container_id} env TERM=xterm nano --version
fi

# Remove the Docker container (if configured).
if [ "$cleanup" = true ]; then
  printf ${green}"Removing Docker container..."${neutral}"\n"
  docker rm -f $container_id
fi

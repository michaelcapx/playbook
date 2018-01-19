# Ansible Role tests

To run the test playbook(s) in this directory:

### Testing with Docker

To run basic integration tests using Docker:

  1. Install and start [Docker](https://docs.docker.com/engine/installation/).
  2. Make the test shim executable: `chmod +x tests/run-tests.sh`.
  3. Run (from the playbook or role root directory) `playbook=[playbook] verbose=[verbose] ./tests/run-tests.sh`

If you don't want the container to be automatically deleted after the test playbook is run, add the following environment variables: `cleanup=false container_id=$(date +%s)`

### Testing with Vagrant

To run basic integration tests using Vagrant:

  1. Install Virtualbox and Vagrant.
  2. Start vagrant from the playbook root directory: `vagrant up`.
  3. To re-run the playbook: `vagrant provision`.
  4. To destroy the virtual machine: `vagrant destroy`.

### Automated Testing

The project's automated tests are run via Travis CI, and the more comprehensive test suite covers multiple use cases and deployment techniques.

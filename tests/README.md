# Ansible Role tests

To run the test playbook(s) in this directory:

  1. Install and start Docker.
  2. Make the test shim executable: `chmod +x tests/run-test.sh`.
  3. Run (from the playbook root directory) `distro=[distro] playbook=[playbook] ./tests/run-test.sh`

If you don't want the container to be automatically deleted after the test playbook is run, add the following environment variables: `cleanup=false container_id=$(date +%s)`

## Credits

- https://github.com/samdoran/docker-ubuntu16-ansible
- https://visibilityspots.org/test-ansible-playbooks.html
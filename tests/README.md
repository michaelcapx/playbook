# Ansible Role tests

To run the test playbook(s) in this directory:

  1. Install and start Docker.
  2. Make the test shim executable: `chmod +x tests/run-tests.sh`.
  3. Run (from the playbook or role root directory) `playbook=[playbook] verbose=[verbose] ./tests/run-tests.sh`

If you don't want the container to be automatically deleted after the test playbook is run, add the following environment variables: `cleanup=false container_id=$(date +%s)`

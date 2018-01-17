# Ansible Role tests

To run the test playbook(s) in this directory:

  1. Install and start Docker.
  2. Make the test shim executable: `chmod +x tests/run-tests.sh`.
  3. Run (from the playbook root directory) `distro=[distro] playbook=[playbook] ./tests/run-tests.sh`

If you don't want the container to be automatically deleted after the test playbook is run, add the following environment variables: `cleanup=false container_id=$(date +%s)`

## Credits

- https://github.com/samdoran/docker-ubuntu16-ansible
- https://visibilityspots.org/test-ansible-playbooks.html

## Test your profile
Before actually running any new profile on your own system, you can and you should test that beforehand in a **Docker container** in order to see if everything works as expected. This might also be very handy in case you are creating a new role and want to see if it works.

#### Build the Docker image
```
docker build -t ansible-debian .
```
#### Run the Docker container

Before running you should be aware of a few environment variables that can change the bevaviour of the test run. See the table below:

| Variable  | Required | Description |
|-----------|----------|-------------|
| `MY_HOST` | yes      | The inventory hostname (your profile) |
| `verbose` | no       | Ansible verbosity. Valid values: `0`, `1`, `2` or `3` |
| `tag`     | no       | Only run this specific tag (role name) |

Run a full test of profile `localhost`:
```
docker run --rm -e MY_HOST=localhost -t ansible-debian
```
Only runt `browser` role in profile `localhost`
```
docker run --rm -e MY_HOST=localhost -e tag=browser -t ansible-debian
```

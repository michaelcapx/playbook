# Ansible Role: Blackfire

Installs [Blackfire](https://blackfire.io/) on Debian/Ubuntu.

After installation, you need to complete Blackfire setup manually before profiling:

  1. Register the Blackfire agent: `sudo blackfire-agent -register`
  2. Configure Blackfire: `blackfire config`

## Credits

This role takes inspiration from the following Ansible roles:

- [phansible.blackfire](https://github.com/phansible/role-blackfire)
- [opichon.docker-blackfire](https://github.com/opichon/ansible-docker-blackfire)
- [geerlingguy.blackfire](https://github.com/geerlingguy/ansible-role-blackfire)
- [AbdoulNdiaye.Blackfire](https://github.com/AbdoulNdiaye/ansible-role-blackfire)

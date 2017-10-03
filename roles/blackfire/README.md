# Ansible Role: Blackfire

Installs [Blackfire](https://blackfire.io/) on Debian/Ubuntu.

## Requirements

Make sure all dependencies have been installed before moving on:

* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.0

After installation, you need to complete Blackfire setup manually before profiling:

  1. Register the Blackfire agent: `sudo blackfire-agent -register`
  2. Configure Blackfire: `blackfire config`

## Dependencies

None.

## Example playbook

This is an example playbook that demonstrates how you would use the role:

    - hosts: localhost
      roles:
         - { role: blackfire, become: true }

## Credits

None.

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).
# Ansible Role: Adminer

Installs [Adminer](http://www.adminer.org/) on almost any computer.

## Requirements

Make sure all dependencies have been installed before moving on:

* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.0

## Dependencies

None. If `adminer_add_apache_config` is set to `true`, it will use some variables and handlers defined by the `apache` role, so there's a soft dependency on that role.

## Example playbook

This is an example playbook that demonstrates how you would use the role:

    - hosts: localhost
      roles:
         - { role: adminer, become: true }

## Credits

None.

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).

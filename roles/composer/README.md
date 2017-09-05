# Ansible Role: Composer

Installs Composer, the PHP Dependency Manager, on any Linux or UNIX system.

## Requirements

Make sure all dependencies have been installed before moving on:

* [PHP](https://secure.php.net/) >= 5.4
* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.0

## Dependencies

None.

## Example playbook

This is an example playbook that demonstrates how you would use the role:

    - hosts: localhost
      roles:
         - { role: composer, become: true }

## Credits

None.

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).

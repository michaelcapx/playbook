# Ansible Role: Selenium

Set up selenium and Firefox for running selenium tests.

## Requirements

Make sure all dependencies have been installed before moving on:

* [Java](https://www.java.com/en/) >= 1.8.0
* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.0

## Dependencies

None.

## Example playbook

This is an example playbook that demonstrates how you would use the role:

    - hosts: localhost
      roles:
         - { role: selenium, become: true }

## Credits

None.

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).

# Ansible Role: Apache

Apache 2.x for Linux.

## Requirements

Make sure all dependencies have been installed before moving on:

* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.0

## Dependencies

None.

## Example playbook

This is an example playbook that demonstrates how you would use the role:

    - hosts: localhost
      roles:
         - { role: apache, become: true }

## Credits

- [Digital Ocean](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04)
- [Linode](https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04)

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).

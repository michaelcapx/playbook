# Ansible Role: MailHog

Installs [MailHog](https://github.com/mailhog/MailHog), a Go-based SMTP server and web UI/API for displaying captured emails, on Debian-based linux systems.

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
         - { role: mailhog, become: true }

## Credits

None.

## License

This software package is licensed under the [MIT License](https://opensource.org/licenses/MIT).

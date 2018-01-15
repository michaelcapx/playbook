Desktop Playbook
================
[![Release](https://img.shields.io/github/release/polymimetic/playbook.svg?style=flat-square)](https://github.com/polymimetic/playbook/releases)
[![Build Status](https://img.shields.io/travis/polymimetic/playbook.svg?style=flat-square)](https://travis-ci.org/polymimetic/playbook)
[![GitHub Issues](https://img.shields.io/github/issues/polymimetic/playbook.svg?style=flat-square)](https://github.com/polymimetic/playbook/issues)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)

Ansible playbook for setting up an Ubuntu desktop & server environment for raipid web development. There are many playbooks like it, but this one is mine.

## Quick Start

To reset GalliumOS, run the following from a crosh shell:

    cd ; curl -Os https://chrx.org/go && sh go -U yourname -H foobarhost

Then, from GalliumOS session, open the terminal and run:

    bash <(wget -qO - https://raw.github.com/polymimetic/playbook/master/start.sh)

## What's Included

It will install and configure the following on a linux machine:

* Ubuntu 16.04 Xenial LTS
* Python 2.7.12
* Ruby 2.3.1
* Node.js 8.x
* Docker 17.06.0-ce
* Apache 2.4
* PHP 7.1
* MySQL 5.7
* PostgreSQL 9.5
* Sublime Text 3
* Chromium Web Browser
* Firefox Web Browser
* and much, much more!

## Requirements

Make sure all dependencies have been installed before moving on:

* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.2

These requirements can be automagically installed using the provided [install.sh](https://github.com/polymimetic/playbook/blob/master/install.sh) script.

## Installation

1. Ensure Ansible is installed (`sudo apt-get install ansible`).
2. Ensure Git is installed (`sudo apt-get install git`).
3. Clone this repository to your local drive (`git clone https://github.com/polymimetic/playbook.git`).
4. Run `$ ansible-galaxy install -r requirements.yml` inside this directory to install required Ansible roles.
5. Run `ansible-playbook playbook.yml -i hosts -K --vault-id @prompt` inside this directory. Enter your account password when prompted.

## Customizing the Playbook

To customize the installation, install Git and Ansible [via pip](http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip)
or the [Ansible offical PPA](https://launchpad.net/~ansible/+archive/ubuntu/ansible).

    $ sudo apt-add-repository ppa:ansible/ansible -y
    $ sudo apt-get update
    $ sudo apt-get install software-properties-common ansible git python-apt -y

Clone the playbook from the GitHub repository:

    git clone https://github.com/polymimetic/playbook.git

Then you need to customize the playbook `playbook.yml` (or create a new one) to suit your needs.

To run the ansible playbook run the following command _in the same directory as this README file_:

    $ ansible-playbook playbook.yml --ask-become-pass --vault-id @prompt

Enter your sudo & vault passwords to run the playbook.

### Upgrading the Playbook

The Ansible configuration uses a variety of open source community-maintained Ansible Roles that are hosted on Ansible Galaxy, but this playbook includes the roles in the codebase for efficiency's sake.

**You should NOT make any manual changes to the roles in the `roles` directory**, but rather, contribute to the upstream roles corresponding to the role's folder name (e.g. for issues with the `polymimetic.apache` role, see the [`polymimetic.apache`](https://galaxy.ansible.com/polymimetic/apache/) role page on Ansible Galaxy, and the role's [issue tracker on GitHub](https://github.com/polymimetic/ansible-role-apache/issues)).

### Adding and Updating Galaxy roles

From time to time, third party roles need to be added or updated to enable new Mimetic functionality or fix bugs. To update a role (e.g. `polymimetic.apache`), find the role's `version` setting inside `requirements.yml`, bump the version to the required or latest version of the role, then run the following command from the project root folder:

    $ ansible-galaxy install -r requirements.yml --force

Then commit the updated `requirements.yml` file and the new and updated files within the `roles` directory in a new PR to the Mimetic project.

### Running a specific set of tagged tasks

You can filter which part of the provisioning process to run by specifying a set of tags using `ansible-playbook`'s `--tags` flag. The tags available are `base`, `browser`, `editor`, `desktop`, `virtualization`, `server`, `languages`, `database`, `mail`, `utility`, and `extras`.

    ansible-playbook main.yml -i hosts -K --vault-id @prompt --tags "base,browser"

## Overriding Defaults

Not everyone's development environment and preferred software configuration is the same.

You can override any of the defaults configured in `vars/config.yml` by creating a `local.config.yml` file and setting the overrides in that file. For example, you can customize the installed packages and apps with something like:

    composer_packages:
      - name: hirak/prestissimo
      - name: drush/drush
        release: '^8.1'

    ruby_gem_packages:
      - name: bundler
        state: latest

    npm_packages:
      - name: webpack

    pip_packages:
      - name: mkdocs

Any variable can be overridden in `config.yml`; see the supporting roles' documentation for a complete list of available variables.

## Included Roles

This playbook makes use of the following roles:

| Role                 | Description                                          |
| -------------------- | ---------------------------------------------------- |
| | **Base**           |
| common               | Setup and install common base packages & utilities.  |
| admin                | Setup the main admin user. |
| ssh                  | Configure SSH keys. |
| git                  | Install and configure git. |
| shell                | Setup the shell environment (`bash` or `zsh`) |
| | **Browser**        |
| chromium             | Install [Chromium](https://www.chromium.org/) and set policies and plugins. |
| firefox              | Install [Firefox](https://www.mozilla.org/firefox/) and set preferences and plugins. |
| | **Editor**         |
| sublime              | Install [Sublime Text 3](https://www.sublimetext.com/3) and [Package Control](https://packagecontrol.io/). |
| | **Desktop**        |
| desktop              | Install a lot of useful desktop packages and settings. |
| fonts                | Install custom font packages. |
| themes               | Install desktop GTK themes, icons, and cursors. |
| xfce                 | Configures XFCE panels. |
| | **Virtualization** |
| docker               | Install [Docker](https://www.docker.com/) and [Docker Indicator](https://yktoo.com/en/software/indicator-docker). |
| vagrant              | Install [Vagrant](https://vagrantup.com). |
| | **Server**         |
| apache               | Install [Apache](https://httpd.apache.org/) web server. |
| | **Languages** |
| python               | Install [Python](https://www.python.org/). |
| ruby                 | Install [Ruby](https://www.ruby-lang.org/). |
| node                 | Install [Node](https://nodejs.org/en/). |
| golang               | Install [Go](https://golang.org/). |
| php                  | Install [PHP](http://www.php.net/). |
| | **Database** |
| mysql                | Install [MySQL](https://www.mysql.com/). |
| postgresql           | Install [PostgreSQL](https://www.postgresql.org/). |
| mongodb              | Install [MongoDB](https://www.mongodb.com/). |
| couchdb              | Install [CouchDB](http://couchdb.apache.org/). |
| sqlite               | Install [SQLite](https://sqlite.org/). |
| | **Mail** |
| postfix              | Install [Postfix](http://www.postfix.org/). |
| mailhog              | Install [Mailhog](https://github.com/mailhog/MailHog). |
| mailcatcher          | Install [Mailcatcher](https://mailcatcher.me/). |
| | **Utility** |
| composer             | Install [Composer](https://getcomposer.org/). |
| beanstalkd           | Install [Beanstalkd](https://github.com/kr/beanstalkd). |
| memcached            | Install [Memcached](https://memcached.org/). |
| redis                | Install [Redis](https://redis.io/). |
| adminer              | Install [Adminer](https://www.adminer.org/). |
| phpmyadmin           | Install [phpMyAdmin](https://www.phpmyadmin.net/). |
| pimpmylog            | Install [pimpMyLog](http://pimpmylog.com/). |
| ngrok                | Install [nGrok](https://ngrok.com/). |
| blackfire            | Install [Blackfire](https://blackfire.io/). |
| | **Extras** |
| dotfiles             | Setup dotfiles repository. |
| projects             | Setup project installer. |
| www                  | Setup web server dashboard. |

## Testing

To run basic integration tests using Docker:

  1. [Install Docker](https://docs.docker.com/engine/installation/).
  2. In this project directory, run: `sh tests/run-tests.sh`

The project's automated tests are run via Travis CI, and the more comprehensive test suite covers multiple use cases and deployment techniques.

## Credits

This playbook draws inspiration from the following projects:

- [Drupal VM](https://github.com/geerlingguy/drupal-vm)
- [Ansible Ubuntu](https://github.com/Benoth/ansible-ubuntu)
- [Roots Trellis](https://github.com/roots/trellis)
- [Laravel Settler](https://github.com/laravel/settler)
- [Ansible Debian](https://github.com/cytopia/ansible-debian)
- [Ultimate Ubuntu 16.04](https://github.com/erikdubois/Ultimate-Ubuntu-16.04)

## Artwork Credits

- **Logo Icon**: [Wave](https://thenounproject.com/term/wave/22591) by Vicons Design via [the Noun Project](https://thenounproject.com/)
- **Logo Font**: [Comfortaa](https://www.fontsquirrel.com/fonts/Comfortaa) by Johan Aakerlund via [Font Squirrel](https://www.fontsquirrel.com/)

## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) open source license.

---
<p align="center">🤖</p>

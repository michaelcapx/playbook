Desktop Playbook
================
[![Release](https://img.shields.io/github/release/michaelcapx/playbook.svg?style=flat-square)](https://github.com/michaelcapx/playbook/releases)
[![Build Status](https://img.shields.io/travis/michaelcapx/playbook.svg?style=flat-square)](https://travis-ci.org/michaelcapx/playbook)

Ansible playbook for setting up an Ubuntu desktop & server environment for raipid web development. There are many playbooks like it, but this one is mine.

## What's included

It will install and configure the following on a linux machine:

* Ubuntu 16.04 Xenial LTS
* Python 2.7.12
* Java OpenJDK 1.8.0
* Ruby 2.3.1
* Docker 17.06.0-ce
* Chrome Web Browser
* Firefox Web Browser

## Requirements

Make sure all dependencies have been installed before moving on:

* [Git](https://git-scm.com/) >= 2.7.4
* [Ansible](https://www.ansible.com/) >= 2.2

These requirements can be automagically installed using the provided [install.sh](https://github.com/playbook/blob/master/install.sh) script.

## Customizing the Playbook

To customize the installation, install Git and Ansible [via pip](http://docs.ansible.com/ansible/intro_installation.html#latest-releases-via-pip)
or the [Ansible offical PPA](https://launchpad.net/~ansible/+archive/ubuntu/ansible).

    $ sudo apt-add-repository ppa:ansible/ansible -y
    $ sudo apt-get update
    $ sudo apt-get install software-properties-common ansible git python-apt -y

Clone the playbook from the GitHub repository:

    git clone https://github.com/michaelcapx/playbook.git

Then you need to customize the playbook `playbook.yml` (or create a new one) to suit your needs.

To run the ansible playbook run the following command _in the same directory as this README file_:

    $ ansible-playbook playbook.yml --ask-become-pass --ask-vault-pass

Enter your sudo & vault passwords to run the playbook.

## Roles

This playbook makes use of the following roles:

| Role                 | Description                                          |
| -------------------- | ---------------------------------------------------- |
| | **Base** |
| common               | Setup and install common base packages & utilities. |
| locales              | Configure system locales and timezone. |
| users                | Setup the main admin user & config ssh keys. |
| git                  | Install [Git](https://git-scm.com/) and configure `gitconfig` and `gitignore` global. |
| python               | Install [Python](https://www.python.org/). |
| java                 | Install [Java](https://www.java.com/). |
| ruby                 | Install [Ruby](https://www.ruby-lang.org/en/) and bundler gems. |
| | **Desktop** |
| desktop              | Install a lot of useful desktop packages (meld, vlc, xclip) and settings. |
| chrome               | Install [Chromium](https://www.chromium.org/) and set policies and plugins. |
| firefox              | Install [Firefox](https://www.mozilla.org/firefox/) and set preferences and plugins. |
| sublime              | Install [Sublime Text 3](https://www.sublimetext.com/3) and the [Package Control](https://packagecontrol.io/) plugin. |
| albert               | Install [Albert](https://albertlauncher.github.io/) and set some basic configuration. |
| gimp                 | Install [Gimp](https://www.gimp.org/) and set some base configurations. |
| inkscape             | Install [Inkscape](https://inkscape.org/en/) from PPA. |
| minecraft            | Install [Minecraft](https://minecraft.net/en-us/). |
| docker               | Install [Docker](https://www.docker.com/) and [Docker Indicator](https://yktoo.com/en/software/indicator-docker). |
| themes               | Install desktop GTK themes, icons, and cursors. |
| xfce                 | Configures XFCE panels. |


## Credits

This playbook draws inspiration from the following projects:

- [Drupal VM](https://github.com/geerlingguy/drupal-vm)
- [Ansible Ubuntu](https://github.com/Benoth/ansible-ubuntu)
- [Roots Trellis](https://github.com/roots/trellis)
- [Laravel Settler](https://github.com/laravel/settler)

## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) open source license.

---
<p align="center">🤖</p>

Desktop Playbook
================
[![Release](https://img.shields.io/github/release/michaelcapx/playbook.svg?style=flat-square)](https://github.com/michaelcapx/playbook/releases)
[![Build Status](https://img.shields.io/travis/michaelcapx/playbook.svg?style=flat-square)](https://travis-ci.org/michaelcapx/playbook)
[![GitHub Issues](https://img.shields.io/github/issues/michaelcapx/playbook.svg?style=flat-square)](https://github.com/michaelcapx/playbook/issues)
[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat-square)](https://opensource.org/licenses/MIT)

Ansible playbook for setting up an Ubuntu desktop & server environment for raipid web development. There are many playbooks like it, but this one is mine.

## Quick Start

To reset GalliumOS, run the following from a crosh shell:

    cd ; curl -Os https://chrx.org/go && sh go -U yourname -H foobarhost

Then, from GalliumOS session, open the terminal and run:

    bash <(wget -qO - https://raw.github.com/michaelcapx/playbook/master/start.sh)

## Installation

1. Ensure Ansible & Git are installed.

    $ sudo apt-add-repository ppa:ansible/ansible -y
    $ sudo apt-get update
    $ sudo apt-get install software-properties-common ansible git python-apt -y

2. Clone this repository to your local drive.

    $ git clone https://github.com/michaelcapx/playbook.git

3. Run the Ansible playbook from inside this directory.

    ansible-playbook playbook.yml -i inventory -K --vault-id @prompt

4. Enter your SUDO and vault password when prompted. 

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
- [Cloudbox](https://github.com/Cloudbox/Cloudbox)
- [AnsiPress](https://github.com/AnsiPress/AnsiPress)
- [Ultimate Ubuntu 16.04](https://github.com/erikdubois/Ultimate-Ubuntu-16.04)
- [Ubuntu Post Install Scripts](https://github.com/snwh/ubuntu-post-install)

## License

This project is licensed under the [MIT](https://choosealicense.com/licenses/mit/) open source license.

---
<p align="center">🤖</p>

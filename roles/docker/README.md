# Ansible Role: Docker

An Ansible Role that installs [Docker](https://www.docker.com) on Linux.

## Installation

Remove old versions

    sudo apt remove docker docker-engine docker.io

Update the package index

    sudo apt update

Install Docker dependencies

    sudo apt install apt-transport-https ca-certificates curl software-properties-common

Add Docker’s official GPG key:

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

Verify the fingerprint

    sudo apt-key fingerprint 0EBFCD88

Setup the stable repository

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"


Update the apt package index

    sudo apt update

Install the latest version of Docker CE

    sudo apt install docker-ce

Verify that Docker CE is installed correctly by running the hello-world image

    sudo docker run hello-world

Create the docker group

    sudo groupadd docker

Add your user to the docker group

    sudo usermod -aG docker $USER

Verify that you can run docker commands without sudo

    docker run hello-world

Change docker folder permissions

    sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
    sudo chmod g+rwx "/home/$USER/.docker" -R

Configure Docker to start on boot

    sudo systemctl enable docker

Disable Docker to start on boot

    sudo systemctl disable docker

## Credits

This role takes inspiration from the following Ansible roles:

- [franklinkim.docker](https://github.com/weareinteractive/ansible-docker)
- [franklinkim.docker-compose](https://github.com/weareinteractive/ansible-docker-compose)
- [azavea.docker](https://github.com/azavea/ansible-docker)
- [dochang.docker](https://github.com/dochang/ansible-role-docker)
- [marvinpinto.docker](https://github.com/marvinpinto/ansible-role-docker)
- [geerlingguy.docker](https://github.com/geerlingguy/ansible-role-docker)
- [angstwad.docker_ubuntu](https://github.com/angstwad/docker.ubuntu)
- [sansible.docker](https://github.com/sansible/docker)
- [eendroroy.docker-ce](https://github.com/eendroroy/ansible-role-docker-ce)
- [mongrelion.docker](https://github.com/mongrelion/ansible-role-docker)
- [gorsuch.docker](https://github.com/gorsuch/ansible-docker-role)
- [ypsman.docker](https://github.com/ypsman/ansible-docker)
- [abaez.docker](https://github.com/abaez/ansible-role-docker)
- [jgeusebroek.docker](https://github.com/jgeusebroek/ansible-role-docker)
- [andrewrothstein.docker-py](https://github.com/andrewrothstein/ansible-docker-py)
- [avinetworks.docker](https://github.com/avinetworks/ansible-role-docker)
- [nexeck.docker](https://github.com/nexeck/ansible-docker)
- [grycap.docker](https://github.com/grycap/ansible-role-docker)

# Ansible Role: Dotfiles

Installs personal dotfiles. Ansible role for bare cloning dotfiles to dotfiles_user's $HOME/.dotfiles.git

## Requirements

A user must exist for you to use this role, and a bare git repo containing all dotfiles in that user's $HOME as outlined in this article:

https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/

## Installation

1. Initialize a bare git repository.

    git init --bare $HOME/.dotfiles

2. Create an alias.

    alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

3. Add the alias to the `.bashrc` file.

    echo "alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'" >> $HOME/.bashrc

4. Source the `.bashrc` file.

    source ~/.bashrc

5. Configure git to not show untracked files.

    dotfiles config --local status.showUntrackedFiles no

6. Add files to the git repo.

    dotfiles add ~/.bashrc

## Credits

This role takes inspiration from the following Ansible roles:

- [Ilyes512.dotfiles](https://github.com/Ilyes512/ansible-role-dotfiles)
- [ngpestelos.dotfiles](https://github.com/ngpestelos/ansible-role-dotfiles)
- [issmirnov.dotfiles](https://github.com/issmirnov/ansible-role-dotfiles)
- [ANXS.bootstraps](https://github.com/ANXS/bootstraps)
- [markushartman.dotfiles](https://github.com/markushartman/ansible-role-dotfiles)
- [kentrino.dotfiles](https://github.com/kentrino/ansible-role-dotfiles)
- [escapace.dotfiles](https://github.com/escapace/ansible-dotfiles)

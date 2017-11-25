Provision Resources
===================

A curated list of resources to help with provisioning a
Chromebook to an Ubuntu development environment with Crouton.

Contents
--------

- [Ansible](#ansible)
  - [Ansible Playbooks](#ansible-playbooks)
  - [Ansible Roles](#ansible-roles)
  - [Ansible Skeleton Roles](#ansible-skeleton-roles)
  - [Ansible Base Roles](#ansible-base-roles)
  - [Ansible Top Roles](#ansible-top-roles)
  - [Ansible Developers](#ansible-developers)
  - [Ansible Tutorials](#ansible-tutorials)
- [Theming](#theming)
  - [GTK Themes](#gtk-themes)
  - [Icon Themes](#icon-themes)
  - [Cursor Themes](#cursor-themes)
  - [App Icons](#app-icons)
  - [Theme Extensions](#theme-extensions)
  - [Fonts](#fonts)
  - [Rice Guides](#rice-guides)
- [Sublime Text](#sublime-text)
  - [Sublime Themes](#sublime-themes)
  - [Sublime Plugins](#sublime-plugins)
  - [Sublime Settings](#sublime-settings)
  - [Sublime Guides](#sublime-guides)
- [Scripting](#scripting)
  - [Crouton Scripts](#crouton-scripts)
  - [Gallium Scripts](#gallium-scripts)
  - [Shell Scripts](#shell-scripts)
  - [Scripting Guides](#scripting-guides)
  - [Lamp Scripts](#lamp-scripts)
- [Browsers](#browsers)
  - [Firefox](#firefox)
  - [Chrome](#chrome)
- [Terminal](#terminal)
  - [Terminal Shells](#terminal-shells)
  - [Terminal Profiles](#terminal-profiles)
  - [Terminal Themes](#terminal-themes)
  - [Terminal Plugins](#terminal-plugins)
  - [Terminal Guides](#terminal-guides)
- [Development](#development)
  - [Laravel](#laravel)
  - [Vue](#vue)
  - [Other Dev](#other-dev)
- [GalliumOS](#galliumos)
- [Dotfiles](#dotfiles)
- [Commands](#commands)
- [Numix](#numix)
- [Misc](#misc)

Ansible
-------

A collection of resources relating to ansible.

### Ansible Playbooks

- [Benoth Ansible Ubuntu](https://github.com/Benoth/ansible-ubuntu): Base playbook as starting point
- [Ansibile Crouton](https://github.com/ryane/ansible-crouton): Flawed but good basis for crouton setup
- [Ansibile Playbooks](https://github.com/adithyakhamithkar/ansible-playbooks): Massive list of playbook examples
- [Laptop Build](https://github.com/ryane/laptop-build): Unorganized, but interesting playbook **REF**
- [Macbook Configuration](https://github.com/bennylope/macbook-configuration): Configuration for macbook
- [Mac Dev Playbook](https://github.com/geerlingguy/mac-dev-playbook): Good organization of local laptop playbook **REF**
- [Ansible Bootstrap Ubuntu](https://github.com/zenzire/ansible-bootstrap-ubuntu): Shows basic locale generation
- [Trellis](https://github.com/roots/trellis): Foundation for Wordpress LEMP stack development **REF**
- [Ubuntu Desktop](https://github.com/chusiang/ubuntu-desktop.ansible): Has good organization & mscorefonts installer task
- [Ansible Ubuntu Desktop](https://github.com/jdauphant/ansible-ubuntu-desktop): Shell script using git submodules to load roles
- [Ansible Desktop Ubuntu](https://github.com/lesmyrmidons/ansible-desktop-ubuntu): Simple complete desktop setup
- [Ansible Desktop](https://github.com/cdown/ansible-desktop): ArchLinux playbook
- [Ansible Desktop Ubuntu](https://github.com/ericjsilva/ansible-desktop-ubuntu): Fairly complete lamp setup
- [Ansible Desktop Post Install](https://github.com/aarnaud/ansible-ubuntu-desktop-post-install): Has minimal desktop install
- [Ansible Chromebook](https://github.com/bryfry/ansible-chromebook): Chromebook setup - has lastpass and source code pro tasks
- [Dev Setup](https://github.com/wrrn/dev-setup): Simple but complete setup. Nice layout. **REF**
- [Provisioning Local](https://github.com/JBKahn/provisioning-local): One role with bash colors and fonts setup
- [Ansible Stuff](https://github.com/diegovalle/ansible-stuff): Install tor, fonts, npm, and ohmyzsh
- [Dev Machine Playbook](https://github.com/andrew-dias/dev-machine-playbook): Base16 role and dotfiles installer
- [Ansible DevEnv](https://github.com/abesto/ansible-devenv): Uses lastpass to bootstrap **REF**
- [My Machine Provisioning](https://github.com/miciek/my-machine-provisioning): Interesting organization **REF**
- [Ansible Dev Machine](https://github.com/catsoap/ansible-dev-machine): Basic setup
- [Ansible Ubuntu](https://github.com/fabiokr/ansible-ubuntu): Organized by system, applications, development. Has DNSmasq task
- [Ansible Basic Server](https://github.com/Servers-for-Hackers/ansible-basic-server): Basic setup. Mostly unattended upgrades
- [Ross Hinkley Ansible](https://github.com/rosshinkley/ansible): SSH instructions for chromebook
- [My Ansible Setup](https://github.com/AurelienLourot/my-ansible-setup): Has interesting VLC setup and some shell scripts
- [Crouton Ansible Setup](https://github.com/stevenharford/setup): Very basic crouton setup **REF**
- [Ansible](https://github.com/jamebus/ansible): Has temp directory role and some crouton settings **REF**
- [Ansible Personal](https://gitlab.com/radek-sprta/ansible-personal): Has gitlab setup **REF**
- [Drupal VM](https://github.com/geerlingguy/drupal-vm): A VM for local Drupal development **REF**
- [Ricardo Devbox](https://github.com/ricardokirkner/devbox): Scripts to provision a development machine
- [Andromeda Playbook](https://github.com/osx/andromeda)
- [Chromebook Desktop](https://github.com/ztsmith/ansible-chromebook-desktop)
- [Setup Mac Playbook](https://github.com/daemonza/setupmac)
- [Web Playbook](https://github.com/mgcrea/ansible-web-playbooks)
- [ansible-provision-ubuntu-desktop](https://github.com/bboykov/configure-ubuntu-desktop)
- [devbox](https://github.com/moussaclarke/devbox)
- [My Ansible Playbook](https://github.com/guillaumebriday/my-ansible-playbook): This is my Ansible Playbook to fit with Ubuntu Xenial (16.04 LTS) servers and a Laravel application.
- [Laravel Server](https://github.com/Ostendorf/laravel-server): Laravel Server setup via Ansible
- [Ansible docker image to provision servers for laravel](https://github.com/ricklancee/ansible-laravel): An ansible docker image to provision servers for laravel 5.4
- [ansible-playbooks](https://github.com/eendroroy/ansible-playbooks): ansible playbooks collection
- [ansible-bootstrap-server](https://github.com/tasdikrahman/ansible-bootstrap-server): the bare essentials when you spin up a server
- [Stedding](https://github.com/Larastudio/stedding): Ansible playbooks for Laravel LEMP Stack

### Ansible Roles

- [Install Firefox with Addons](https://github.com/dype35/ansible)
- [Ansible Common Role](https://github.com/bbatsche/Ansible-Common-Role)
- [Ansible Secret](https://github.com/debops/ansible-secret)
- [Users and Groups](https://github.com/sansible/users_and_groups)
- [Ansible Users](https://github.com/debops/ansible-users)
- [Apt](https://github.com/ANXS/apt)
- [Ansible Users](https://github.com/singleplatform-eng/ansible-users)
- [WP-Cli](https://github.com/markahesketh/ansible-role-wp-cli)
- [Ansible Sendmail](https://github.com/hashbangcode/ansible-role-sendmail)
- [Ansible Apt](https://github.com/debops/ansible-apt)
- [Ansible OhMyZsh](https://github.com/gantsign/ansible-role-oh-my-zsh)
- [Ansible Plbk](https://github.com/mashimom/ohmyzsh_plbk)
- [Ansible OhMyZsh](https://github.com/samyroad/ansible-ohmyzsh)
- [Ansible GitKraken](https://github.com/gantsign/ansible-role-gitkraken)
- [Ansible Users](https://github.com/weareinteractive/ansible-users)
- [Ansible Admin Users](https://github.com/cchurch/ansible-role-admin-users)
- [Ansible Users and Groups](https://github.com/ansible-city/users_and_groups)
- [Ansible Role Linux Desktop](https://github.com/pppontusw/ansible-role-linux-desktop)
- [Sublime Drupal](https://galaxy.ansible.com/fubarhouse/sublime-drupal/)
- [XFCE Desktop](https://galaxy.ansible.com/webofmars/xfce4-desktop/)
- [Sa Lamp](https://github.com/softasap/sa-lamp): Basic LAMP

### Ansible Galaxy

- [AlphaHydrae.zsh-user](https://galaxy.ansible.com/AlphaHydrae/zsh-user/)
- [AlphaHydrae.zsh](https://galaxy.ansible.com/AlphaHydrae/zsh/)
- [KeyboardInterrupt.sublime-text-3](https://galaxy.ansible.com/KeyboardInterrupt/sublime-text-3/)
- [Oefenweb.rc-local](https://galaxy.ansible.com/Oefenweb/rc-local/)
- [Stouts.rabbitmq](https://galaxy.ansible.com/Stouts/rabbitmq/)
- [ansibl3.ubuntu_laptop](https://galaxy.ansible.com/ansibl3/ubuntu_laptop/)
- [arknoll.selenium](https://galaxy.ansible.com/arknoll/selenium/)
- [azavea.vagrant](https://galaxy.ansible.com/azavea/vagrant/)
- [azavea.virtualbox](https://galaxy.ansible.com/azavea/virtualbox/)
- [beetboxvm.phantomjs](https://galaxy.ansible.com/beetboxvm/phantomjs/)
- [blazingbarons.fail2ban](https://galaxy.ansible.com/blazingbarons/fail2ban/)
- [blazingbarons.nicer-bash-prompt](https://galaxy.ansible.com/blazingbarons/nicer-bash-prompt/)
- [dotstrap.dircolors](https://galaxy.ansible.com/dotstrap/dircolors/)
- [fabschurt.ubuntu-base](https://galaxy.ansible.com/fabschurt/ubuntu-base/)
- [fradee.mailcatcher](https://galaxy.ansible.com/fradee/mailcatcher/)
- [franklinkim.newrelic](https://galaxy.ansible.com/franklinkim/newrelic/)
- [franklinkim.users](https://galaxy.ansible.com/franklinkim/users/)
- [gantsign.default-web-browser](https://galaxy.ansible.com/gantsign/default-web-browser/)
- [gantsign.gitkraken](https://galaxy.ansible.com/gantsign/gitkraken/)
- [gantsign.oh-my-zsh](https://galaxy.ansible.com/gantsign/oh-my-zsh/)
- [gantsign.postman](https://galaxy.ansible.com/gantsign/postman/)
- [geerlingguy.adminer](https://galaxy.ansible.com/geerlingguy/adminer/)
- [geerlingguy.apache-php-fpm](https://galaxy.ansible.com/geerlingguy/apache-php-fpm/)
- [geerlingguy.apache](https://galaxy.ansible.com/geerlingguy/apache/)
- [geerlingguy.blackfire](https://galaxy.ansible.com/geerlingguy/blackfire/)
- [geerlingguy.composer](https://galaxy.ansible.com/geerlingguy/composer/)
- [geerlingguy.daemonize](https://galaxy.ansible.com/geerlingguy/daemonize/)
- [geerlingguy.docker](https://galaxy.ansible.com/geerlingguy/docker/)
- [geerlingguy.dotfiles](https://galaxy.ansible.com/geerlingguy/dotfiles/)
- [geerlingguy.elasticsearch](https://galaxy.ansible.com/geerlingguy/elasticsearch/)
- [geerlingguy.exim](https://galaxy.ansible.com/geerlingguy/exim/)
- [geerlingguy.firewall](https://galaxy.ansible.com/geerlingguy/firewall/)
- [geerlingguy.git](https://galaxy.ansible.com/geerlingguy/git/)
- [geerlingguy.java](https://galaxy.ansible.com/geerlingguy/java/)
- [geerlingguy.mailhog](https://galaxy.ansible.com/geerlingguy/mailhog/)
- [geerlingguy.memcached](https://galaxy.ansible.com/geerlingguy/memcached/)
- [geerlingguy.mysql](https://galaxy.ansible.com/geerlingguy/mysql/)
- [geerlingguy.nginx](https://galaxy.ansible.com/geerlingguy/nginx/)
- [geerlingguy.nodejs](https://galaxy.ansible.com/geerlingguy/nodejs/)
- [geerlingguy.ntp](https://galaxy.ansible.com/geerlingguy/ntp/)
- [geerlingguy.php-memcached](https://galaxy.ansible.com/geerlingguy/php-memcached/)
- [geerlingguy.php-mysql](https://galaxy.ansible.com/geerlingguy/php-mysql/)
- [geerlingguy.php-pecl](https://galaxy.ansible.com/geerlingguy/php-pecl/)
- [geerlingguy.php-pgsql](https://galaxy.ansible.com/geerlingguy/php-pgsql/)
- [geerlingguy.php-redis](https://galaxy.ansible.com/geerlingguy/php-redis/)
- [geerlingguy.php-tideways](https://galaxy.ansible.com/geerlingguy/php-tideways/)
- [geerlingguy.php-versions](https://galaxy.ansible.com/geerlingguy/php-versions/)
- [geerlingguy.php-xdebug](https://galaxy.ansible.com/geerlingguy/php-xdebug/)
- [geerlingguy.php-xhprof](https://galaxy.ansible.com/geerlingguy/php-xhprof/)
- [geerlingguy.php](https://galaxy.ansible.com/geerlingguy/php/)
- [geerlingguy.phpmyadmin](https://galaxy.ansible.com/geerlingguy/phpmyadmin/)
- [geerlingguy.pimpmylog](https://galaxy.ansible.com/geerlingguy/pimpmylog/)
- [geerlingguy.postfix](https://galaxy.ansible.com/geerlingguy/postfix/)
- [geerlingguy.postgresql](https://galaxy.ansible.com/geerlingguy/postgresql/)
- [geerlingguy.redis](https://galaxy.ansible.com/geerlingguy/redis/)
- [geerlingguy.ruby](https://galaxy.ansible.com/geerlingguy/ruby/)
- [geerlingguy.security](https://galaxy.ansible.com/geerlingguy/security/)
- [geerlingguy.solr](https://galaxy.ansible.com/geerlingguy/solr/)
- [geerlingguy.varnish](https://galaxy.ansible.com/geerlingguy/varnish/)
- [iknite.spotify](https://galaxy.ansible.com/iknite/spotify/)
- [jasonj.beanstalkd](https://galaxy.ansible.com/jasonj/beanstalkd/)
- [kbrebanov.ssmtp](https://galaxy.ansible.com/kbrebanov/ssmtp/)
- [kosssi.apt](https://galaxy.ansible.com/kosssi/apt/)
- [kosssi.gitconfig](https://galaxy.ansible.com/kosssi/gitconfig/)
- [loliee.prezto](https://galaxy.ansible.com/loliee/prezto/)
- [loliee.zsh](https://galaxy.ansible.com/loliee/zsh/)
- [luckypool.zsh](https://galaxy.ansible.com/luckypool/zsh/)
- [meatballhat.minecraft](https://galaxy.ansible.com/meatballhat/minecraft/)
- [mglaman.atom](https://galaxy.ansible.com/mglaman/mglaman/)
- [mrlesmithjr.bashrc](https://galaxy.ansible.com/mglaman/bashrc/)
- [mrlesmithjr.dnsmasq](https://galaxy.ansible.com/mglaman/dnsmasq/)
- [mrlesmithjr.mongodb](https://galaxy.ansible.com/mrlesmithjr/mongodb/)
- [mrwilson.sqlite](https://galaxy.ansible.com/mrwilson/sqlite/)
- [mychiara.wp-cli](https://galaxy.ansible.com/mychiara/wp-cli/)
- [nickhammond.logrotate](https://galaxy.ansible.com/nickhammond/logrotate/)
- [ontic.fonts](https://galaxy.ansible.com/ontic/fonts/)
- [parmegv.ansible-tor-browser-bundle](https://galaxy.ansible.com/parmegv/ansible-tor-browser-bundle/)
- [pixelart.chrome](https://galaxy.ansible.com/pixelart/chrome/)
- [softasap.sa-dev-dbgui](https://galaxy.ansible.com/softasap/sa-dev-dbgui/)
- [softasap.sa-dev-pgweb](https://galaxy.ansible.com/softasap/sa-dev-pgweb/)
- [telusdigital.python](https://galaxy.ansible.com/telusdigital/python/)
- [tersmitten.bash](https://galaxy.ansible.com/tersmitten/bash/)
- [tersmitten.locales](https://galaxy.ansible.com/tersmitten/locales/)
- [tersmitten.wordpress](https://galaxy.ansible.com/tersmitten/wordpress/)
- [theNewFlesh.sublime-config](https://galaxy.ansible.com/theNewFlesh/sublime-config/)
- [thom8.php-upload-progress](https://galaxy.ansible.com/thom8/php-upload-progress/)
- [thomfab.bashalias](https://galaxy.ansible.com/thomfab/bashalias/)
- [unrblt.firefox](https://galaxy.ansible.com/unrblt/firefox/)
- [votum.ngrok](https://galaxy.ansible.com/votum/ngrok/)
- [while-true-do.bash](https://galaxy.ansible.com/while-true-do/bash/)

### Ansible Skeleton Roles

- [Manala Roles](https://github.com/manala/ansible-roles)
- [Manala Role Skeleton](https://github.com/manala/ansible-role-skeleton)
- [Bertvv Skeleton](https://github.com/bertvv/ansible-skeleton)
- [Bertvv Role Skeleton](https://github.com/bertvv/ansible-role-skeleton)
- [Base Skeleton](https://github.com/ldez/basic-ansible-skeleton)
- [Systemli Skeleton](https://github.com/systemli/ansible-role-skeleton)
- [Cdriehuys Skeleton](https://github.com/cdriehuys/ansible-role-skeleton)
- [Elao Skeleton](https://github.com/ElaoInfra/ansible-role-skeleton)

### Ansible Base Roles

- [darkraiden](https://galaxy.ansible.com/darkraiden/ansible-base/)
- [haos616](https://galaxy.ansible.com/haos616/base/)
- [bbatsche](https://galaxy.ansible.com/bbatsche/Base/)
- [coaxial](https://galaxy.ansible.com/coaxial/base/)
- [lindahu1](https://galaxy.ansible.com/lindahu1/common/) - Platform badges
- [Ilyes512](https://galaxy.ansible.com/Ilyes512/Base/)
- [fubarhouse](https://galaxy.ansible.com/fubarhouse/commons/)
- [yabhinav](https://galaxy.ansible.com/yabhinav/common/) - OS variables
- [axelitus](https://galaxy.ansible.com/axelitus/common/) - Repo complete conditional
- [viasite](https://galaxy.ansible.com/viasite-ansible/common/)

### Ansible Top Roles

- [ANXS.postgresql](https://galaxy.ansible.com/ANXS/postgresql)
- [Datadog.datadog](https://galaxy.ansible.com/Datadog/datadog)
- [DavidWittman.redis](https://galaxy.ansible.com/DavidWittman/redis)
- [angstwad.docker_ubuntu](https://galaxy.ansible.com/angstwad/docker_ubuntu)
- [bakins.datadog](https://galaxy.ansible.com/bakins/datadog)
- [carlosbuenosvinos.ansistrano-deploy](https://galaxy.ansible.com/carlosbuenosvinos/ansistrano-deploy)
- [dev-sec.os-hardening](https://galaxy.ansible.com/dev-sec/os-hardening)
- [dev-sec.ssh-hardening](https://galaxy.ansible.com/dev-sec/ssh-hardening)
- [elastic.elasticsearch](https://galaxy.ansible.com/elastic/elasticsearch)
- [geerlingguy.apache](https://galaxy.ansible.com/geerlingguy/apache)
- [geerlingguy.composer](https://galaxy.ansible.com/geerlingguy/composer)
- [geerlingguy.firewall](https://galaxy.ansible.com/geerlingguy/firewall)
- [geerlingguy.jenkins](https://galaxy.ansible.com/geerlingguy/jenkins)
- [geerlingguy.mysql](https://galaxy.ansible.com/geerlingguy/mysql)
- [geerlingguy.nginx](https://galaxy.ansible.com/geerlingguy/nginx)
- [geerlingguy.nodejs](https://galaxy.ansible.com/geerlingguy/nodejs)
- [geerlingguy.php](https://galaxy.ansible.com/geerlingguy/php)
- [geerlingguy.security](https://galaxy.ansible.com/geerlingguy/security)
- [jdauphant.nginx](https://galaxy.ansible.com/jdauphant/nginx)
- [joshualund.golang](https://galaxy.ansible.com/joshualund/golang)
- [nickhammond.logrotate](https://galaxy.ansible.com/nickhammond/logrotate)
- [rvm_io.ruby](https://galaxy.ansible.com/rvm_io/ruby)

### Ansible Developers

- [We Are Interactive](https://galaxy.ansible.com/franklinkim)
- [Jeff Geerling](https://galaxy.ansible.com/geerlingguy)
- [Manala](https://galaxy.ansible.com/manala)
- [Telus Digital](https://galaxy.ansible.com/telusdigital)
- [Ben Batschelet](https://galaxy.ansible.com/bbatsche)
- [DebOps](https://galaxy.ansible.com/debops)
- [Stouts](https://galaxy.ansible.com/Stouts)
- [ANXS](https://galaxy.ansible.com/ANXS)
- [AnsibleBit](https://galaxy.ansible.com/ansiblebit)
- [f500](https://galaxy.ansible.com/f500)
- [ssilab](https://galaxy.ansible.com/ssilab)
- [kbrebanov](https://galaxy.ansible.com/kbrebanov)
- [Andrew Rothstein](https://galaxy.ansible.com/andrewrothstein)
- [Julien DAUPHANT](https://galaxy.ansible.com/jdauphant)
- [Oefenweb.nl](https://galaxy.ansible.com/tersmitten)
- [Sansible](https://galaxy.ansible.com/sansible)
- [Simon](https://galaxy.ansible.com/kosssi)
- [FGtatsuro](https://galaxy.ansible.com/FGtatsuro)
- [Chris Prescott](https://galaxy.ansible.com/cmprescott)
- [GantSign Ltd.](https://galaxy.ansible.com/gantsign)
- [Azavea](https://galaxy.ansible.com/azavea)
- [AerisCloud](https://galaxy.ansible.com/AerisCloud)
- [Karl Hepworth](https://galaxy.ansible.com/fubarhouse)
- [Hardening Framework](https://galaxy.ansible.com/dev-sec)
- [Emiliano Castagnari](https://galaxy.ansible.com/torian)
- [SimpliField](https://galaxy.ansible.com/SimpliField)
- [Ilyes](https://galaxy.ansible.com/Ilyes512)
- [OSXstrap](https://galaxy.ansible.com/jeremyltn/)

### Ansible Tutorials

- [Provisioning with Ansible](http://michaelpaleo.com/post/125050819225/provisioning-with-ansible)
- [Ansible: Add SSH key to Gitlab](https://www.jverdeyen.be/ansible/ansible-deploy-sshkey-gitlab)
- [Using Ansible to Bootstrap My Work Environment](https://www.scottharney.com/using-ansible-to-bootstap-my-work-environment_part_1)
- [6 practices for super smooth Ansible experience](http://hakunin.com/six-ansible-practices)
- [Setup your computers from scratch with Ansible](http://radeksprta.eu/setup-your-computers-from-scratch-with-ansible)
- [Generate SSH Keys with Ansible](https://coderwall.com/p/_ryxma/generate-ssh-keys-with-ansible)
- [Ansible using Vault](https://serversforhackers.com/video/ansible-using-vault)
- [Managing Secrets with Ansible Vault](https://dantehranian.wordpress.com/2015/07/24/managing-secrets-with-ansible-vault-the-missing-guide-part-1-of-2)
- [Pedantically Commented Playbook](https://gist.github.com/webstandardcss/9d1a293914d972399712)
- [Useful CLI Options](https://liquidat.wordpress.com/2016/02/29/useful-options-ansible-cli/)
- [Interacting with External APIs](https://linuxctl.com/2017/01/ansible---interacting-with-external-rest-api/)
- [Ansible Debconf](https://github.com/jistr/ansible-dconf)
- [Joseph Kahn](https://blog.josephkahn.io/articles/ansible/)

Theming
-------

### GTK Themes

- [Arc Theme](https://github.com/horst3180/arc-theme)
- [Arc Flatabulous](https://github.com/andreisergiu98/arc-flatabulous-theme)
- [Arc Grey](https://github.com/eti0/arc-grey-theme)
- [Arc Variants](https://github.com/geokapp/arc-variants)
- [Arc Colera](https://github.com/erikdubois/Arc-Theme-Colora)
- [Numix](https://github.com/numixproject/numix-gtk-theme)
- [ME1](http://hayderctee.deviantart.com/art/M-E-1-theme-v1-0-529122811)
- [MyFlatUI](http://steftrikia.deviantart.com/art/MyflatUI-487041669)
- [Iris Dark](http://thevirtualdragon.deviantart.com/art/Iris-Dark-Gtk-Theme-v1-10-429628194)
- [Flatabulous](https://github.com/anmoljagetia/Flatabulous)
- [Dots Theme](https://github.com/rafacuevas3/dots-theme)
- [Shiki Colors Revivial](https://github.com/Somasis/shiki-colors-revival)
- [OSX Arc White](https://github.com/LinxGem33/OSX-Arc-White)
- [OSX Arc Shadow](https://github.com/LinxGem33/OSX-Arc-Shadow)
- [OSX Arc Darker](https://github.com/LinxGem33/OSX-Arc-Darker)
- [Install Gnome Themes](https://github.com/tliron/install-gnome-themes)
- [GitHub Universe](https://githubuniverse.com/)

### Icons Themes

- [La Capitaine](https://github.com/keeferrourke/la-capitaine-icon-theme)
- [Oranchelo](https://github.com/OrancheloTeam/oranchelo-icon-theme)
- [Papirus](https://github.com/PapirusDevelopmentTeam/papirus-icon-theme)
- [Square](https://www.gnome-look.org/content/show.php/Square?content=163513)
- [Flat Remix](https://github.com/daniruiz/Flat-Remix)
- [Surfn](https://github.com/erikdubois/Surfn)
- [Elementary](https://github.com/elementary/icons)
- [Elementary+](https://github.com/mank319/elementaryPlus)

### Cursor Themes

- [Capitaine cursors](https://github.com/keeferrourke/capitaine-cursors)

### App Icons

- [Weather Mono Icons](https://github.com/kevlar1818/xfce4-weather-mono-icons)

### Theme Extensions

- [Spotify Adkiller](https://github.com/SecUpwN/Spotify-AdKiller)
- [Gnome-Shell Extension - LastPass Search Provider](https://github.com/lukehuxley/gnome-shell-extension-lastpass-search-provider)
- [Summon LastPass](https://github.com/Lugoues/summon-lastpass)
- [Adminer Theme](https://gist.github.com/phred/6d686ebedd418be1a464320ad4d6d9b4)
- [VLC Themes](https://www.deviantart.com/browse/all/customization/skins/media/vlcmedia/?offset=42)
- [Dark Linux VLC Skins](http://www.omgubuntu.co.uk/2016/08/dark-linux-vlc-themes-skins)
- [Oomox Numix Customizer](https://github.com/actionless/oomox)
- [Customize NotifyOSD](http://www.webupd8.org/2016/05/customize-notifyosd-notification.html)
- [Gimp Layout to mimic Photoshop](https://gist.github.com/xgouchet/e19b6240e4d0aaa7fc0b)
- [Extra Gimp Packages to Install](https://scottlinux.com/2010/11/23/extra-gimp-packages-you-should-install/)

### Fonts

- [What are the best programming fonts?](https://www.slant.co/topics/67/~best-programming-fonts)
- [How to get gorgeous looking fonts on ubuntu linux](http://www.binarytides.com/gorgeous-looking-fonts-ubuntu-linux/)
- [Operator Mono NerdFont](https://github.com/piq9117/operator-mono-nerdfont)
- [Installing Fira in Ubuntu](https://stevescott.ca/2016-10-20-installing-the-fira-font-in-ubuntu.html)
- [Installing Source Code Pro fonts in Ubuntu](https://gist.github.com/lucasdavila/3875946)
- [Download all OpenSans fonts from Google Fonts](https://gist.github.com/JamieMason/23fd333e079a9f523b16d3ab8198dace)

### Rice Guides

- [Xfce4 Desktop Environment Customization](https://github.com/NicoHood/NicoHood.github.io/wiki/Xfce4-Desktop-Environment-Customization)
- [The Lazy Man's Guide to Ricing Linux WMi3](https://sinister.ly/Thread-Tutorial-The-Lazy-Man-s-Guide-to-Ricing-Linux-WM-i3)
- [Rice Resources](https://rizonrice.github.io/resources)
- [Home Sweet Home](http://blog.z3bra.org/2013/10/home-sweet-home.html)
- [how to make a script to modify xfce4 panel?](https://forum.xfce.org/viewtopic.php?id=8619)
- [Thunar - only show mounted partitions](https://forum.xfce.org/viewtopic.php?id=6206)
- [Edit Places in XFCE](https://ubuntuforums.org/showthread.php?t=1346162)
- [Hide drives & bind folder from nautilus](https://bbs.archlinux.org/viewtopic.php?id=156371)
- [Disable “Recently used” in GTK file/directory selector](http://unix.stackexchange.com/questions/74031/disable-recently-used-in-gtk-file-directory-selector)
- [Modify XFCE Panel](https://forum.xfce.org/viewtopic.php?id=8619)
- [Maintain XFCE Panel elements](https://forum.xfce.org/viewtopic.php?id=11117)
- [UnixPorn Compiz Emerald](https://www.reddit.com/r/unixporn/comments/5j8l87/xfce_compiz_emerald_final_rice/)

Sublime Text
------------

### Sublime Themes

- [Charcoal](https://packagecontrol.io/packages/Charcoal)
- [Alpenglow](https://packagecontrol.io/packages/Theme%20-%20Alpenglow)
- [Spacefunk](https://packagecontrol.io/packages/Theme%20-%20Spacefunk)
- [Agila](https://packagecontrol.io/packages/Agila%20Theme)
- [Material](https://packagecontrol.io/packages/Material%20Theme)
- [Arc Dark](https://github.com/madeindjs/Sublime-Text-3-Arc-Dark-theme)
- [Arzy](https://packagecontrol.io/packages/Theme%20-%20Arzy)
- [One Dark](https://packagecontrol.io/packages/Theme%20-%20One%20Dark)
- [One Dark Color Scheme](https://packagecontrol.io/packages/One%20Dark%20Color%20Scheme)

### Sublime Plugins

- [Sync Settings](https://github.com/mfuentesg/SyncSettings)
- [Ansible](https://packagecontrol.io/packages/Ansible)
- [Markdown Table Formatter](https://packagecontrol.io/packages/Markdown%20Table%20Formatter)

### Sublime Settings

- [Sublime Text Studio](https://github.com/evandrocoan/SublimeTextStudio)
- [Sublime Collection of Plugins](https://github.com/JaredCubilla/sublime)
- [Sublime Text Preferences](https://github.com/joshnh/Sublime-Text-Preferences)
- [Sublime Preferences](https://github.com/zenorocha/sublime-preferences)
- [Sublime Text Settings](https://github.com/nathansmith/sublime-text-settings)
- [Sublime Text 3 User Settings](https://github.com/mrmartineau/SublimeText3UserSettings)
- [Sublime Text User Settings](https://github.com/OmeGak/sublime-text-user-settings)
- [Disable Font Size Scroll Wheel](https://superuser.com/questions/472468/in-sublime-text-how-do-you-disable-increase-decrease-font-size-with-ctrl-and-mo)
- [Andsens Sublime Settings](https://github.com/andsens/sublime-text-3-settings)

### Sublime Guides

- [Install Package Control for Sublime Text 3 Beta](https://gist.github.com/moomerman/4674060)
- [Add Package Control in Sublime Text 3 through the command line](http://stackoverflow.com/questions/19529999/add-package-control-in-sublime-text-3-through-the-command-line)
- [Lauching Sublime Text From Command Line](http://askubuntu.com/questions/273034/lauching-sublime-text-from-command-line)
- [Sublime Text 3 Build 3103 License Key](https://gist.github.com/rudzainy/0d5965e9b5862fe57c2d9ba5b69d24a6)
- [My essential guide to installing Sublime Text 3 Beta](https://coderwall.com/p/ekwjca/my-essential-guide-to-installing-sublime-text-3-beta)

Scripting
---------

### Crouton Scripts

- [Crouton Extra](https://github.com/jamebus/crouton-extra)
- [My Dear Watson](https://github.com/AldousP/MyDearWatson)
- [My Dear Freya](https://github.com/jeremy-breidenbach/MyDearFreya)
- [Crouton Config](https://github.com/orendon/crouton-config)
- [Template for Crouton](https://github.com/toomoresuch/template-for-crouton)
- [Crouton AMP development environment](https://github.com/cjgk/croutonsetup)
- [Kernel-headers packages to use with crouton](https://github.com/divx118/crouton-packages)
- [Use docker inside crouton on a Chromebook](https://github.com/komuW/docker_chromebook)
- [setting up LAMP stack in crouton ChromeOS](https://www.svennd.be/lamp-crouton-chromeos)
- [Chromebook install instructions](http://wiki.tekkotsu.org/index.php/Chromebook_install_instructions)
- [Steps to install Ubuntu on Chromebook](https://www.snip2code.com/Snippet/62280/Steps-to-install-Ubuntu-on-Chromebook)
- [Chromebook Automation](https://github.com/vi-s/Linux-Scripts)
- [acer chromebook c7 c710 linux using coreboot](https://github.com/equk/c710)
- [Turn your Chromebook Pixel into a web development machine](https://github.com/appsforartists/pixel_webdev)
- [PiE DevOps](https://github.com/pioneers/DevOps)
- [Crouton-buntu-Lazy-Script](https://github.com/CrashedBboy/Ubuntu-LazyScript)
- [Crouton Config](https://github.com/dpeters1/CroutonConfig)

### Gallium Scripts

- [CWK Scripts](https://github.com/brettlyons/cwk_scripts)
- [GalliumOS Setup](https://github.com/kmishra9/GalliumOS-Chromebook-Setup)
- [Coderdojo](https://github.com/mjwbenton/coderdojo-install-scripts)
- [Airgap](https://github.com/lrvick/airgap)
- [Dar Dorfiles](https://github.com/dar-irl/dotfiles)
- [iFlow Dotfiles](https://github.com/iflowfor8hours/dotfiles)
- [Chromebook Config](https://github.com/Sienfeld/chromebook-config)
- [Winky Scripts](https://github.com/arvati/winky-scripts)
- [Homesetup](https://github.com/yuwash/homesetup)
- [Linux Dotfiles](https://github.com/source-decay/Linux-Dotfiles)
- [Vimix GTK Theme](https://github.com/vinceliuice/vimix-gtk-themes)

### Shell Scripts

- [notes on setup for various environments](https://github.com/leword/boot)
- [Configuration](https://github.com/jorgeatgu/setup)
- [Bash setup script for Ubuntu servers](https://github.com/jasonheecs/ubuntu-server-setup)
- [Neurix](https://github.com/philiparvidsson/Ubuntu-Neurix)
- [Community Packages for Manjaro Linux](https://github.com/manjaro/packages-community)
- [PKGBUILDs for various free and/or OSS packages](https://github.com/elieux/app-packages)
- [Store all the automated docker hub builds](https://github.com/meertec/docker)
- [DevOps Installers](https://github.com/khilnani/devops)
- [Config](https://github.com/Destroyer/config)
- [all of my scripts for xfce..](https://github.com/s0la/scripts)
- [Linux Post Install](https://github.com/Darkhogg/linux-post-install)
- [Ubuntu Packages](https://github.com/adgellida/ubuntupackages)
- [ubuntu-xenial-provisioning](https://github.com/koooge/ubuntu-xenial-provisioning)
- [first-steps-ubuntu](https://github.com/bernardolm/first-steps-ubuntu)
- [Development Env](https://github.com/owainlewis/development-environment): Setup development environment on Ubuntu 17.04
- [provision-scripts](https://github.com/iboneyard/provision-scripts): collection or bash scripts to provision server or desktop linux
- [WP Setup](https://github.com/harryfinn/wp-setup): WordPress development provisioning tool
- [Dotfiles](https://github.com/luisdavim/dotfiles): My dotfiles and some scripts to bootstrap new workstations
- [Provisioning](https://github.com/JBlaak/Provisioning): So that everything is in place.
- [Lazy Ubuntu](https://github.com/darol100/lazydubuntu): (Deprecated )Setting Up my Drupal Enviroment in Ubuntu
- [Ubuntu Post-Install](https://github.com/snwh/ubuntu-post-install): A set of post-installation shell scripts for Ubuntu
- [Perfect Ubuntu](https://github.com/andreystarkov/perfect-ubuntu): on the way to perfect open source dev enviroment
- [Ubuntu Setup](https://github.com/mpadge/ubuntu-setup): script to configure fresh ubuntu install, or to update existing install
- [Post Isntall Apps](https://github.com/davidprush/PostInstallApps): Bash script to install apps after fresh install of Ubuntu.
- [Alraa Dotfiles](https://github.com/alrra/dotfiles): macOS / Ubuntu dotfiles
- [Post-installation Scripts](https://github.com/aldomann/apps-scripts): Post-installation scripts for GNU/Linux systems
- [Lazy-Xerus](https://github.com/Cypresslin/lazy-xerus): Laziness is humanity
- [Arch Linux Installation Scripts](https://github.com/Archetylator/arch-linux): Arch Linux Installation Script
- [Ubuntu After Effects](https://github.com/tprasadtp/ubuntu-post-install): Post Install Script for Ubuntu and its derivatives
- [dotfiles](https://github.com/gmarmstrong/dotfiles): Runtime configuration files, maintenance scripts, and post-installation scripts for my Unix-like systems
- [postinstall.sh](https://github.com/Cyclenerd/postinstall): Bash Script to automate post-installation steps
- [elementary-post-install](https://github.com/Djaler/elementary-post-install)
- [Ubuntu Setup Note](https://github.com/kaosf/ubuntu-setup): Ubuntu setup commands log

### Scripting Guides

- [Awesome command line apps](https://github.com/herrbischoff/awesome-command-line-apps)
- [Awesome OSX command line](https://github.com/herrbischoff/awesome-osx-command-line)
- [how to install imagemagick for php7 on ubuntu 16.04?](http://askubuntu.com/questions/769396/how-to-install-imagemagick-for-php7-on-ubuntu-16-04)
- [Is there a link to GitHub for downloading a file in the latest release of a repository?](http://stackoverflow.com/questions/24987542/is-there-a-link-to-github-for-downloading-a-file-in-the-latest-release-of-a-repo)
- [Bash Script Testing Library (BSTL)](https://github.com/rafritts/BashScriptTestingLibrary)

### Lamp Scripts

- [lnmp](https://github.com/lj2007331/lnmp)
- [lamp](https://github.com/lj2007331/lamp)
- [lemp](https://github.com/lj2007331/lempstack)
- [teddysun](https://github.com/teddysun/lamp)
- [Perfect Apache Configuration](https://github.com/gregrickaby/The-Perfect-Apache-Configuration)
- [vHost Manager](https://github.com/Marko-M/lamp-vhost-manager)
- [Laravel lemp installation](https://github.com/naveenyagati/Laravel-Lemp-Installation)
- [Lemp Stack](https://github.com/lucien144/lemp-stack)

Browsers
--------

### Browser Privacy

- [ICSI: Netalyzr](http://netalyzr.icsi.berkeley.edu/)
- [Dataskydd: Web Privacy Check](https://webbkoll.dataskydd.net/en)
- [heise Netze: Webcheck](https://www.heise.de/netze/tools/webcheck/)
- [Mozilla: Observatory](https://observatory.mozilla.org/)
- [MxToolBox: Network Tools](https://mxtoolbox.com/NetworkTools.aspx)
- [Qualys SSL Labs: SSL Server Test](https://www.ssllabs.com/ssltest/analyze.html)
- [Secure Email Test Tools and Services](https://www.checktls.com/index.html)
- [badssl.com: Dashboard](https://badssl.com/dashboard/)
- [BrowserLeaks: Web Browser Security](https://browserleaks.com/)
- [Qualys SSL Labs: SSL/TLS Capabilities of Your Browser](https://www.ssllabs.com/ssltest/viewMyClient.html)
- [Email Privacy Tester](https://emailprivacytester.com/)
- [heise Security: Emailcheck](https://www.heise.de/security/dienste/Emailcheck-2109.html)
- [Grepular: ParseMail](https://www.parsemail.org/)

### Firefox

- [Install Firefox addon/extension with no user interaction](https://gist.github.com/eddiejaoude/0076739fe610189581d0)
- [How to install Firefox addon from command line in scripts?](http://askubuntu.com/questions/73474/how-to-install-firefox-addon-from-command-line-in-scripts)
- [How do I change Firefox's `about:config` from a shell script?](http://askubuntu.com/questions/313483/how-do-i-change-firefoxs-aboutconfig-from-a-shell-script)
- [Download Firefox addons](https://github.com/raingloom/archisos/blob/master/releng/ffaddons.sh)
- [Locking Down Firefox](https://leotindall.com/tutorial/locking-down-firefox/)
- [How to make Firefox more secure using about:config](https://www.bestvpn.com/make-firefox-secure-using-aboutconfig/)
- [Firefox bullshit removal](https://gist.github.com/haasn/69e19fc2fe0e25f3cff5)
- [User.js](https://github.com/pyllyukko/user.js)
- [My Mozilla Settings](https://github.com/gunnersson/my_Mozilla_settings)
- [Profilemaker](https://github.com/allo-/firefox-profilemaker)
- [ghacks user](https://github.com/ghacksuserjs/ghacks-user.js)
- [MozillaZine: "about:config"](http://kb.mozillazine.org/About:config)
- [MozillaZine: "user.js"](http://kb.mozillazine.org/User.js_file) 
- [GH: allo-/firefox-profilemaker Wiki](https://github.com/allo-/firefox-profilemaker/wiki)


### Chrome

- [Linux Quick Start](http://www.chromium.org/administrators/linux-quick-start)
- [Policy List](http://www.chromium.org/administrators/policy-list-3)
- [Deploying Google Chrome Extensions](https://www.jamf.com/jamf-nation/discussions/9246/deploying-google-chrome-extensions)
- [Alternative Extension Distribution Options](https://developer.chrome.com/extensions/external_extensions)
- [Run Chromium with flags](http://www.chromium.org/developers/how-tos/run-chromium-with-flags)
- [Download an Extension (.crx file) WITHOUT installing it?](https://productforums.google.com/forum/#!topic/chrome/g02KlhK12fU)
- [How do I automatically apply the same theme to Chromium for all new users?](http://askubuntu.com/questions/743894/how-do-i-automatically-apply-the-same-theme-to-chromium-for-all-new-users)
- [Chrome Master Preferences](https://superuser.com/questions/773614/where-can-i-find-a-full-list-of-chromes-master-preferences)
- [Other Preferences](https://www.chromium.org/administrators/configuring-other-preferences)

Terminal
--------

### Terminal Shells

- [Antigen](https://github.com/zsh-users/antigen)

### Terminal Profiles

- [Base16 XFCE Terminal](https://github.com/afg984/base16-xfce4-terminal)
- [Sexy Bash Prompt](https://github.com/twolfson/sexy-bash-prompt)
- [Cool Bash Profile](http://pastebin.com/8kJz9swQ)

### Terminal Themes

- [PowerLevel9K](https://github.com/bhilburn/powerlevel9k)
- [Pure](https://github.com/sindresorhus/pure)
- [Panda](http://panda.siamak.work)
- [One Half](https://github.com/sonph/onehalf)
- [Spaceship](https://github.com/denysdovhan/spaceship-zsh-theme)
- [Nord](https://github.com/arcticicestudio/nord-xfce-terminal)
- [iTerm Colors](https://github.com/bahlo/iterm-colors)
- [Gogh](https://github.com/Mayccoll/Gogh)
- [Parsec](https://github.com/keith/parsec)
- [Dracula](https://draculatheme.com/)

### Terminal Plugins

- [Powerline Fonts](https://github.com/powerline/fonts)
- [OH My Git](https://github.com/arialdomartini/oh-my-git)

### Terminal Guides

- [Base16 Color Guide](https://chriskempson.github.io/base16/)
- [Bash Ez Prompt Builder](http://ezprompt.net/)
- [BashRC Generator](http://bashrcgenerator.com/)
- [Awesome Shell](https://github.com/alebcay/awesome-shell)
- [Useful & Interesting Bash Prompts](https://www.maketecheasier.com/8-useful-and-interesting-bash-prompts/)
- [Bash Prompts](https://sanctum.geek.nz/arabesque/bash-prompts/)
- [Quick Zsh Install Guide](http://casparwre.de/blog/zsh-in-ubuntu/)
- [Terminals are Sexy](https://github.com/k4m4/terminals-are-sexy)
- [How to change the theme of XFCE terminal](https://simplyian.com/2014/03/29/how-to-change-the-theme-of-the-xfce-terminal)
- [A curated list of awesome Shell frameworks, libraries and software](https://github.com/uhub/awesome-shell)

Development
-----------

### Laravel

- [Laravel Blade Directives](https://github.com/appstract/laravel-blade-directives)
- [Laravel Page Speed](https://github.com/renatomarinho/laravel-page-speed)
- [Fixhub](https://github.com/Fixhub/Fixhub)

### Vue

- [VueJS Styleguide](https://github.com/jackbarham/vuejs-style-guide)
- [VueBoot](https://github.com/Morgul/vueboot)

### Other Dev

- [Sass Boilerplate](https://github.com/HugoGiraudel/sass-boilerplate)
- [Roose](http://gentolab.com/demo/roosa/latest/index.html)
- [Coloring SVGs](https://codepen.io/noahblon/post/coloring-svgs-in-css-background-images)
- [Draggable](https://github.com/Shopify/draggable)
- [Marketing for Engineers](https://github.com/LisaDziuba/Marketing-for-Engineers)
- [Instagram API](https://github.com/mgp25/Instagram-API)
- [Mailspring](https://github.com/Foundry376/Mailspring)


GalliumOS
---------

- [Audio Issue](https://github.com/GalliumOS/galliumos-distro/issues/318)
- [Chrx](https://github.com/reynhout/chrx)
- [NickJJ Blog](https://nickjanetakis.com/blog/transform-a-toshiba-chromebook-cb35-into-a-linux-development-environment-with-galliumos)
- [Chromebook Recovery Utility](https://support.ctl.net/hc/en-us/articles/229723947-Chromebook-Recovery-Utility)
- [How to force Reboot a Chromebook](https://blog.cartyville.com/2016/10/26/how-to-force-reboot-a-chromebook)
- [Mr. Chromebox](https://mrchromebox.tech)
- [Braveasbrass](https://braveasbrass.wordpress.com/2016/12/31/install-galliumos-on-acer-chromebook-14-cb3-431)
- [GalliumOS on Edgar](https://gist.github.com/stupidpupil/1e88638e5240476ec1f77d4b27747c88)
- [Autodetect Headphones](https://www.reddit.com/r/GalliumOS/comments/6qextn/question_autodetect_headphones/)
- [Installing VirtualBox & Docker](https://www.reddit.com/r/GalliumOS/comments/6ly5se/galliumos_and_virtualboxdocker/)
- [Security on GalliumOS](https://www.reddit.com/r/GalliumOS/comments/6ig7jz/security_on_galliumos/)
- [What to do After Install](https://www.reddit.com/r/GalliumOS/comments/4y3jjn/what_to_do_after_installing_gallium_os_a_noobies/)
- [Pixel Setup Guide](https://www.reddit.com/r/GalliumOS/comments/47qeh0/pixel_setup_guide_for_gallium_os/)
- [Open Menu with Search Key](https://www.reddit.com/r/GalliumOS/comments/4n1inh/how_to_open_menu_with_search_key/)
- [Keyring Unlock](https://github.com/GalliumOS/galliumos-distro/issues/285)


Dotfiles
--------

- [Epitron Scripts](https://github.com/epitron/scripts) - Handy collection of misc. scripts.
- [DaviOSomething](https://github.com/davidosomething/dotfiles) - Impressive list of dotfiles
- [OSX Dev Setup](https://github.com/donnemartin/dev-setup) - Useful walkthrough of scripts.
- [Mr. Zool](https://github.com/mrzool/dotfiles) - Nice color prompts
- [Foggalong](https://github.com/Foggalong/.files)
- [Dotfiles XFCE](https://github.com/sergeylukin/dotfiles-xfce)
- [joelbrewster](https://github.com/joelbrewster/dotfiles)
- [jpmurray](https://github.com/jpmurray/dotfiles)
- [lewagon](https://github.com/lewagon/dotfiles)
- [Rawnly](https://github.com/Rawnly/dot-files)
- [avindra](https://github.com/avindra/dotfiles)
- [brycekbargar](https://github.com/brycekbargar/dotfiles)
- [jcarbo](https://github.com/jcarbo/dotfiles)
- [T4ng10r](https://github.com/T4ng10r/dotfiles)
- [ljmf00](https://github.com/ljmf00/dotfiles)
- [kierantbrowne](https://github.com/kierantbrowne/dotfiles)
- [robinandeer](https://github.com/robinandeer/dotfiles)
- [herrbischoff](https://github.com/herrbischoff/dotfiles)
- [TrueFurby](https://github.com/TrueFurby/dotfiles)
- [Avivace](https://github.com/avivace/dotfiles)
- [dikiaap](https://github.com/dikiaap/dotfiles)
- [epavletic](https://github.com/epavletic/dotfiles)
- [MilanAryal](https://github.com/MilanAryal/config)
- [Shagabutdinov](https://github.com/shagabutdinov/dotfiles)
- [Meitoncz](https://github.com/Meitoncz/dotfiles)
- [jgkim](https://github.com/jgkim/ansible-role-dotfiles)
- [issmirnov](https://github.com/issmirnov/ansible-role-dotfiles)
- [swasher](https://github.com/swasher/ansible_dotfiles)
- [benigls](https://github.com/benigls/dotfiles)
- [dirn](https://github.com/dirn/ansible-dotfiles)
- [serialdoom](https://github.com/serialdoom/ansible-dotfiles)
- [aljoscha](https://github.com/aljoscha/ansible-role-dotfiles)
- [gunzy83](https://github.com/gunzy83/ansible-role-dotfiles)

Commands
--------

### Output Terminal to File

Source: http://askubuntu.com/questions/420981/how-do-i-save-terminal-output-to-a-file

```bash
command | tee output.txt
```

### Enter Bash as Root

```bash
sudo bash
```

### Print out list of installed packages

```bash
dpkg-query -Wf '${Package;-40}${Priority}\n' | sort -b -k2,2 -k1,1 > ~/Downloads/priority.txt
```

### Add Ansible directory structure

Source: https://raymii.org/s/snippets/Ansible_-_create_playbooks_and_role_file_and_folder_structure.html

```bash
mkdir -p roles/common/{tasks,handlers,templates,files,vars,defaults,meta}
touch roles/common/{tasks,handlers,templates,files,vars,defaults,meta}/main.yml
```

### Get permissions octet from file or folder

Source: https://askubuntu.com/q/152001

```bash
stat -c "%a %n" <FILEORFOLDER>
```

### List installed packages via APT

Source: https://unix.stackexchange.com/q/288024

```bash
apt --installed list
```

### Show package description via APT

Source: https://askubuntu.com/q/49578

```bash
apt-cache show scons | grep --color -E "Description-en|$"
```

### Get list of XFCE panel plugins

```bash
xfconf-query -c xfce4-panel -p /plugins -l | egrep -v '[0-9]/' | sed -e 's#/plugins/plugin-##g' | sort -rn | head -n 1
```

Misc
----

- [Devilbox](http://devilbox.org/)
- [Laradock](http://laradock.io/)
- [Streisand](https://github.com/jlund/streisand)
- [Ubuntu After Install](https://www.thefanclub.co.za/software-selection)
- [Awesome Linux Software](https://github.com/LewisVo/Awesome-Linux-Software)
- [Material MKDocs Theme](https://github.com/squidfunk/mkdocs-material)
- [Chromebook Privacy Settings Students](https://www.eff.org/deeplinks/2015/11/guide-chromebook-privacy-settings-students)
- [Automated Lamp Installation Script](https://github.com/arbabnazar/Automated-LAMP-Installation)
- [TeddySun Lamp](https://github.com/teddysun/lamp)
- [Lamp Installer](https://gist.github.com/aamnah/f03c266d715ed479eb46)
- [Ubuntu Post Install](https://gist.github.com/waleedahmad/a5b17e73c7daebdd048f823c68d1f57a)
- [Linode Lamp Install Guide](https://www.linode.com/docs/web-servers/lamp/install-lamp-stack-on-ubuntu-16-04)
- [Digital Ocean Lamp Install Guide](https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04)
- [How to Install Virtualmin with Webmin, LAMP, BIND, and PostFix on Ubuntu 16.04](https://www.digitalocean.com/community/tutorials/how-to-install-virtualmin-with-webmin-lamp-bind-and-postfix-on-ubuntu-16-04)

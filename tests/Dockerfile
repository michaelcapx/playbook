FROM ubuntu:16.04
LABEL maintainer="Polymimetic"

# Install dependencies.
RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
       python-software-properties \
       software-properties-common \
       python-apt python-dev python-jmespath python-pip python-setuptools \
       rsyslog systemd systemd-cron sudo \
    && rm -Rf /var/lib/apt/lists/* \
    && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
    && apt-get clean \
    && apt-get purge -y --autoremove
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf
#ADD etc/rsyslog.d/50-default.conf /etc/rsyslog.d/50-default.conf

# Install Ansible
RUN add-apt-repository -y ppa:ansible/ansible \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
     ansible \
  && rm -rf /var/lib/apt/lists/* \
  && rm -Rf /usr/share/doc && rm -Rf /usr/share/man \
  && apt-get clean

# Install Ansible inventory file
RUN echo "[local]\nlocalhost ansible_connection=local" > /etc/ansible/hosts

# Add user with password-less sudo
RUN set -x \
  && useradd -m -s /bin/bash mimeticuser \
  && echo "mimeticuser ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/mimeticuser

# Copy files
COPY ./ /home/mimeticuser/ansible
RUN set -x \
  && chown -R mimeticuser:mimeticuser /home/mimeticuser/ansible

# Switch to user
USER mimeticuser

# Change working directory
WORKDIR /home/mimeticuser/ansible

# COPY initctl_faker .
# RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

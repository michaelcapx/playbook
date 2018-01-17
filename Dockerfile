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
  && useradd -m -s /bin/bash cytopia \
  && echo "cytopia ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/cytopia

# Copy files
COPY ./ /home/cytopia/ansible
RUN set -x \
  && chown -R cytopia:cytopia /home/cytopia/ansible

# Switch to user
USER cytopia

# Change working directory
WORKDIR /home/cytopia/ansible

# COPY initctl_faker .
# RUN chmod +x initctl_faker && rm -fr /sbin/initctl && ln -s /initctl_faker /sbin/initctl

# Build test runner script
RUN set -x \
  && ( \
    echo "#!/bin/sh -eux"; \
    echo; \
    echo "# Ansible verbosity"; \
    echo "if ! set | grep '^verbose=' >/dev/null 2>&1; then"; \
    echo "    verbose=\"\""; \
    echo "else"; \
    echo "  if [ \"\${verbose}\" = \"1\" ]; then"; \
    echo "    verbose=\"-v\""; \
    echo "  elif [ \"\${verbose}\" = \"2\" ]; then"; \
    echo "    verbose=\"-vv\""; \
    echo "  elif [ \"\${verbose}\" = \"3\" ]; then"; \
    echo "    verbose=\"-vvv\""; \
    echo "  else"; \
    echo "    verbose=\"\""; \
    echo "  fi"; \
    echo "fi"; \
    echo; \
    echo "# Ansible tagged role (only run a specific tag)"; \
    echo "if ! set | grep '^tag=' >/dev/null 2>&1; then"; \
    echo "  tag=\"\""; \
    echo "fi"; \
    echo; \
    echo; \
    # ---------- [1] Only run a specific tag ----------
    echo "if [ \"\${tag}\" != \"\" ]; then"; \
      echo "  role=\"\$( echo \"\${tag}\" | sed 's/-/_/g' )\""; \
      echo "  # [install] (only tag)"; \
      echo "  ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${verbose} --diff -t \${tag}"; \
    echo; \
    echo "else"; \
    echo; \
      echo "    # [INSTALL] Normal playbook"; \
      echo "    if ! ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${verbose} --diff; then"; \
      echo "       ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${verbose} --diff"; \
      echo "    fi"; \
      echo "  fi"; \
      echo; \
      echo "  apt list --installed > install1.txt"; \
      echo; \
      \
      # ---------- Installation (full 2nd round) ----------
      echo "  # Full install 2nd round"; \
      echo "  if ! ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${verbose} --diff; then"; \
      echo "     ansible-playbook -i inventory playbook.yml --limit \${MY_HOST} \${verbose} --diff"; \
      echo "  fi"; \
      echo; \
      echo "  apt list --installed > install2.txt"; \
      echo; \
      # ---------- Validate diff ----------
      echo "  # Validate"; \
      echo "  diff install1.txt install2.txt"; \
      echo; \
    echo "fi"; \
    \
  ) > run-tests.sh \
  && chmod +x run-tests.sh

ENTRYPOINT ["./run-tests.sh"]

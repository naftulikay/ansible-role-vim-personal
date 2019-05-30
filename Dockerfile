FROM ubuntu:18.04
MAINTAINER Naftuli Kay <me@naftuli.wtf>

# install neovim
RUN DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils software-properties-common build-essential less tree \
    jq sudo git rsync curl musl musl-dev musl-tools python-apt >/dev/null && \
  add-apt-repository -y ppa:neovim-ppa/stable >/dev/null && \
  add-apt-repository -y ppa:ansible/ansible >/dev/null && \
  DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y ansible neovim >/dev/null && \
  rm -fr /var/lib/apt/lists/* && \
  DEBIAN_FRONTEND=noninteractive apt-get clean >/dev/null

# create user
RUN useradd -s $(which bash) -m -G adm,sudo naftuli && \
  echo "naftuli ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/naftuli && \
  install -d -o naftuli -g naftuli -m 0755 /home/naftuli/devel

RUN mkdir -p /tmp/ansible/roles/vim-personal
COPY build/* /tmp/ansible/

# galaxy roles
RUN cd /tmp/ansible && ansible-galaxy install -f -p .ansible/galaxy-roles -r requirements.yml

# install rust
RUN cd /tmp/ansible &&  ansible-playbook -i 127.0.0.1, -c local install-rust.yml

VOLUME ["/home/naftuli/devel"]

USER naftuli
WORKDIR /home/naftuli/devel

ENTRYPOINT ["/bin/bash", "-l"]

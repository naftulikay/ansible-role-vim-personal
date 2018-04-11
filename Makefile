#!/usr/bin/make -f

DEFAULT_IMAGE:=loki
IMAGE:=$(shell echo "$${IMAGE:-$(DEFAULT_IMAGE)}")

clean:
	@docker-compose rm -fs $(IMAGE)

start:
	@docker-compose up -d $(IMAGE)

shell: start
	@docker exec -it $(IMAGE) bash

test: start
	@docker exec $(IMAGE) ansible --version
	@docker exec $(IMAGE) wait-for-boot
	@docker exec $(IMAGE) ansible-galaxy install -r /etc/ansible/roles/default/tests/requirements.yml
	@docker exec $(IMAGE) env ANSIBLE_FORCE_COLOR=yes \
		ansible-playbook /etc/ansible/roles/default/tests/playbook.yml

apply:
	@mkdir -p target/
	@rsync --exclude=.ansible/galaxy-roles -a ./ .ansible/galaxy-roles/vim-personal/
	@ansible-galaxy install -p .ansible/galaxy-roles -r requirements.yml
	@ansible-playbook -i localhost, --ask-become-pass local.yml

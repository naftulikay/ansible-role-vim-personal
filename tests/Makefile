#!/usr/bin/make -f

ifdef GITHUB_ACCESS_TOKEN
	ANSIBLE_PRIVATE_ARGS:=-e github_access_token=$(GITHUB_ACCESS_TOKEN)
else
	ANSIBLE_PRIVATE_ARGS:=
endif

galaxy:
	@if [ -e requirements.yml ]; then \
		ansible-galaxy install --force -r requirements.yml -p .ansible/galaxy-roles ; \
	fi

install: galaxy
	@mkdir -p .ansible/roles
	@rsync -a --delete --exclude=tests/ ../ .ansible/roles/default/

test: install
	@ANSIBLE_FORCE_COLOR=yes ansible-playbook -i inventory/hosts.yml \
		$(ANSIBLE_PRIVATE_ARGS) \
		playbook.yml

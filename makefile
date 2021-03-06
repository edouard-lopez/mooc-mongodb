#!/usr/bin/env make
# DESCRIPTION
# Task manager
#
# USAGE
# make [task]
#
# @author: Édouard Lopez <dev+mongodb@edouard-lopez.com>

# force use of Bash
SHELL := /bin/bash
PROJECT:=mooc-mongodb

# default is /var/lib/mongodb, but I use small root partition which cause the service to fail to start
DB_PATH:=/mnt/data/server/mongodb

run-hello-world:
	printf "Try opening: %s\n" "http://localhost:8080/hello/ed"
	python ./hello.py

# Install virtual environment (allow specific version of python)
create-virtualenv: install-pip
	printf "/!\\ untested\n"
	export WORKON_HOME=$$HOME/.virtualenvs && mkdir -p $${WORKON_HOME} || true \
	source /usr/local/bin/virtualenvwrapper.sh \
	mkvirtualenv -a $${PWD} --python=/usr/bin/python3.4 ${PROJECT} && workon \
	pip install bottle pymongo \
	pip freeze > requirements.pip

install-pip:
	printf "/!\\ untested\n"
	sudo apt-get install python
	wget -O /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
	python /tmp/get-pip.py
	pip install -U pip
	pip install virtualenv{,wrapper}

fix-config:
	printf "Changing 'dbpath'\n"
	[[ ! -d ${DB_PATH} ]] && mkdir -p "${DB_PATH}" || true
	sudo chown -R mongodb:mongodb "${DB_PATH}"
	sudo sed -i -r -e "s!^dbpath=.+!dbpath=${DB_PATH}!g" /etc/mongod.conf

install-server:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	[[ ! -f /etc/apt/sources.list.d/mongodb.list ]] \
		&& echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' \
				| sudo tee /etc/apt/sources.list.d/mongodb.list \
		|| true
	sudo apt-get update
	sudo apt-get install -y mongodb-org

install: install-server fix-config
	sudo service mongod restart

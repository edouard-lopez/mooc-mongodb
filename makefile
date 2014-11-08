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

run-hello-world:
	printf "Try opening: %s\n" "http://localhost:8080/hello/ed"
	python ./hello.py

# Install virtual environment (allow specific version of python)
create-virtualenv:
	mkvirtualenv -a $(pwd) --python=python3 ${PROJECT} -i bottle
	pip freeze > requirements.pip

install-server:
	sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
	echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
	sudo apt-get update
	sudo apt-get install -y mongodb-org
 	sudo service mongod start

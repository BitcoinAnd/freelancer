SHELL := /bin/bash -x

PWD 									?= pwd_unknown

THIS_FILE								:= $(lastword $(MAKEFILE_LIST))
export THIS_FILE
TIME									:= $(shell date +%s)
export TIME

ifeq ($(user),)
## USER retrieved from env, UID from shell.
HOST_USER								?=  $(strip $(if $(USER),$(USER),nodummy))
HOST_UID								?=  $(strip $(if $(shell id -u),$(shell id -u),4000))
#BY PASS host user 
#HOST_USER								= root
#HOST_UID								= $(strip $(if $(uid),$(uid),0))
else
# allow override by adding user= and/ or uid=  (lowercase!).
# uid= defaults to 0 if user= set (i.e. root).
HOST_USER								= $(user)
HOST_UID								= $(strip $(if $(uid),$(uid),0))
endif
export HOST_USER
export HOST_UID

ifeq ($(docker),)
#DOCKER							        := $(shell find /usr/local/bin -name 'docker')
DOCKER							        := $(shell which docker)
else
DOCKER   							:= $(docker)
endif
export DOCKER

ifeq ($(compose),)
#DOCKER_COMPOSE						        := $(shell find /usr/local/bin -name 'docker-compose')
DOCKER_COMPOSE						        := $(shell which docker-compose)
else
DOCKER_COMPOSE							:= $(compose)
endif
export DOCKER_COMPOSE

ifeq ($(alpine),)
ALPINE_VERSION							:= 3.11.6
else
ALPINE_VERSION							:= $(alpine)
endif
export ALPINE_VERSION

# PROJECT_NAME defaults to name of the current directory.
ifeq ($(project),)
PROJECT_NAME							:= $(notdir $(PWD))
else
PROJECT_NAME							:= $(project)
endif
PROJECT_NAME                            :=$(shell echo "$(PROJECT_NAME)" |  tr '[:upper:]' '[:lower:]' )
export PROJECT_NAME

#GIT CONFIG
GIT_USER_NAME							:= $(shell git config user.name)
export GIT_USER_NAME
GIT_USER_EMAIL							:= $(shell git config user.email)
export GIT_USER_EMAIL
GIT_SERVER								:= https://github.com
export GIT_SERVER
GIT_PROFILE								:= bitcoinand
export GIT_PROFILE
GIT_BRANCH								:= $(shell git rev-parse --abbrev-ref HEAD)
export GIT_BRANCH
GIT_HASH								:= $(shell git rev-parse --short HEAD)
export GIT_HASH
GIT_PREVIOUS_HASH						:= $(shell git rev-parse --short master@{1})
export GIT_PREVIOUS_HASH
GIT_REPO_ORIGIN							:= $(shell git remote get-url origin)
export GIT_REPO_ORIGIN
GIT_REPO_NAME							:= $(PROJECT_NAME)
export GIT_REPO_NAME
GIT_REPO_PATH							:= $(HOME)/$(GIT_REPO_NAME)
export GIT_REPO_PATH
DOCKERFILE  							:= Dockerfile
export DOCKERFILE
DOCKERFILE_PATH							:= $(HOME)/$(PROJECT_NAME)/$(DOCKERFILE)
export DOCKERFILE_PATH

ifeq ($(nocache),true)
NOCACHE								    := --no-cache
else
NOCACHE								    :=	
endif
export NOCACHE

ifeq ($(verbose),true)
VERBOSE									:= --verbose
else
VERBOSE									:=	
endif
export VERBOSE

ifeq ($(port),)
PUBLIC_PORT								:= 80
else
PUBLIC_PORT								:= $(port)
endif
export PUBLIC_PORT


# ref: https://github.com/linkit-group/dockerbuild/blob/master/makefile
# if you see pwd_unknown showing up, check user permissions.
#todo: more umbrel support
#todo: umbrel root no good
#todo: ref: https://github.com/getumbrel/umbrel/blob/master/security.md
ifeq ($(umbrel),true)
#comply with umbrel conventions
PWD=/home/umbrel/umbrel/apps/$(PROJECT_NAME)
UMBREL=true
else
pwd ?= pwd_unknown
UMBREL=false
endif
export PWD
export UMBREL

.PHONY: help
help: report
	@echo ''
	@echo '	[USAGE]:	make [BUILD] run [EXTRA_ARGUMENTS]	'
	@echo ''
	@echo '		make init header build run user=root uid=0 nocache=false verbose=true'
	@echo ''
	@echo '	[DEV ENVIRONMENT]:	'
	@echo ''
	@echo '		make shell  user=$(HOST_USER)'
	@echo ''
	@echo '	[EXTRA_ARGUMENTS]:	set build variables	'
	@echo ''
	@echo '		nocache=true'
	@echo '		            	add --no-cache to docker command and apk add $(NOCACHE)'
	@echo '		port=integer'
	@echo '		            	set PUBLIC_PORT default 80'
	@echo ''
	@echo ''
	@echo '	[EXAMPLE]:'
	@echo ''
	@echo '		make all run user=root uid=0 no-cache=true verbose=true'
	@echo '		make report all run user=root uid=0 no-cache=true verbose=true cmd="top"'
	@echo '		make a r port=80 no-cache=true verbose=true cmd="ls"'
	@echo ''
	@echo '	[COMMAND_LINE]:'
	@echo ''
	@echo ''

.PHONY: report
report:
	@echo ''
	@echo '	[ARGUMENTS]	'
	@echo '      args:'
	@echo '        - HOME=${HOME}'
	@echo '        - PWD=${PWD}'
	@echo '        - UMBREL=${UMBREL}'
	@echo '        - THIS_FILE=${THIS_FILE}'
	@echo '        - TIME=${TIME}'
	@echo '        - HOST_USER=${HOST_USER}'
	@echo '        - HOST_UID=${HOST_UID}'
	@echo '        - PUBLIC_PORT=${PUBLIC_PORT}'
	@echo '        - NODE_PORT=${NODE_PORT}'
	@echo '        - ALPINE_VERSION=${ALPINE_VERSION}'
	@echo '        - PROJECT_NAME=${PROJECT_NAME}'
	@echo '        - GIT_USER_NAME=${GIT_USER_NAME}'
	@echo '        - GIT_USER_EMAIL=${GIT_USER_EMAIL}'
	@echo '        - GIT_SERVER=${GIT_SERVER}'
	@echo '        - GIT_PROFILE=${GIT_PROFILE}'
	@echo '        - GIT_BRANCH=${GIT_BRANCH}'
	@echo '        - GIT_HASH=${GIT_HASH}'
	@echo '        - GIT_PREVIOUS_HASH=${GIT_PREVIOUS_HASH}'
	@echo '        - GIT_REPO_ORIGIN=${GIT_REPO_ORIGIN}'
	@echo '        - GIT_REPO_NAME=${GIT_REPO_NAME}'
	@echo '        - GIT_REPO_PATH=${GIT_REPO_PATH}'
	@echo '        - DOCKERFILE=${DOCKERFILE}'
	@echo '        - DOCKERFILE_PATH=${DOCKERFILE_PATH}'
	@echo '        - BITCOIN_CONF=${BITCOIN_CONF}'
	@echo '        - BITCOIN_DATA_DIR=${BITCOIN_DATA_DIR}'
	@echo '        - NOCACHE=${NOCACHE}'
	@echo '        - VERBOSE=${VERBOSE}'
	@echo '        - PUBLIC_PORT=${PUBLIC_PORT}'
	@echo '        - NODE_PORT=${NODE_PORT}'

.PHONY:
legit:
	legit . -m "$(TIME)" -p 0000000

.PHONY: youtube-dl
youtube-dl:
	youtube-dl -i -c --write-thumbnail --embed-thumbnail --include-ads \
		--playlist-random --min-views 310 \
		--exec 'rm {}' -f mp3 \
		--min-sleep-interval 0 --max-sleep-interval 5 \
		--write-info-json \
		https://soundcloud.com/bitcoin-and 
	ls -a

##################################################
.PHONY: start
start:
	npm run
	npm start
.PHONY: clean-install
clean-install:
	npm clean-install
.PHONY: automate
automate:
	./.github/workflows/automate.sh
.PHONY: build-scss
build:
	npm run
	npm run build
	npm run build:pug
	npm run build:scripts
	npm run build:scss
	npm run clean
	npm run start:debug
.PHONY: install
install:
	npm install

.PHONY: docker-build
docker-build:
	docker build . -t $(PROJECT_NAME)/$(HOST_USER)
.PHONY: docker-run
docker-run: docker-build
	docker run -p 3000:3000 -p 3002:3002 -p 3003:3003 -d $(PROJECT_NAME)/$(HOST_USER)
#######################
.PHONY: prune
prune:
	@echo 'prune'
	docker system prune -af
#######################
.PHONY: prune-network
prune-network:
	@echo 'prune-network'
	docker network prune -f
#######################
.PHONY: package
package: docker-build
	docker build . -t $(PROJECT_NAME)/$(HOST_USER):$(TIME)
	bash -c 'cat ~/GH_TOKEN.txt | docker login docker.pkg.github.com -u RandyMcMillan --password-stdin'
	bash -c 'docker tag $(PROJECT_NAME)/$(HOST_USER):$(TIME) docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/$(HOST_USER):$(TIME)'
	bash -c 'docker push docker.pkg.github.com/$(GIT_PROFILE)/$(PROJECT_NAME)/$(HOST_USER):$(TIME)'
########################

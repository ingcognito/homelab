SHELL := /bin/bash -e

export REPOSITORY=ingcognito
export PROJECT_NAME=supermagicdiary
export APP_REPLICA=1
export NGINX_REPLICA=1
export DB_REPLICA=1
export INTERNAL_PORT=8000
export EXPOSED_PORT=1337

ifndef BRANCH_NAME
	BRANCH_NAME = $(shell git rev-parse --abbrev-ref HEAD)
endif

ifndef TAG
	TAG = $(subst /,-,$(BRANCH_NAME))
endif

export TAG
export BRANCH_NAME

.PHONY: *

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
#

help: ## This help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

build-app:	## Builds Django container
	cd ./app/ && \
	docker build -t ${REPOSITORY}/${PROJECT_NAME}_app:${TAG} .

build-nginx:	## Builds Nginx container - needs port changed for each env
	cd ./nginx/ && \
	docker build -t ${REPOSITORY}/${PROJECT_NAME}_nginx:${TAG} .

develop: build-app build-nginx	## Builds Develop stack
	docker stack deploy -c=deploy-stack.yml ${PROJECT_NAME}-develop

deploy-staging: build-app build-nginx	##Builds staging stack
	docker stack deploy -c=deploy-stack.yml ${PROJECT_NAME}-staging

deploy-production: build-app build-nginx	## Builds production stack
	docker stack deploy -c=deploy-stack.yml ${PROJECT_NAME}

teardown-develop:	## Teardown develop
	docker stack rm ${PROJECT_NAME}-develop

teardown-staging:	## Teardown staging
	docker stack rm ${PROJECT_NAME}-staging

teardown-production:	## Teardown production
	docker stack rm ${PROJECT_NAME}

gcp-service-account:	## Creates GCP Terraform Service account and copies key to Terraform
	./gcp/service_account_remote_storage.sh && cp ./terraform-sa-keyfile.json

deploy-infra:	## Creates infrastructure in GCP
	cd terraform/ && terraform init && terraform apply

ansible:	## Runs ansible to bootstrap docker swarm
	ansible-playbook -i ./ansible/inventory ./ansible/main.yml -vvv


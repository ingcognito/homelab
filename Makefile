SHELL := /bin/bash -e

.PHONY: *

# Add the following 'help' target to your Makefile
# And add help text after each target name starting with '\#\#'
#

help: ## This help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

gcp-service-account:	## Creates GCP Terraform Service account and copies key to Terraform
	./gcp/service_account_remote_storage.sh && cp ./terraform-sa-keyfile.json

deploy-infra:	## Creates infrastructure in GCP
	cd terraform/ && terraform init && terraform apply

ansible:	## Runs ansible to bootstrap docker swarm
	ansible-playbook -i ./ansible/inventory ./ansible/main.yml -vvv


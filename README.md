# Homelab

A quick and easy way to bring up a Jenkins in GCP with minimal commands, overhead and cost.

## Description

This repository provisions resources in GCP using Terraform, configures the resources using Ansible to bring up Docker Swarm and then installs Jenkins

## Getting Started


### Dependencies

* GCP Account
* Terraform
* Ansible
* Docker
* Jenkins
* Make

### Installing

You will need a GCP account and have authenticated.
I've created a Makefile to simplify the creation of this project in three steps

```
make gcp-service-account
```
This will provision the GCP Service Account necessary to create resources using Terraform

```
make deploy-infra
```
This will initialize terraform and deploy the resources as necessary

```
make ansible
```
This will bootstrap together the Docker Swarm stack


## Acknowledgments

Inspiration, code snippets, etc.
* [Terraform GCP Modules](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
* [Docker Swarm](https://docs.docker.com/engine/swarm/)

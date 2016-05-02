This is as much a learning experiment for me as an exercise in running a container system in a production environment.  Given how complex it is to run Docker images in production and my continued conversations around this topic, I wanted to learn more about it.  What follows is my plan to build a secure system that can be deployed in a compliance-heavy environment that will support enterprise applications.

Yes, there are many ways to solve this problem, this just happens to be the approach I'm starting down, it __will__ change.

Last note, I'm using quite a few [HashiCorp](https://www.hashicorp.com/) components here as I like the way these pieces approach the problem space.


# Base Infrastructure

This will create a base system of components necessary for a distributed environment in an automated manner.

This is an ongoing effort and will grow and morph as various components are added or removed.

Initial focus is on AWS only with OpenStack support coming in later

## Tooling

The system is being developed with the following tools (list will be expanded as more things are brought in):

* [Terraform](https://www.terraform.io/) for orchestration
* [Packer](https://www.packer.io/) for image creation
* [Ansible](https://www.ansible.com/) for provisioning images during Packer run

## Components

* [CoreOS](https://coreos.com) with [Etcd](https://coreos.com/etcd/) support for the foundation of the cluster
* [Consul](https://www.consul.io/) for DNS / service discovery / distributed K/V store
* [Vault](https://www.vaultproject.io/) for secret management
* [ELK](https://www.elastic.co/) for remote logging
* [Sensu](https://sensuapp.org/) for monitoring and alerting
* [Apache Mesos](https://mesos.apache.org/) for container-like distribution of applications that are not setup for Docker/Rkt
* [Kubernetes](http://kubernetes.io/) for running Docker/Rkt
* [Docker Registry](https://docs.docker.com/registry/) for running private Docker images
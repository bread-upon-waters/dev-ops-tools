# Kubernetes (K8s) with Vagrant & Ansible

### Prerequisite 
#### 1. Install Vagrant on Windows

#### Vagrant Plugin List
$ vagrant plugin list

#### 2. Install Vagrant VertualBox WinNFSd (Manage and adds support for NFS on Windows)
$ vagrant plugin install vagrant-winnfsd

#### Insatll Sync VertualBox GuestAdditions Plugin
$ vagrant plugin install vagrant-vbguest

####
$ vagrant box update

####
$ vagrant init ubuntu/xenial64

####
$ vagrant up

## GUEST ADDITIONS
$ vagrant vagrant-vbguest --status
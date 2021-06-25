#!/bin/bash

## Run on master only
echo "[TASK 0] Run on master only "
hostnamectl set-hostname k8smaster

# Initialize Kubernetes 
echo "[TASK 1] Initialize Kubernetes "
kubeadm init --apiserver-advertise-address=192.168.33.10 --pod-network-cidr=10.244.0.0/16 >>/root/kubeinit.log

# Copy Kube Admin config
echo "[TASK 2] Copy Kube Admin config"
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown -R $(id -u):$(id -g) $HOME/.kube

# Deploy flannel networks
echo "[TASK 3] Deploy flannel networks"
sudo - vagrant -c "kubectl create -f /vagrant/kube-flannel.yml"

# Generating cluster join command
echo "[TASK 3] Generating cluster join command to /joincluster.sh"
kubeadm token --print-join-command >/joincluster.sh
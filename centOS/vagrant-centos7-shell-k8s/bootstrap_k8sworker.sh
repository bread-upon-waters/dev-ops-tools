#!/bin/bash

## Run on worker(s) only
echo "[TASK 0] Run on worker(s) only "

# Join worker nodes to the kubernetes cluster
echo "[TASK 1] Join worker nodes to the kubernetes cluster"
yum install -q -y sshpass >/dev/null 2>&1
sshpass -p "kubeadmin" scp -o  UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no k8smaster.moeketsimokopena.co.za:/joincluster.sh /joincluster.sh
bash /joincluster.sh >/dev/null 2>&1c
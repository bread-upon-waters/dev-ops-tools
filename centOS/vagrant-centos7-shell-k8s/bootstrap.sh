#!/bin/bash

## Run  both Master only
echo "[TASK 0] Run on both master & worker(s) "
yum update -y -q

# Updateing hosts file
echo "[TASK 1] Update /etc/hosts file"
cat <<EOF >> /etc/hosts
192.168.33.10 k8smaster.moeketsimokoena.co.za k8smaster
192.168.33.11 k8sworker-1.moeketsimokoena.co.za k8-worker-1
EOF
			  
# Enable docker service
echo "[TASK 2] Enable & start docker service"
systemctl enable --now docker >/dev/null 2>&1
systemctl start docker

# Disable SELinux
echo "[TASK 3] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
# reboot


# Stop & disable firewalld
echo "[TASK 4] Stop & disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld


# Add sysctl settings
echo "[TASK 5] Add sysctl settings"
cat <<EOF >>/etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable SWAP
echo "[TASK 6] Disable SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a


### Install Dependencies
#$ sudo yum install -y yum-transport-https curl

# Add yum repo file for kubernetes
echo "[TASK 7] Add yum repo file for kubernetes"
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum update -y -q

# Inatall docker
echo "[TASK 8] Install docker container engine"
yum -y -q install docker

# Install Kubernetes
echo "[TASK 9] Install Kubernetes(kubeadmin, kubelet & kubectl)"
sudo yum install -q -y kubeadm 
#yum install -qy kubeadm kubelet kubectl

### Start & enable Kubernetes service
echo "[TASK 10] Start & enable Kubernetes service"
systemctl enable kubelet >/dev/null 2>&1
systemctl start kubelet >/dev/null 2>&1

# Enable ssh password authentication 
echo "[TASK 11] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

# Set root password 
echo "[TASK 12]  Set root password"
echo "kubeadmin" | passwd --stdin root >/dev/null 2>&1

# Update vagrant user's bashrc file 
echo "[TASK 13] Update vagrant user's bashrc file"
echo "export TERM-xterm" >> /etc/bashrc
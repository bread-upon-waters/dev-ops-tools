#!/bin/bash

## Run  both Master only
echo "[TASK 0] Run on both master & worker(s) "

# Updateing hosts file
echo "[TASK 1] Update /etc/hosts file"
cat >>/etc/hosts<<EOF
192.168.33.10 k8smaster.moeketsimokoena.co.za k8smaster
192.168.33.11 k8sworker-1.moeketsimokoena.co.za k8-worker-1
EOF

# Inatall docker
echo "[TASK 2] Install docker container engine"
#yum install -q -y docker >/dev/null 2>&1 
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf list docker-ce
dnf list containerd.io --showduplicates | sort -r
# dnf install https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-docker-ce-cli-19.03.6-3.el7.x86_64.rpm 
# dnf install --nobest -qy docker-ce-3:19.03.6-3.el7 docker-ce-cli-19.03.6-3.el7 containerd.io
dnf install --nobest -qy docker-ce-3:18.09.1-3.el7
# dnf install --nobest -qy docker-ce-19.03.6 docker-ce-cli-19.03.6 containerd.io
					  
# Enable docker service
echo "[TASK 3] Enable & start docker service"
systemctl enable --now docker >/dev/null 2>&1
systemctl start docker

# Disable SELinux
echo "[TASK 4] Disable SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX/' /etc/sysconfig/selinux


# Stop & disable firewalld
echo "[TASK 5] Stop & disable firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld


# Add sysctl settings
echo "[TASK 6] Add sysctl settings"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

# Disable SWAP
echo "[TASK 7] Disable SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a


### Install Dependencies
#$ sudo yum install -y yum-transport-https curl

# Add yum repo file for kubernetes
echo "[TASK 8] Add yum repo file for kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF


# Install Kubernetes
echo "[TASK 9] Install Kubernetes(kubeadmin, kubelet & kubectl)"
yum install -qy kubeadmin kubelet kubectl

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
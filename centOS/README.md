
# Kubernetes with Vagrant & Ansible #
>> Here below is a step by step guide to setup Kubernetes(k8s) using Vagrand and Ansible on CentOS box.

> Run on both Master & Worker
### Prerequisits
**Step 0\#: General linux commands**
```
cat /etc/redhat-release  ### or
lsb_release
free -m
nproc
```

**Step 1\#: Update all repositories & install Dependencies**
```bash
sudo yum update -y && sudo yum install -y yum-transport-https python-software-properties curl
```

**Step 2\#: Add nodes to hosts file**
```bash
cat >>/etc/hosts<<EOF
192.168.33.10 k8s-master.company.co.za k8s-master
192.168.33.11 k8s-worker1.company.co.za k8s-worker1
192.168.33.12 k8s-worker2.company.co.za k8s-worker2
EOF
```

**Step 3\#: Disable SELinux**
```
setenforce 0
sed -i --follow-symlinks 's/^SELINUX=enforcing/SELINUX/' /etc/sysconfig/selinux
```

**Step 4\#: Disable & stop firewalld**
```bash
systemctl disable firewalld
systemctl stop firewalld
```

**Step 5\#: Disable Swap and delete swap record in /etc/fstab**
```bash
sudo swapoff -ad
sudo sed -i '/swap/d' /etc/fstab
```

**Step 6\#: Install docker**
```bash
sudo yum install -y docker
```

**Step 7\#: Enable & start docker**
```bash
sudo  systemctl enable docker
sudo  systemctl start docker
sudo  systemctl status docker
docker --version
```

**Step 8\#: IPTable sysctl for Kubernetes networking**
```bash
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

**Step 9\#: Add Kubernetes repo**
```bash
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=kubernetes
baseurl=https://packages.cloud.google.com/repos/yum/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg 
		https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
```

**Step 10\#: Install Kube Admin dependencies**
```bash
sudo yum install -y kubeadmin kubelet kubectl
```
**Step 11\#: Enable & start kubeAdmin**
```bash
sudo systemctl enable kubelet
sudo systemctl start kubelet
```

**Step 12\#: View network interfaces**
```bash
ifconfig
```

> Run only on Master

**Step 13\#: Copy kube config for Kubernetes Cluster**
```bash
sudo kubeadmin init --apiserver-advertise-address=192.168.33.10 --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown -R $(id -u):$(id -g) $HOME/.kube
```

**Step 14\#: Download Pod Network Definition** _(ADD `- --iface=eth1` after flanneld under args)_
```bash
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
**Step 15\#: Initialize Pod Networks for Kubernetes.** 
```bash
sudo kubectl apply -f kube-flannel.yml
```

**Step 16\#: View PODS**
```bash
kubectl get nodes
kubectl get pods --all-namespaces
```
**Step 17\#: Run the command below and execute it's result on worker nodes.**
```bash
kubeadm token create --print-join-command
```

> Run only on Worker

**Step 18\#: Execute the result from Step 17#  on all worker nodes to join the cluster.**
















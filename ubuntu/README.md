
# Kubernetes with Vagrant & Ansible #
>> Here below is a step by step guide to setup Kubernetes(k8s) using Vagrand and Ansible on Ubuntu box.

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
sudo apt update -y && sudo apt install -y apt-transport-https python-software-properties curl
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
sudo apt-add-repository ppa:ansible/ansible
sudo apt install -qy docker.io
```

**Step 7\#: Enable & start docker**
```bash
sudo  systemctl enable docker
sudo  systemctl start docker
docker --version
```

**Step 8\#: IPTable sysctl for Kubernetes networking**
```bash
cat >> /etc/sysctl.d/kubernetes.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system
```

**Step 9\#: Add Kubernetes repository key**
```bash
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add
```

**Step 10\#: Kubernetes key repository**
```bash
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main"

############## OR ###############

cat >>/etc/apt/source.list.d/kubernetes.list<<EOF
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
```

**Step 11\#: Install Kube Admin dependencies**
```bash
sudo apt install -y kubeadm kubelet kubectl kubernetes-cni
```
**Step 12\#: Enable & start kubeAdmin**
```bash
sudo systemctl enable kubelet
sudo systemctl start kubelet
```

**Step 13\#: View network interfaces**
```bash
ifconfig
```
> Run only on Master

**Step 14\#: Copy kube config for Kubernetes Cluster**
```bash
sudo kubeadmin init --apiserver-advertise-address=192.168.33.10 --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown -R $(id -u):$(id -g) $HOME/.kube
```

**Step 15\#: Download Pod Network Definition** _(ADD `- --iface=eth1` after flanneld under args)_
```bash
wget https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```
**Step 16\#: Initialize Pod Networks for Kubernetes.** 
```bash
sudo kubectl apply -f kube-flannel.yml
```

**Step 17\#: View PODS**
```bash
kubectl get nodes
kubectl get pods --all-namespaces
```
**Step 18\#: Run the command below and execute it's result on worker nodes.**
```bash
kubeadm token create --print-join-command
```

> Run only on Worker

**Step 18\#: Execute the result from Step 18#  on all worker nodes to join the cluster.**
















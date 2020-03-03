# DevOps Journey & DevOps Tools:
DevOps is a phylosophy for effective development, deployment and operation of software using the entire software development lifecycle (SDLC)
## DevOps Tools:
* Vagrant
* Ansible
* Kubernetes
* Git
* Maven
* Jenkins
* Docker

> **INSTALL VAGRANT**

**Download url:** [Vagrant](https://www.vagrantup.com/ "Vagrant")

**Step 1\#: View vagrant version**
```bash
vagrant --version
```

**Step 2\#: Add vagrant image box**
```bash
vagrant box add ubuntu/xenial64
############# OR ##############
vagrant box add centos/8
```

**Step 3\#: Initialize the vagrant box**
```bash
vagrant init ubuntu/xenial64
############# OR ##############
vagrant init centos/8
```

**Step 4\#: Bootup the machine**
```
vagrant up
```

**Step 5\#: Vagrant WinNFSd** _(Manage and adds support for NFS on Windows)_
```
vagrant plugin install vagrant-winnfsd
```

> **INSTALL ANSIBLE**

**Download url:** [Ansible](https://www.ansible.com/ "Ansible") 

**Step \#0: Update Packages & Install dependencies**
```bash
sudo apt-get update -y && sudo apt install -y software-properties-common python-software-properties
```

**Step \#1: Add Ansible Repository**
```bash
sudo apt-add-repository ppa:ansible/ansible
```

**Step \#2: Install Ansible**
```bash
sudo apt-get install -y  ansible
```

**Step \#3: Add Ansible User**
```bash
sudo adduser [USERNAME]
```

**Step \#4: Configure Ansible inventory and Groups**
```bash
echo -e "[servers]\nclient-node ansible_ssh_user=vagrant ansible_ssh_host=192.168.0.104" | sudo tee -a /etc/ansible/inventory

##### OR #####

echo -e "[servers]\n192.168.0.104\n" | sudo tee -a /etc/ansible/inventory
123.123.123.123
echo -e "[servers:vars]\nansible_ssh_user=root\nansible_ssh_private_key_file=/home/<USERNAME>/.ssh/id_rsa" | sudo tee -a /etc/ansible/inventory 
```

**Step \#5: Genenerate & configure SSH Access on ansible host computer (~/.ssh/id_rsa.pub)**
```bash
ssh-keygen -t RSA
```

**Step \#6: Copy public to Ansible remote inventory (/root/.ssh/authorized_keys)**
```bash
ssh-copy-id -i ~/.ssh/id_rsa.pub ssh_user@remote_host
```

**Step \#7: Test Ansible setup**
```bash
ansible all -i 192.168.33.11, -m ping 
ansible all -i ansible/inventory.ini -m ping 
ansible [REMOTE_HOST_SERVER]  -i ansible/inventory.ini-m ping 
ansible  [REMOTE_HOST_GROUP] -i ansible/inventory.ini -m ping
```

**Step \#8: SHOW ALL inventory IN A GROUP**
```bash
ansinble [REMOTE_HOST_GROUP] --list-inventory -i ansible/inventory.ini
```

**Step \#9: Example (ping server groups, uptime for server groups)**
```bash
ansible servers -i ansible/inventory.ini -m ping 
ansible servers -i ansible/inventory.ini -m command -args 'uptime' 
ansible servers -i ansible/inventory.ini -m command -args 'sudo apt install -y appache2'
```

**Step \#10: RUN Playbook with check**
```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check
```

**Step \#11: Apply to ALL group**
```bash
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
```

**Step \#12: Apply ONLY to loadbalancer group**
```bash
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -l loadbalancer
```

**Step \#13: Apply ONLY to groups of this tags**
```bash
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags services
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --vault-password-file .vault-pass.txt
```

> ### PACKAGES MODULES
#### OS packages:
```yml
- name: install jre
  packages: name=openjdk-8-jre state=installed
```
#### Package Repository:
```yml
- name: nodesource repository
  apt_repository:
    repo: deb https://deb.nodesource.com/node_8.x xenial main
    state: present
```

#### Python packages:
```yml
- name: tensorflow
  pip: 
    name: tensorflow 
    virtualenv: /opt/tensorflow_app
```

> ### FILES MODULES 
#### Copy file to remote system:
```yml
- name: configure
  copy:
   src: postgresql.conf
   dest: /etc/postgresql/9.5/main/postgresql.conf
   owner: postgres
   group: postgres
   mode: 0644
```

#### Copy Files, but update based on variables:
```yml
- name: standalone xml
  template:
   src: standalone.xml
   dest: /etc/wildfly/wildfly-16/standalone/configuration/standalone.xml
   owner: wildfly
   group: wildfly
   mode: 0644
```

#### Create/delete files/dirs:
```yml
- name: installing directory
  file:
   name: "/opt/apps"
   state: directory
   owner: "wildfly"
   group: "wildfly"
   mode: 0755
```

#### Update a line in a file:
```yml
- name: ensure localhost in hosts
  lineinfile:
   path: /etc/hosts
   regexp: '^127\.0\.0\.1'
   line: '127.0.0.1 localhost'
   owner: root
   group: root
   mode: 0644
```

#### Extra from tar, zip, and so on:
```yml
- name: install
  unarchive:
   src: "/opt/app.tar.gz"
   dest: "/opt/wildfly/wildfly-16/standalone/deployment"
   owner: "wildfly"
   group: "wildfly"
   creates: "/opt/wildfly/wildfly-16/bin/standalone.sh"
```

> ### SYSTEM MODULES
#### service packages:
```yml
- name: service
  service: name=apps state=installed enabled=yes
```

#### group packages:
```yml
- name: group
  group: name=apps state=present
```

#### cron:
```yml
- name: schedule yum autoupdate
  cron:
   name: yum autoupdate
   weekday: 2
   minutes: 0
   hour: 12
   user: root
   job: "YUMINTERACTIVE: 0 /usr/sbin/yum-autoupdate"
```

#### user
```yml
- name: user
  user:
   name: "apps"
   group: "apps"
   home: "/opt/apps"
   state: present
   system: yes
```
#### Seboolean
```yml
- name: allow httpd to make network connections
  seboolean:
   name: httpd_can_network_connect
   state: yes
   persistent: yes
```
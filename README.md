## DevOps Learning Journey:

## VAGRANT 
# Install vagrant
- 1. Chech vagrant version
`
$ vagrant --version
`

- 2. Add vagrant image box
`
$ vagrant box add ubuntu/xenial64
`

- 3. Initialize the vagrant box
`
$ vagrant init ubuntu/xenial64
`

- 5. Boot the machine
`
$ vagrant up
`

## ANSIBLE 
# Install Ansible on Ubuntu

- 1. Add Ansible Repository & dependencies:
`
$ sudo apt install -y software-properties-common python-software-properties
$ sudo apt-add-repository ppa:ansible/ansible
`

- 2. Update Packages & install ansible
`
sudo apt-get update -y
sudo apt-get install -y  ansible
`

- 3. Configure Ansible inventory and Groups:
`
$ echo -e "[servers]\nclient-node ansible_ssh_user=vagrant ansible_ssh_host=192.168.0.104" | sudo tee -a /etc/ansible/inventory
`

# OR
`
echo -e "[servers]\n192.168.0.104\n" | sudo tee -a /etc/ansible/inventory
123.123.123.123
echo -e "[servers:vars]\nansible_ssh_user=root\nansible_ssh_private_key_file=/home/<USERNAME>/.ssh/id_rsa" | sudo tee -a /etc/ansible/inventory 
`

- 4. Genenerate & configure SSH Access on ansible host computer (~/.ssh/id_rsa.pub)
`
$ ssh-keygen -t RSA
`

- 5. Copy public to Ansible remote inventory (/root/.ssh/authorized_keys)
`
$ ssh-copy-id -i ~/.ssh/id_rsa.pub ssh_user@remote_host
`

- 6. Test Ansible setup
`
$ ansible all -i 192.168.33.11, -m ping 
$ ansible all -i ansible/inventory.ini -m ping 
$ ansible [REMOTE_HOST_SERVER]  -i ansible/inventory.ini-m ping 
$ ansible  [REMOTE_HOST_GROUP] -i ansible/inventory.ini -m ping
`

# SHOW ALL inventory IN A GROUP
`
$ ansinble [REMOTE_HOST_GROUP] --list-inventory -i ansible/inventory.ini
`

# Example (ping server groups, uptime for server groups)
`
$ ansible servers -i ansible/inventory.ini -m ping 
$ ansible servers -i ansible/inventory.ini -m command -args 'uptime' 
$ ansible servers -i ansible/inventory.ini -m command -args 'sudo apt install -y appache2'
`

# RUN Playbook with check
`
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --check
`

# Apply to ALL group
`
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml
`

# Apply ONLY to loadbalancer group
`
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -l loadbalancer
`

# Apply ONLY to groups of this tags
`
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags services
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --vault-password-file .vault-pass.txt
`

### PACKAGES MODULES
# OS packages:
- name: install jre
  packages: name=openjdk-8-jre state=installed

# Package Repository 
`
- name: nodesource repository
  apt_repository:
    repo: deb https://deb.nodesource.com/node_8.x xenial main
    state: present
`

# Python packages:
`
- name: tensorflow
  pip: 
    name: tensorflow 
    virtualenv: /opt/tensorflow_app
`

### FILES MODULES
# Copy file to remote system
`
- name: configure
  copy:
   src: postgresql.conf
   dest: /etc/postgresql/9.5/main/postgresql.conf
   owner: postgres
   group: postgres
   mode: 0644
`

# Copy Files, but update based on variables
`
- name: standalone xml
  template:
   src: standalone.xml
   dest: /etc/wildfly/wildfly-16/standalone/configuration/standalone.xml
   owner: wildfly
   group: wildfly
   mode: 0644
`

# Create/delete files/dirs
`
- name: installing directory
  file:
   name: "/opt/apps"
   state: directory
   owner: "wildfly"
   group: "wildfly"
   mode: 0755
`

# Update a line in a file
`
- name: ensure localhost in hosts
  lineinfile:
   path: /etc/hosts
   regexp: '^127\.0\.0\.1'
   line: '127.0.0.1 localhost'
   owner: root
   group: root
   mode: 0644
`

# Extra from tar, zip, and so on
`
- name: install
  unarchive:
   src: "/opt/app.tar.gz"
   dest: "/opt/wildfly/wildfly-16/standalone/deployment"
   owner: "wildfly"
   group: "wildfly"
   creates: "/opt/wildfly/wildfly-16/bin/standalone.sh"
`

### SYSTEM MODULES
# service packages:
`
- name: service
  service: name=apps state=installed enabled=yes
`

# group packages:
`
- name: group
  group: name=apps state=present
`

# CRON
`
- name: schedule yum autoupdate
  cron:
   name: yum autoupdate
   weekday: 2
   minutes: 0
   hour: 12
   user: root
   job: "YUMINTERACTIVE: 0 /usr/sbin/yum-autoupdate"
`

# USER
`
- name: user
  user:
   name: "apps"
   group: "apps"
   home: "/opt/apps"
   state: present
   system: yes
`
# USER
`
- name: allow httpd to make network connections
  seboolean:
   name: httpd_can_network_connect
   state: yes
   persistent: yes
`
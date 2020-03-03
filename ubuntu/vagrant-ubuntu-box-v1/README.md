## Install Vagrant:

# 1. Chech vagrant version
$ vagrant --version

# 2. Add vagrant image box
$ vagrant box add ubuntu/xenial64

# 3. Initialize the vagrant box
$ vagrant init ubuntu/xenial64

# 5. Boot the machine
$ vagrant up


## ANSIBLE 
# Install Ansible on Ubunti

# 1. Add Ansible Repository & dependencies:
$ sudo apt install -y software-properties-common python-software-properties
$ sudo apt-add-repository ppa:ansible/ansible

# 2. Update Packages & install ansible
sudo apt-get update -y
sudo apt-get install -y  ansible

# 3. Configure Ansible inventory and Groups:
$ echo -e "[servers]\nclient-node ansible_ssh_user=vagrant ansible_ssh_host=192.168.0.104" | sudo tee -a /etc/ansible/inventory

# OR
echo -e "[servers]\n192.168.0.104\n" | sudo tee -a /etc/ansible/inventory
123.123.123.123
echo -e "[servers:vars]\nansible_ssh_user=root\nansible_ssh_private_key_file=/home/<USERNAME>/.ssh/id_rsa" | sudo tee -a /etc/ansible/inventory 


# 4. Genenerate & configure SSH Access on ansible host computer (~/.ssh/id_rsa.pub)
$ ssh-keygen -t RSA

# 5. Copy public to Ansible remote inventory (/root/.ssh/authorized_keys)
$ ssh-copy-id -i ~/.ssh/id_rsa.pub ssh_user@remote_host

# 6. Test Ansible setup
# 
$ ansible all -i 192.168.33.11, -m ping 
$ ansible all -i ansible/inventory.ini -m ping 
$ ansible [REMOTE_HOST_SERVER]  -i ansible/inventory.ini-m ping 
$ ansible  [REMOTE_HOST_GROUP] -i ansible/inventory.ini -m ping

# SHOW ALL inventory IN A GROUP
$ ansinble [REMOTE_HOST_GROUP] --list-inventory -i ansible/inventory.ini

# Example (ping server groups, uptime for server groups)
$ ansible servers -i ansible/inventory.ini -m ping 
$ ansible servers -i ansible/inventory.ini -m command -args 'uptime' 
$ ansible servers -i ansible/inventory.ini -m command -args 'sudo apt install -y appache2'

# Apply to ALL group
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml

# Apply ONLY to loadbalancer group
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -l loadbalancer

# Apply ONLY to groups of this tags
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --tags services
$ ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --vault-password-file .vault-pass.txt
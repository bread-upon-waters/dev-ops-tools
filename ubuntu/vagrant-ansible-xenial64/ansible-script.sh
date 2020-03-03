# 1. Add Ansible Repository & dependencies:
$ sudo apt-get install -y software-properties-common python-software-properties
$ sudo apt-add-repository ppa:ansible/ansible

# 2. Update Packages & install ansible
sudo apt-get update -y
sudo apt-get install -y  ansible

ansible --version

# sudo mkdir /home/vagrant/ansible 
# sudo chmod -R 0755 /home/vagrant/ansible/
# sudo chown -R vagrant:vagrant /home/vagrant/ansible/
# touch /home/vagrant/ansible/inventory.ini
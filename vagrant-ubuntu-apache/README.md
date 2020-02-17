$ ansible web01 -i ./vagrant/hosts.yml -m ping 
$ ansible-playbook -i ./vagrant/hosts.yml playbook.yml
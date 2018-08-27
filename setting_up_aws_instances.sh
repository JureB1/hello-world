#!/bin/bash
# Script for installing the required software to the master machine, Set Up Awscli and then run the playbook

# Install Python
apt -y update                 # Run Update
apt-get -y install python     # Install Python
apt install python-pip -y     # pip
pip install boto              # python boto module
pip install boto3             # python boto3 module

# Install Ansible
apt-get -y update
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get -y update
apt-get -y install ansible

#Install AWSCLI
apt install -y awscli                      # Install AWSCLI
aws configure                              # For adding AWS key

cd ansible
sudo ansible-playbook -i ./hosts site.yml



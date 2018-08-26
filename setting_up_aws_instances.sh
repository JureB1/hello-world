#!/bin/bash
# Script for installing the required software to the master machine, Set Up Awscli and then run the playbook

git clone https://github.com/JureB1/hello-world.git

cd hello-world
chmod 700 ansible.yml
chmod 700 ansible.sh

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

sudo ansible-playbook -i ./hosts ansible.yml   # Run the PlayBook

#!/bin/bash
# Script for installing the required software to the master machine
# Set Up Awscli then run the playbook

# Install Python
apt -y update                 # Run Update
apt-get -y install python     # Install Python

# Install Ansible
apt-get -y update
apt-get -y install software-properties-common
apt-add-repository -y ppa:ansible/ansible
apt-get -y update
apt-get -y install ansible

# Install AWSCLI
apt install -y awscli                      # Install AWSCLI
#aws configure                                # Open AWS configure file for adding the AWS key

#sudo ansible-playbook -i ./hosts ansible.yml   # Run the PlayBook
#ansible-playbook -i ./hosts wordpress.yml --private-key=~/.ssh/Ansible.pem
#sudo apt install python-pip -y #installs pip
#sudo pip install --upgrade pip #upgrades pip
#sudo pip install boto #installs python boto module
#sudo pip install boto3 #installs boto3 module
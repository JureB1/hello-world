#!/bin/bash
# Script for installing the required software to the master machine
# Set Up Awscli then run the playbook

# Install Python
sudo apt -y update                 # Run Update
sudo apt-get -y install python     # Install Python

# Install Ansible
sudo apt-get -y update
sudo apt-get -y install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get -y update
sudo apt-get -y install ansible

# Install AWSCLI
sudo apt install -y awscli                      # Install AWSCLI
sudo aws configure                                # Open AWS configure file for adding the AWS key

sudo ansible-playbook -i ./hosts install_wordpress[original].yml   # Run the PlayBook
#ansible-playbook -i ./hosts wordpress.yml --private-key=~/.ssh/Ansible.pem
#sudo apt install python-pip -y #installs pip
#sudo pip install --upgrade pip #upgrades pip
#sudo pip install boto #installs python boto module
#sudo pip install boto3 #installs boto3 module
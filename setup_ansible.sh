#!/bin/bash
#this code is used to add the required software to the control machine,
#configure awscli, and run the playbook
sudo apt update #update
sudo apt install python-pip -y #installs pip
#sudo pip install --upgrade pip #upgrades pip
sudo pip install boto #installs python boto module
sudo pip install boto3 #installs boto3 module

#install ansible by pip is not stable may failed
#sudo pip install ansible
#install ansible by ppa
sudo apt-get update
sudo apt-get install software-properties-common
sudo apt-add-repository -y ppa:ansible/ansible
sudo apt-get update
sudo apt-get install -y ansible

sudo pip install awscli #installs awscli module
aws configure #opens aws configure file
#this is where the user is prompted to add the aws key information



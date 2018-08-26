FROM ubuntu:16.04

EXPOSE 80

COPY . .

RUN apt-get update &&  apt-get install -y software-properties-common && apt-add-repository ppa:ansible/ansible && apt-get update && apt-get install -y git ansible && ansible --version

CMD ansible-playbook -i hosts --connection=local ./ansible/site.yml  & /bin/bash

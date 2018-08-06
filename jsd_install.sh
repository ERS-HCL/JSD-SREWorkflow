#!/bin/bash

#yum update -y
yum install wget git nano -y
wget http://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -ivh epel-release-latest-7.noarch.rpm

yum install epel-release -y
yum install python-pip -y
pip install pexpect
pip install --upgrade pexpect
yum install ansible -y

cd /home/
git clone https://github.com/ERS-HCL/JSD-SREWorkflow.git

ansible-playbook /home/JSD-SREWorkflow/jsd_install.yml >> /home/output.file

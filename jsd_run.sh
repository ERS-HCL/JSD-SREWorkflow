#!/bin/bash


sudo yum-config-manager --enable "Red Hat Enterprise Linux Server 7 Extra(RPMs)"
sudo yum -y install docker git nano
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker root

mkdir /root/JSD/
chown daemon:daemon /root/JSD/

su -c "setenforce 0"

docker run -d -p 80:8080 -v /root/JSD:/var/atlassian/jira/import --name JSD cptactionhank/atlassian-jira-service-desk:3.12.0


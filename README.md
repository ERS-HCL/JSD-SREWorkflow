# JSD-SREWorkflow
This repo contains the AWS Cloud formation template for installing and configuring Jira Service Desk with preconfigured workflow and automation rules for auto-ticketing and auto-remediation based on the monitoring.

This Cloud Formation template allows you to deploy an instance of Jira Service Desk on a Linux RHEL 7 VM. This Template deploys Ec2 instance in AWS Oregon Region by using default VPC and default security groups.

#  About Custom Workflow for Auto Remediation
This workflow capable of auto Remediation for disk usage. In this scenario we configured kapacitor for auto-ticketing, then JSD workflow will execute based on the Summary, Description of the issue. It will internally call Jenkins webhook to auto-remediate the disk usage of the particular Server. This will be very useful for the SRE streams to auto Ticketing and auto Remediation.

# I. Deploy JSD(Jira Service Desk) VM using AWS Cloud Formation
Deploy JSD server using the AWS Cloud Formation template in AWS CLI

##  I.a Configure AWS CLI
sudo yum install python-pip -y

Then Execute the below command to deploy Sensu Server/client

aws cloudformation deploy --template /path/of/template/file/cf_jsd.json --stack-name stackname --parameter-override SSHKey=sshkey_pair_name

In above Command provide the path for the template(cf_jsd.json) and provide SSH keypair name which is already available in your region.

##  I.b Deploy JSD server using the AWS Cloud Formation template in AWS Console
open AWS console in the browser and access Cloud Formation Service and then click on > create stack then browse your template file, then > provide stack name, then select ssh_keypair. After Creation of stack Successful, Collect JSDserver IP in output or EC2 Dashboard of AWS. Then Access Jira Service Desk Dashboard using IP.

http://JSD_ServerIP:8080/

# II. Configuring Jira service Desk with Auto Remediation workflow.
##  II.a Restoring the Jira Service Desk with Auto Remediation Workflow
Once your instance is ready access the Jira Service Desk, setup minimal settings and provides jira license. Then restore the Jira service desk with Auto Remediation workflow by following the steps.

settings --system -- Restore System --Here provide the value for Configuration file path like  --/var/atlassian/application-data/jira/import/SRE.zip

##  II.b Configuring Auto Remediation Workflow
once the restore is done, modify the webhook URL with your values. by following the below step

settings -- system -- webhooks --

To update/create webhook use the below commands

> curl --user admin:admin -X GET -H "Content-Type: application/json" http://JSDIP:8080/rest/webhooks/1.0/webhook/

> curl --user admin:admin -X PUT -d @webhook.json -H "Content-Type: application/json" http://JSDIP:8080/rest/webhooks/1.0/webhook/1

 webhook.json 
 >
 { 
    "name": "webhook name",
    "url": "http://jenkinsIP/job/jobname/",
    "excludeBody" : false 
     }
 
> curl --user admin:admin -X PUT --data { "name": "my first webhook via rest","url": "http://JenkinsIP/job/test","excludeBody" : false } -H "Content-Type: application/json" http://JSDIP:8080/rest/webhooks/1.0/webhook/1
 

# III. how to integrate Jira Service Desk with any monitoring tool for auto-ticketing.
We can use JiraServiceDesk Rest API to auto-ticketing. Here are some of the curl commands to create an issue/ticket in Jira Service Desk.

> curl -D- -X POST --data { "serviceDeskId": "5","requestTypeId": "95","requestFieldValues": {"summary": "Disk space issue opened by Kapacitor","description": "Disk usage for machine1 is 62.65 and OK" }} -H "Content-Type: application/json" http://admin:password@xx.xx.xx.xx:8080/rest/servicedeskapi/request



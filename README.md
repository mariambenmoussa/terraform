# WORK IN PROGRESS
# terraform
This project is to build an AWS infrastructure using terraform. 
The defined architecture is illustrated in the following diagram : 
![image](https://github.com/user-attachments/assets/33cdb35e-201f-4d12-8290-02052dcb66bc)

Note: For simplicity, the diagram represents only a single availability zone. However, multi-AZ deployment has been considered for the relevant services.

# AWS Services: 
- VPC + 3 subnets (Public, Private, Isolated)
- EC2 instances to run ECS services
- RDS(mysql) + Read Replica
- AWS Secrets manager for managing credentials on the RDS
- Route 53 for DNS
- Certificate Manager to manage the SSL certificate
- Amazon Cloudfront for caching web content 
- Amazon Cloudwatch for alerting and supervision
- VPN site-to-site for interconnecting
- VPC Peering for interconneccting 2 VPCs in different AWS accounts
  

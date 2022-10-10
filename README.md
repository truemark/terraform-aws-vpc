# TrueMark AWS VPC

This module wraps HashiCorp's VPC module and provides a setup that matches TrueMark's standard layout and design.


## Related Links
 - https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest

Read me file for the truemark-vpc

The following are the variables needed for setup.

cidr = "10.100.0.0/16" (cidr of network here is used for subnet_cidr)
subnet_cidr = "/16" (options /16, /17, /18, /19, /20)
az_count = 2 or 3 (Default is 2 availability zones you can change to 3)
nat_type = single_az, multi_az, or nat_instance (Default is no nat. Single_az creates a nat gateway in one of the availability zones and pushes all traffic through it. Multi_az creates a nat gateway in each availability zones. Nat_instance creates a nat ec2 instance and runs nat through that instance.)


For a /16 the subnets provisioned are as follows

Private subnets
x.x.0.0/20  (4091 hosts)
x.x.16.0/20 (4091 hosts)
x.x.32.0/20 (4091 hosts)
Open subnets
x.x.48.0/20  (open)
x.x.64.0/18  (open)
x.x.128.0/18 (open)
x.x.192.0/22 (open)
Public subnets
x.x.196.0/22 (1019 hosts)
x.x.200.0/22 (1019 hosts)
x.x.204.0/22 (1019 hosts)
Intra subnets
x.x.208.0/22 (1019 hosts)
x.x.212.0/22 (1019 hosts)
x.x.216.0/22 (1019 hosts)
Database subnets
x.x.220.0/22 (1019 hosts)
x.x.224.0/22 (1019 hosts)
x.x.228.0/22 (1019 hosts)
Elasticache subnets
x.x.232.0/22 (1019 hosts)
x.x.236.0/22 (1019 hosts)
x.x.240.0/22 (1019 hosts)
Redshift subnets
x.x.244.0/22 (1019 hosts)
x.x.248.0/22 (1019 hosts)
x.x.252.0/22 (1019 hosts)

For a /17 the subnets provisioned are as follows

Private subnets
x.x.0.0/20  (4091 hosts)
x.x.16.0/20 (4091 hosts)
x.x.32.0/20 (4091 hosts)
Open subnets
x.x.48.0/20  (open)
x.x.64.0/22  (open)
Public subnets
x.x.68.0/22 (1019 hosts)
x.x.72.0/22 (1019 hosts)
x.x.76.0/22 (1019 hosts)
Intra subnets
x.x.80.0/22 (1019 hosts)
x.x.84.0/22 (1019 hosts)
x.x.88.0/22 (1019 hosts)
Database subnets
x.x.92.0/22 (1019 hosts)
x.x.96.0/22 (1019 hosts)
x.x.100.0/22 (1019 hosts)
Elasticache subnets
x.x.104.0/22 (1019 hosts)
x.x.108.0/22 (1019 hosts)
x.x.112.0/22 (1019 hosts)
Redshift subnets
x.x.116.0/22 (1019 hosts)
x.x.120.0/22 (1019 hosts)
x.x.124.0/22 (1019 hosts)

For a /18 the subnets provisioned are as follows

Private subnets
x.x.0.0/21  (2043 hosts)
x.x.8.0/21  (2043 hosts)
x.x.16.0/21 (2043 hosts)
Open subnets
x.x.24.0/21  (open)
x.x.32.0/23  (open)
Public subnets
x.x.34.0/23 (507 hosts)
x.x.36.0/23 (507 hosts)
x.x.38.0/23 (507 hosts)
Intra subnets
x.x.40.0/23 (507 hosts)
x.x.42.0/23 (507 hosts)
x.x.44.0/23 (507 hosts)
Database subnets
x.x.46.0/23 (507 hosts)
x.x.48.0/23 (507 hosts)
x.x.50.0/23 (507 hosts)
Elasticache subnets
x.x.52.0/23 (507 hosts)
x.x.54.0/23 (507 hosts)
x.x.56.0/23 (507 hosts)
Redshift subnets
x.x.58.0/23 (507 hosts)
x.x.60.0/23 (507 hosts)
x.x.62.0/23 (507 hosts)

For a /19 the subnets provisioned are as follows

Private subnets
x.x.0.0/22  (1019 hosts)
x.x.4.0/22  (1019 hosts)
x.x.8.0/22  (1019 hosts)
Open subnets
x.x.12.0/22  (open)
x.x.16.0/24  (open)
Public subnets
x.x.17.0/23 (251 hosts)
x.x.18.0/23 (251 hosts)
x.x.19.0/23 (251 hosts)
Intra subnets
x.x.20.0/23 (251 hosts)
x.x.21.0/23 (251 hosts)
x.x.22.0/23 (251 hosts)
Database subnets
x.x.23.0/23 (251 hosts)
x.x.24.0/23 (251 hosts)
x.x.25.0/23 (251 hosts)
Elasticache subnets
x.x.26.0/23 (251 hosts)
x.x.27.0/23 (251 hosts)
x.x.28.0/23 (251 hosts)
Redshift subnets
x.x.29.0/23 (251 hosts)
x.x.30.0/23 (251 hosts)
x.x.31.0/23 (251 hosts)

For a /18 the subnets provisioned are as follows

Private subnets
x.x.0.0/24  (251 hosts)
x.x.1.0/24  (251 hosts)
x.x.2.0/24  (251 hosts)
Open subnets
x.x.3.0/24  (open)
x.x.4.0/22  (open)
x.x.8.0/25  (open)
Public subnets
x.x.8.128/25 (123 hosts)
x.x.9.0/25 (123 hosts)
x.x.9.128/25 (123 hosts)
Intra subnets
x.x.10.0/25 (123 hosts)
x.x.10.128/25 (123 hosts)
x.x.11.0/25 (123 hosts)
Database subnets
x.x.11.128/25 (123 hosts)
x.x.12.0/25 (123 hosts)
x.x.12.128/25 (123 hosts)
Elasticache subnets
x.x.13.0/25 (123 hosts)
x.x.13.128/25 (123 hosts)
x.x.14.0/25 (123 hosts)
Redshift subnets
x.x.14.128/25 (123 hosts)
x.x.15.0/25 (123 hosts)
x.x.15.128/25 (123 hosts)

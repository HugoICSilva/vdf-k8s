Terraform
=========

- Website: https://www.terraform.io
- [![Gitter chat](https://badges.gitter.im/hashicorp-terraform/Lobby.png)](https://gitter.im/hashicorp-terraform/Lobby)

<img alt="Terraform" src="https://cdn.rawgit.com/hashicorp/terraform-website/master/content/source/assets/images/logo-hashicorp.svg" width="600px">

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

The key features of Terraform are:

- **Infrastructure as Code**: Infrastructure is described using a high-level configuration syntax. This allows a blueprint of your datacenter to be versioned and treated as you would any other code. Additionally, infrastructure can be shared and re-used.

- **Execution Plans**: Terraform has a "planning" step where it generates an *execution plan*. The execution plan shows what Terraform will do when you call apply. This lets you avoid any surprises when Terraform manipulates infrastructure.

- **Resource Graph**: Terraform builds a graph of all your resources, and parallelizes the creation and modification of any non-dependent resources. Because of this, Terraform builds infrastructure as efficiently as possible, and operators get insight into dependencies in their infrastructure.

- **Change Automation**: Complex changesets can be applied to your infrastructure with minimal human interaction. With the previously mentioned execution plan and resource graph, you know exactly what Terraform will change and in what order, avoiding many possible human errors.

For more information, see the [introduction section](http://www.terraform.io/intro) of the Terraform website.

Getting Started & Documentation
-------------------------------

If you're new to Terraform and want to get started creating infrastructure, please checkout our [Getting Started](https://www.terraform.io/intro/getting-started/install.html) guide, available on the [Terraform website](http://www.terraform.io).

All documentation is available on the [Terraform website](http://www.terraform.io):

  - [Intro](https://www.terraform.io/intro/index.html)
  - [Docs](https://www.terraform.io/docs/index.html)

# AWS VDF DE ETO Terraform

## This project is maintained by Celfocus Environments Team.

```hcl

Install aws-cli
apt-get update && apt-get install awscli

aws configure$  
AWS Access Key ID [None]: ID from file
AWS Secret Access Key [None]: key from file
Default region name [None]: region in use
Default output format [None]: nothing

Change ~/.aws/config
[profile Auto_CelFocus]
region = eu-central-1

Change ~/.aws/credentials
[Auto_CelFocus]
aws_access_key_id = "ID from file"
aws_secret_access_key = "key from file"

```

### Installing Terraform
To install Terraform, find the appropriate package(https://www.terraform.io/downloads.html) for your system and download it. Terraform is packaged as a zip archive.

After downloading Terraform, unzip the package. Terraform runs as a single binary named terraform. Any other files in the package 
can be safely removed and Terraform will still function.

The final step is to make sure that the terraform binary is available on the PATH(export PATH=$PATH:/path/to/dir).


Terraform main.tf which creates VPC resources on AWS.

These resources are created:

* AWS-CLI Provider
* VPC
* VPC Endpoint (S3)
* DHCP/DNS Options Set
* NAT Gateway
* VPN Gateway
* Vpn attachment
* Internet Gateway
* Route table
* Subnet
* Route table Assoctions
* Security groups
* ACL's
* VPC Peering

## Modules started

##### Compute      ---->

* Bastion
* DTR's
* Master's
* Worker's

##### Load Balencer -->
* ALB UCP
* ALB DTR
* ALB APP

##### APP VPC -------->
* APP VPC(test)

##### Route53 DNS ---->
* Route53 UCP
* Route53 DTR

## Modules started

```hcl
.
+-- README.md
+-- main.tf
+-- modules
¦   +-- EndPoints
¦   ¦   +-- s3_tool_code.tf
¦   ¦   +-- variables.tf
¦   +-- IAM
¦   ¦   +-- s3.tf
¦   +-- ec2
¦   ¦   +-- bastion
¦   ¦   ¦   +-- ec2_bastion.tf
¦   ¦   ¦   +-- inter-dns.txt
¦   ¦   ¦   +-- user-bast-data.txt
¦   ¦   ¦   +-- variables.tf
¦   ¦   +-- worker
¦   ¦       +-- docker_worker.tf
¦   ¦       +-- dtr-data.txt
¦   ¦       +-- master-data.txt
¦   ¦       +-- outputs.tf
¦   ¦       +-- variables.tf
¦   ¦       +-- worker-data.txt
¦   +-- elb
¦   ¦   +-- elb_app
¦   ¦   ¦   +-- elb_externel.tf
¦   ¦   +-- elb_dtr
¦   ¦   ¦   +-- elb_externel.tf
¦   ¦   +-- elb_ucp
¦   ¦       +-- elb_externel.tf
¦   ¦       +-- output.elb.tf
¦   ¦       +-- variables.tf
¦   +-- peer
¦   ¦   +-- acc
¦   ¦   ¦   +-- acc.tf
¦   ¦   ¦   +-- outputs_acc.tf
¦   ¦   ¦   +-- variable.tf
¦   ¦   +-- req
¦   ¦       +-- outputs_req.tf
¦   ¦       +-- req.tf
¦   ¦       +-- variable.tf
¦   +-- route53
¦   ¦   +-- routeBASE
¦   ¦   ¦   +-- main.tf
¦   ¦   ¦   +-- output.tf
¦   ¦   ¦   +-- variable.tf
¦   ¦   +-- route_UCP
¦   ¦       +-- main.r53.tf
¦   ¦       +-- output.r53.tf
¦   ¦       +-- variable.tf
¦   +-- s3Bucket
¦   ¦   +-- s3_code.tf
¦   ¦   +-- variables.tf
¦   +-- vpc
¦       +-- vpc_app
¦       ¦   +-- main.app.tf
¦       ¦   +-- outputs.app.tf
¦       ¦   +-- terraform.tfvars
¦       ¦   +-- variables.tf
¦       +-- vpc_prod
¦           +-- main.prod.tf
¦           +-- outputs.prod.tf
¦           +-- terraform.tfvars
¦           +-- variables.tf
+-- outputs.tf
+-- terraform.tfstate
+-- terraform.tfstate.backup
+-- terraform.tfvars
+-- variables.tf

20 directories, 47 files
```


## Environments Var's

| Name                      | Description                       | Type   | Default | Required |
|---------------------------|-----------------------------------|:------:|:-------:|:--------:|
| auth\_lista               | 1º Ip WhitList                    | list   | - 		 | yes |
| auth\_lista2              | 2º Ip WhitList                    | list   | -		 | yes |
| aws\_profile              | aws used profile                  | string | -		 | yes |
| aws\_region               | used region                       | string | -		 | yes |
| bastion\_ami              | AMI used in bastion               | string | -		 | yes |
| cf\_vpc                   | ID from CF VPN                    | string | -		 | yes |
| chave                     | Standard ssh key from aws         | string | -		 | yes |
| cidrs                     | reserved ip's map for SubNets     | map    | -		 | yes |
| domain\_name              | Route53 Private domanin name      | string | -		 | yes |
| elb\_port\_ext\_1a        | port 443                          | string | -		 | yes |
| elb\_port\_ext\_1b        | port 80                           | string | -		 | yes |
| elb\_port\_ext\_2         | port 80                           | string | -		 | yes |
| elb\_protocol\_ext\_1a    | TCP                               | string | -		 | yes |
| elb\_protocol\_ext\_1b    | HTTPS                             | string | -		 | yes |
| elb\_protocol\_ext\_2     | HTTP                              | string | -		 | yes |
| instance\_type\_bastion   | Type of machine used is bastion   | string | -		 | yes |
| instance\_type\_master    | Type of machine used in Master's  | string | -		 | yes |
| instance\_type\_worker    | Type of machine used in Worker's  | string | -		 | yes |
| null\_list                | 0.0.0.0/0 IP                      | string | -		 | yes |
| privIPs                   | reserved ip's map for machines    | map    | -		 | yes |
| target\_master\_instances | reserved master ip's map          | map    | -		 | yes |
| vpc\_cidr                 | range of ips used in vpc          | string | -		 | yes |
| vpc\_list                 | IP list from VPN and VPC          | list   | -		 | yes |

## Outputs

| Name 	             |      Description        |
|--------------------|-------------------------|
| alb\_ucp-dns\_name | UCP ALB Domain Name     |
| elb\_ucp-zone\_id  | UCP private Domain ID   |
| subnet\_pub1\_ids  | Public1 SubNet ID       |
| subnet\_pub2\_ids  | Public2 SubNet ID       |
| vpc\_id 	     | Tooling VPC ID          |
| zone\_id	     | R53 private Domain ID   |


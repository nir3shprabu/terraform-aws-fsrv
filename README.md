# terraform-AWS-fsrv

This repo contains a Terraform plan for deploying a [fsrv](https://github.com/icyphox/fsrv) instance on
[AWS](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/).

FSRV

Filehost server for https://x.icyphox.sh.

# How to run application

## Clone the repo
```sh
git clone https://github.com/icyphox/fsrv
```

## Binary file creation

Put the below command after cloning the repository for creating the binaryfile of fsrv

```sh
cd fsrv

go build

./fsrv

```

## Requirements

| Name | Version |
| ---- | ------- |
| [terraform](https://www.terraform.io/downloads) | >=1.0.0 |
| [AWS](https://aws.amazon.com/) | >=4.0 |
| [GO](https://go.dev/doc/install) | >=1.19.3 |

## Providers

|Name | Version |
| --- | ------- |
| Amazon web services | >=4.0 |

## Terraform Resources

| Name | Type |
| ---------| ------------|
| [aws_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | Resource |
| [aws_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | Resource |
| [aws_subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | Resource |
| [aws_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | Resource |
| [aws_main_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association) | Resource |
| [aws_route_table_association](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | Resource |
| [aws_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | Resource |
| [aws_key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | Resource |

## Terraform Variables
 Edit the `vars.tf` file to add the variables as per your need.

| Name |  Type | Required|
| ---- |  ---- | ------- |
| `instance_name`  | string | yes |
| `aws_access_key` |  string | yes
| `aws_secret_key` | string | yes |
| `region` | string | yes |
| `public_key` |  string | yes |
| `vpc_cidr` | string | yes |
| `pubsub_cidr`| string | yes |


## How to run application through terraform
- Clone the repo
```bash 

git clone https://github.com/icyphox/fsrv

```
- Apply terraform commands

```bash
terraform init
terraform plan
terraform apply
```

## Destroy fsrv server

If you need to destroy created resource use following command `terraform destroy`

## Contributing
```bash
Dont hesitate to create a pull request
```
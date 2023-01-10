# terraform-aws-fsrv

This repo contains a Terraform plan for deploying a [fsrv](https://github.com/icyphox/fsrv) instance on
[aws](https://aws.amazon.com/) using [Terraform](https://www.terraform.io/).

# fsrv
A filehost server written in Go, which features a single-user system, storepath file serving, and supports filetype hooks


## Requirements

| Name | Version |
| ---- | ------- |
| terraform | >=1.0.0 |
| aws | >=4.0 |


## Providers

|Name | Version |
| --- | ------- |
| aws | >=4.0 |

## Terraform Resources

| Name | Type |
| ---------| ------------|
| vpc | Resource |
| aws_internet_gateway | Resource |
| aws_subnet | Resource |
| aws_route_table | Resource |
| aws_instance | Resource |
| aws_route_table_association | Resource |
| aws_security_group | Resource |
| aws_key_pair | Resource |

## Inputs

| Name |  Type | Required|
| ---- |  ---- | ------- |
| `aws_access_key` |  string | yes
| `aws_secret_key` | string | yes |
| `region` | string | yes |
| `public_key` |  string | yes |
| `vpc_cidr` | string | yes |
| `public_subnet_cidr`| string | yes |
| `vpc_name`| string | yes |
| `availability_zone`| string | yes |
| `instance_name`  | string | yes |
| `instance_type`| string | yes |
| `vpc_name`| string | yes |
| `subnet_name`| string | yes |
| `public_route`| string | yes |
| `internet_gateway_name`| string | yes |


## Contributing

Dont hesitate to create a pull request

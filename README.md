# Terraform Modules

This repo contains terraform modules 

- To create AWS S3 bucket , EKS using 'AWS Provider'
- To deploy Kubernetes Pod using 'Kubernetes' Provider

## AWS S3

The `aws-s3`  folder contains terraform modules to create an AWS S3 bucket. 
It has 3 different files: `bucket.tf` (main code) `variables.tf`(variables declared) and `output.tf`(output variables)

Different features of S3 bucket have been enabled using Terraform as shown below:

![Alt text](./screenshots/S31.png?raw=true "")
![Alt text](./screenshots/S32.png?raw=true "")
## AWS EKS

![Alt text](./screenshots/eks.png?raw=true "")


## Kubernetes Deployment (POD) using Terraform 

![Alt text](./screenshots/awskube.png?raw=true "")

**Note:** The `travis.yml` file has also been included to setup CI.
provider "aws" {
    version = "~> 2.3"
    region = "${var.region}"
}

terraform {
  required_version = "~> 0.11"
}

locals {
  worker_instance_type       = "t2.large"
  ssh_key_pair               = ""
  vpc_id                     = "vpc-12345"
  aws_region                 = "${var.region}"
  cluster_name               = "${var.cluster_name}"
  instance_worker_group_name = "testworkergroup"

}

# Cluster will be placed in these subnets:
variable "eks_subnet" {
    default =[
        "10.129.62.0/25",
        "10.129.62.128/25",
    ]
}

data "aws_subnet_ids" "eks_subnet" {
    vpc_id = "${local.vpc_id}"
    filter {
        name   = "cidr-block"
        values = "${var.eks_subnet}"
    }
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "4.0.2"

  cluster_name    = "${local.cluster_name}"
  cluster_version = "1.14"

  vpc_id          = "${local.vpc_id}"
  subnets         = "${data.aws_subnet_ids.eks_subnet.ids}"

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  worker_additional_security_group_ids = []

  worker_ami_name_filter    = "v20190927"

  worker_group_count        = "1"
  worker_groups = [
    {
      name                  = "${local.instance_worker_group_name}"
      instance_type         = "${local.worker_instance_type}"
      asg_desired_capacity  = "2"
      asg_min_size          = "2"
      asg_max_size          = "3"
      key_name              = "${local.ssh_key_pair}"
      autoscaling_enabled   = true
      protect_from_scale_in = true
    }
  ]

}
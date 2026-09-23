terraform { 
 
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
   required_version = "~> v1.16.2" #he ~> patch version to be greater than but requires the major and minor versions (1.16)
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-2"
}

# references an existing network interface and creates/configures an EC2 instance.
module "vpc" {
  source             = "./modules/vpc"
  name               = "demo-vpc"
  cidr_block         = "172.31.0.0/16"
  availability_zones = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
}

module "ec2_instance" {
  source               = "./modules/ec2_instance"
  ami                  = var.instance_ami
  instance_type        = "t3.micro"
  network_interface_id = var.network_interface_id
  name                 = "DemoInstance"
}



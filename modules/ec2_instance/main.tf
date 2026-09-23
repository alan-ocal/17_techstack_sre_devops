terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> v1.16.2" #he ~> patch version to be greater than but requires the major and minor versions (1.16)
}

resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  network_interface {
    device_index         = 0
    network_interface_id = var.network_interface_id
  }

  tags = merge(var.tags, {
    Name = var.name
  })
}

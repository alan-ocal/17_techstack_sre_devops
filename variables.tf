variable "instance_ami" {
  description = "AMI ID used to launch the EC2 instance in the configured AWS region."
  type        = string
}

variable "network_interface_id" {
  description = "Existing network interface attached to the EC2 instance."
  type        = string
}

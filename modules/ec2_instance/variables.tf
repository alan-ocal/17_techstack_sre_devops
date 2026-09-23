variable "ami" {
  description = "AMI ID used to launch the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
}

variable "network_interface_id" {
  description = "Existing network interface attached to the instance."
  type        = string
}

variable "name" {
  description = "Name assigned to the instance."
  type        = string
}

variable "tags" {
  description = "Additional tags applied to the instance."
  type        = map(string)
  default     = {}
}

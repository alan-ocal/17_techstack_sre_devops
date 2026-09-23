variable "name" {
  description = "Name assigned to the VPC."
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the VPC."
  type        = string
}

variable "tags" {
  description = "Additional tags applied to the VPC."
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "Availability Zones for VPC subnets."
  type        = list(string)
}
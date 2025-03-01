# Define the AWS region
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  default     = "us-east-2"
}

# 🔹 Hub VPC CIDR block
variable "hub_vpc_cidr" {
  description = "CIDR block for the Hub VPC"
  default     = "10.0.0.0/16"
}

# 🔹 Hub Subnet CIDR block
variable "hub_subnet_cidr" {
  description = "CIDR block for the subnet inside the Hub VPC"
  default     = "10.0.1.0/24"
}

# 🔹 Availability Zone (Used for all subnets)
variable "availability_zone" {
  description = "Availability zone for subnets"
  default     = "us-east-2a"
}

# 🔹 Spoke 1 VPC CIDR block
variable "spoke1_vpc_cidr" {
  description = "CIDR block for Spoke 1 VPC"
  default     = "10.1.0.0/16"
}

# 🔹 Spoke 1 Subnet CIDR block (Inside Spoke 1 VPC)
variable "spoke1_subnet_cidr" {
  description = "CIDR block for the subnet inside Spoke 1 VPC"
  default     = "10.1.1.0/24"
}

# 🔹 Spoke 2 VPC CIDR block
variable "spoke2_vpc_cidr" {
  description = "CIDR block for Spoke 2 VPC"
  default     = "10.2.0.0/16"
}

# 🔹 Spoke 2 Subnet CIDR block (Inside Spoke 2 VPC)
variable "spoke2_subnet_cidr" {
  description = "CIDR block for the subnet inside Spoke 2 VPC"
  default     = "10.2.1.0/24"
}

variable "keypair" {
    description = "key pair for ssh into vm"
    default = "devops"
}
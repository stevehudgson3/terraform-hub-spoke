# Define the AWS region
variable "aws_region" {
  description = "AWS region where resources will be deployed"
  default     = "us-east-1"
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

# 🔹 Availability Zone for the Hub subnet
variable "availability_zone" {
  description = "Availability zone for the hub subnet"
  default     = "us-east-1a"
}

# 🔹 Spoke 1 VPC CIDR block
variable "spoke1_vpc_cidr" {
  description = "CIDR block for Spoke 1 VPC"
  default     = "10.1.0.0/16"
}

# 🔹 Spoke 2 VPC CIDR block
variable "spoke2_vpc_cidr" {
  description = "CIDR block for Spoke 2 VPC"
  default     = "10.2.0.0/16"
}

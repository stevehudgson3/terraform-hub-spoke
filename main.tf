# Define the AWS provider and specify the region
provider "aws" {
  region = var.aws_region  # Using a variable for region
}

# 🔹 HUB VPC (Centralized VPC for networking & security services)
resource "aws_vpc" "hub_vpc" {
  cidr_block = var.hub_vpc_cidr  # CIDR block for the hub VPC
}

# 🔹 Subnet inside the HUB VPC
resource "aws_subnet" "hub_subnet" {
  vpc_id            = aws_vpc.hub_vpc.id  # Link this subnet to the Hub VPC
  cidr_block        = var.hub_subnet_cidr  # CIDR block for this subnet
  availability_zone = var.availability_zone  # Define which AZ the subnet is in
}

# 🔹 Create a Transit Gateway (TGW) to route traffic between the Hub and Spoke VPCs
resource "aws_ec2_transit_gateway" "tgw" {}

# 🔹 SPOKE 1 VPC (One of the spoke VPCs that connects to the hub)
resource "aws_vpc" "spoke1_vpc" {
  cidr_block = var.spoke1_vpc_cidr  # CIDR block for the Spoke 1 VPC
}

# 🔹 SPOKE 2 VPC (Another spoke VPC)
resource "aws_vpc" "spoke2_vpc" {
  cidr_block = var.spoke2_vpc_cidr  # CIDR block for the Spoke 2 VPC
}

# 🔹 Attach Spoke 1 VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke1_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id  # Link to the transit gateway
  vpc_id             = aws_vpc.spoke1_vpc.id  # Attach Spoke 1 VPC
  subnet_ids         = [aws_subnet.hub_subnet.id]  # Use the Hub subnet
}

# 🔹 Attach Spoke 2 VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke2_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id  # Link to the transit gateway
  vpc_id             = aws_vpc.spoke2_vpc.id  # Attach Spoke 2 VPC
  subnet_ids         = [aws_subnet.hub_subnet.id]  # Use the Hub subnet
}

# Launch an EC2 instance in Spoke 1
resource "aws_instance" "spoke1_instance" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu 20.04 LTS (Update AMI as needed)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.hub_subnet.id
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Spoke1-EC2"
  }
}

# Launch an EC2 instance in Spoke 2
resource "aws_instance" "spoke2_instance" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.hub_subnet.id
  security_groups = [aws_security_group.allow_ssh.id]

  tags = {
    Name = "Spoke2-EC2"
  }
}

# Security Group to Allow SSH Access (Port 22)
resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.spoke1_vpc.id  # Attach to Spoke 1 VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: Change this for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

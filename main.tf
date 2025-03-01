# Define the AWS provider and specify the region
provider "aws" {
  region = var.aws_region  # Using a variable for region
}

# 🔹 HUB VPC (Centralized VPC for networking & security services)
resource "aws_vpc" "hub_vpc" {
  cidr_block = var.hub_vpc_cidr  # CIDR block for the hub VPC
  tags = {
    Name = "Hub-VPC"  # Name your VPC here
  }
}

# 🔹 Subnet inside the HUB VPC
resource "aws_subnet" "hub_subnet" {
  vpc_id            = aws_vpc.hub_vpc.id  # Link this subnet to the Hub VPC
  cidr_block        = var.hub_subnet_cidr  # CIDR block for this subnet
  availability_zone = var.availability_zone  # Define which AZ the subnet is in
  tags = {
    Name = "Hub-Subnet"  # Name for Hub Subnet
  }
}

# 🔹 Create a Transit Gateway (TGW) to route traffic between the Hub and Spoke VPCs
resource "aws_ec2_transit_gateway" "tgw" {
  tags = {
    Name = "Hub-Transit-Gateway"  # Name for the Transit Gateway
  }
}

# 🔹 Attach Spoke 1 VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke1_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.spoke1_vpc.id
  subnet_ids         = [aws_subnet.spoke1_subnet.id]
  tags = {
    Name = "Spoke1-VPC-Attachment"  # Name for Spoke1 VPC attachment
  }
}

# 🔹 Attach Spoke 2 VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke2_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.spoke2_vpc.id
  subnet_ids         = [aws_subnet.spoke2_subnet.id]
  tags = {
    Name = "Spoke2-VPC-Attachment"  # Name for Spoke2 VPC attachment
  }
}

# 🔹 Attach Hub VPC to the Transit Gateway (Added missing attachment)
resource "aws_ec2_transit_gateway_vpc_attachment" "hub_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.hub_vpc.id
  subnet_ids         = [aws_subnet.hub_subnet.id]
  tags = {
    Name = "Hub-VPC-Attachment"  # Name for Hub VPC attachment
  }
}

# 🔹 SPOKE 1 VPC
resource "aws_vpc" "spoke1_vpc" {
  cidr_block = var.spoke1_vpc_cidr  # CIDR block for the Spoke 1 VPC
  tags = {
    Name = "Spoke1-VPC"  # Custom name for Spoke1
  }
}

# 🔹 SPOKE 1 Subnet
resource "aws_subnet" "spoke1_subnet" {
  vpc_id            = aws_vpc.spoke1_vpc.id
  cidr_block        = var.spoke1_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "Spoke1-Subnet"  # Name for Spoke1 Subnet
  }
}

# 🔹 SPOKE 2 VPC
resource "aws_vpc" "spoke2_vpc" {
  cidr_block = var.spoke2_vpc_cidr  # CIDR block for the Spoke 2 VPC
  tags = {
    Name = "Spoke2-VPC"  # Custom name for Spoke2
  }
}

# 🔹 SPOKE 2 Subnet
resource "aws_subnet" "spoke2_subnet" {
  vpc_id            = aws_vpc.spoke2_vpc.id
  cidr_block        = var.spoke2_subnet_cidr
  availability_zone = var.availability_zone
  tags = {
    Name = "Spoke2-Subnet"  # Name for Spoke2 Subnet
  }
}

# 🔹 Attach Spoke 1 VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke1_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.spoke1_vpc.id
  subnet_ids         = [aws_subnet.spoke1_subnet.id]  
  tags = {
    Name = "Spoke1-VPC-Attachment"  # Name for Spoke1 VPC attachment
  }
}

# 🔹 Attach Spoke 2 VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "spoke2_attach" {
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id
  vpc_id             = aws_vpc.spoke2_vpc.id
  subnet_ids         = [aws_subnet.spoke2_subnet.id]  
  tags = {
    Name = "Spoke2-VPC-Attachment"  # Name for Spoke2 VPC attachment
  }
}

# EC2 Instance in Spoke 1 VPC
resource "aws_instance" "spoke1_instance" {
  ami           = "ami-0884d2865dbe9de4b"  # Ubuntu 20.04 LTS (Update AMI as needed)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.spoke1_subnet.id  
  security_groups = [aws_security_group.spoke1_sg.id]  
  key_name      = var.keypair
  
  tags = {
    Name = "Spoke1-EC2"
  }
}

# EC2 Instance in Spoke 2 VPC
resource "aws_instance" "spoke2_instance" {
  ami           = "ami-0884d2865dbe9de4b"  # Ubuntu 20.04 LTS (Update AMI as needed)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.spoke2_subnet.id  
  security_groups = [aws_security_group.spoke2_sg.id]  
  key_name      = var.keypair

  tags = {
    Name = "Spoke2-EC2"
  }
}

# Security Group for Spoke 1 VPC
resource "aws_security_group" "spoke1_sg" {
  vpc_id = aws_vpc.spoke1_vpc.id  

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: Restrict this for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Spoke1-SG"  # Name for Spoke1 Security Group
  }
}

# Security Group for Spoke 2 VPC
resource "aws_security_group" "spoke2_sg" {
  vpc_id = aws_vpc.spoke2_vpc.id 

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # WARNING: Restrict this for better security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Spoke2-SG"  # Name for Spoke2 Security Group
  }
}

# Security Group for Bastion Host
resource "aws_security_group" "hub_bastion_sg" {
  vpc_id = aws_vpc.hub_vpc.id  # Attach to Hub VPC

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Replace with your actual IP for security 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Hub-Bastion-SG"  # Name for Bastion Security Group
  }
}

# Bastion Host in Hub VPC (With Public IP)
resource "aws_instance" "hub_bastion" {
  ami           = "ami-0884d2865dbe9de4b"  # Ubuntu 20.04 LTS (Replace as needed)
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.hub_subnet.id  # Place in Hub Subnet
  security_groups = [aws_security_group.hub_bastion_sg.id]
  key_name      = var.keypair  # Replace with your actual key name
  associate_public_ip_address = true  # Public IP for SSH Access

  tags = {
    Name = "Hub-Bastion-Host"
  }
}

# Create an Internet Gateway for the Hub VPC
resource "aws_internet_gateway" "hub_igw" {
  vpc_id = aws_vpc.hub_vpc.id

  tags = {
    Name = "Hub-VPC-IGW"  # Name for the Internet Gateway
  }
}

# Get the Route Table for Hub VPC
resource "aws_route_table" "hub_route_table" {
  vpc_id = aws_vpc.hub_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hub_igw.id  # ✅ Route all internet traffic through IGW
  }

  tags = {
    Name = "Hub-VPC-RouteTable"  # Name for Hub VPC Route Table
  }
}

# Associate the Route Table with the Hub Subnet
resource "aws_route_table_association" "hub_route_assoc" {
  subnet_id      = aws_subnet.hub_subnet.id
  route_table_id = aws_route_table.hub_route_table.id
}

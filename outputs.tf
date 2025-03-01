# Output the Hub VPC ID
output "hub_vpc_id" {
  value       = aws_vpc.hub_vpc.id
  description = "Hub VPC ID"
}

# Output Spoke 1 VPC ID
output "spoke1_vpc_id" {
  value       = aws_vpc.spoke1_vpc.id
  description = "Spoke 1 VPC ID"
}

# Output Spoke 2 VPC ID
output "spoke2_vpc_id" {
  value       = aws_vpc.spoke2_vpc.id
  description = "Spoke 2 VPC ID"
}

# Output Transit Gateway ID
output "transit_gateway_id" {
  value       = aws_ec2_transit_gateway.tgw.id
  description = "AWS Transit Gateway ID"
}

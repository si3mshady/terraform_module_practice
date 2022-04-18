output "elliott_vpc_id" {
  value = aws_vpc.elliotts_aws_sandbox.id
}

output "elliott_vpc_metadata" {
  value = aws_vpc.elliotts_aws_sandbox
}

output "elliott_public_sg" {
  value = aws_security_group.public_sg
}


output "vpc_public_subnets" {
  value = aws_subnet.public_subnet
}

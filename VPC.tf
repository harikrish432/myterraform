resource "aws_vpc" "prod_vpc" {
  cidr_block           = var.myvpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Prod_vpc"
  }
}

output "vpc_id" {
  value = aws_vpc.prod_vpc.id
}


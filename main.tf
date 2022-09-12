# Vpc 
resource "aws_vpc" "Prod-rock-VPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "Prod-rock-VPC"
  }
}

# Public subnets
resource "aws_subnet" "Test-public-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Test-public-sub1"
  }
}

resource "aws_subnet" "Test-public-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Test-public-sub2"
  }
}

# Private subnets
resource "aws_subnet" "Test-priv-sub1" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Test-priv-sub1"
  }
}

resource "aws_subnet" "Test-priv-sub2" {
  vpc_id     = aws_vpc.Prod-rock-VPC.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Test-priv-sub2"
  }
}

# Public route table
resource "aws_route_table" "Test-pub-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-pub-route-table"
  }
}

# Private route table
resource "aws_route_table" "Test-priv-route-table" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-priv-route-table"
  }
}

# Associate subnets public
resource "aws_route_table_association" "Public-route-table-association-1" {
  subnet_id      = aws_subnet.Test-public-sub1.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

resource "aws_route_table_association" "Public-route-table-association-2" {
  subnet_id      = aws_subnet.Test-public-sub2.id
  route_table_id = aws_route_table.Test-pub-route-table.id
}

# Association private
resource "aws_route_table_association" "Private-route-table-association-1" {
  subnet_id      = aws_subnet.Test-priv-sub1.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

resource "aws_route_table_association" "Private-route-table-association-2" {
  subnet_id      = aws_subnet.Test-priv-sub2.id
  route_table_id = aws_route_table.Test-priv-route-table.id
}

# IGW
resource "aws_internet_gateway" "Test-igw" {
  vpc_id = aws_vpc.Prod-rock-VPC.id

  tags = {
    Name = "Test-igw"
  }
}

# AWS route
resource "aws_route" "Test-igw-association" {
  route_table_id            = aws_route_table.Test-pub-route-table.id
  gateway_id                = aws_internet_gateway.Test-igw.id
  destination_cidr_block    = "0.0.0.0/0"
}

# EIP
resource "aws_eip" "EIP-for-NG" {
  vpc = true
  associate_with_private_ip = "3.10.220.206"
}

# Nat gateway
  resource "aws_nat_gateway" "Test-nat-gateway" {
  allocation_id = aws_eip.EIP-for-NG.id
  subnet_id     = aws_subnet.Test-public-sub1.id
  }
  

  # Association Private route
resource "aws_route" "Test-nat-gw-association" {
  route_table_id            = aws_route_table.Test-priv-route-table.id
  nat_gateway_id            = aws_nat_gateway.Test-nat-gateway.id
  destination_cidr_block    = "0.0.0.0/0"
}





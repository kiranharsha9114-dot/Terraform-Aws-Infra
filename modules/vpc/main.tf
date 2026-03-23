# -----------------------------
# Availability Zones
# -----------------------------
data "aws_availability_zones" "available" {}

# -----------------------------
# VPC
# -----------------------------
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "main-vpc"
    Environment = "Dev"
  }
}

# -----------------------------
# Internet Gateway
# -----------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# -----------------------------
# Public Subnets (2 AZs)
# -----------------------------
resource "aws_subnet" "public" {
  count = 2

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
    Tier = "Public"
  }
}

# -----------------------------
# Private Subnets (2 AZs)
# -----------------------------
resource "aws_subnet" "private" {
  count = 2

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "private-subnet-${count.index}"
    Tier = "Private"
  }
}

# -----------------------------
# Elastic IPs for NAT (Multi-AZ)
# -----------------------------
resource "aws_eip" "nat" {
  count = 2

  tags = {
    Name = "nat-eip-${count.index}"
  }
}

# -----------------------------
# NAT Gateways (One per AZ)
# -----------------------------
resource "aws_nat_gateway" "nat" {
  count = 2

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "nat-gateway-${count.index}"
  }

  depends_on = [aws_internet_gateway.igw]
}

# -----------------------------
# Public Route Table
# -----------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_assoc" {
  count = 2

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------------
# Private Route Tables (per AZ)
# -----------------------------
resource "aws_route_table" "private_rt" {
  count = 2

  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt-${count.index}"
  }
}

resource "aws_route" "private_route" {
  count = 2

  route_table_id         = aws_route_table.private_rt[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_assoc" {
  count = 2

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt[count.index].id
}

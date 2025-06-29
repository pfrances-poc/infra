provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.azs_count)

  subnet_bits = ceil(log(length(local.azs), 2))

  public_subnets = [
    for i, az in local.azs :
    cidrsubnet(var.cidr_block, local.subnet_bits, i)
  ]
}

locals {
  tags = merge(
    {
      Name        = var.name
      Description = var.description
    },
    var.tags
  )
}

resource "aws_vpc" "default" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = local.tags
  region               = var.region
}

resource "aws_internet_gateway" "default" {
  count  = var.internet_gateway ? 1 : 0
  vpc_id = aws_vpc.default.id
  tags   = local.tags
}

resource "aws_subnet" "public" {
  for_each          = toset(local.azs)
  vpc_id            = aws_vpc.default.id
  cidr_block        = cidrsubnet(var.cidr_block, local.subnet_bits, index(local.azs, each.key))
  availability_zone = each.key

  lifecycle {
    precondition {
      condition     = length(data.aws_availability_zones.available.names) >= var.azs_count
      error_message = "Not enough availability zones available in region ${var.region}. Required: ${var.azs_count}, Available: ${length(data.aws_availability_zones.available.names)}."
    }

    precondition {
      condition     = can(cidrsubnet(var.cidr_block, local.subnet_bits, index(local.azs, each.key)))
      error_message = "Invalid CIDR block for subnet in availability zone ${each.key}."
    }
  }
}

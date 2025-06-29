environment      = "dev"
name             = "invalid-azs-count-vpc"
description      = "Default network for the project with invalid AZs count"
cidr_block       = "10.0.0.0/16"
region           = "ap-northeast-1"
azs_count        = 4
internet_gateway = true
tags = {
  "Environment" = "dev"
  "Project"     = "my-project"
}

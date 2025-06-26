environment      = "dev"
name             = "my-vpc"
description      = "Default network for the project"
cidr_block       = "10.0.0.0/16"
region           = "ap-northeast-1"
azs_count        = 2
internet_gateway = true
tags = {
  "Environment" = "dev"
  "Project"     = "my-project"
}

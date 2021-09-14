terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.37"
    }

  }
}

provider "aws" {
  region = "ca-central-1"
}

module "vpc" { 
  source = "github.com/cds-snc/terraform-modules//vpc"
  name = "vpc"
  billing_tag_value = "cal"
  high_availability = true
  enable_eip = false
}

module "rds" {
  source = "github.com/cds-snc/terraform-modules//rds"
  name = "test-rds"
  backup_retention_period = 7
  billing_tag_value = "cal"
  database_name = "foo"
  engine_version = "13.3"
  password = "foo"
  username = "calvin"
  preferred_backup_window = "07:00-09:00"
  subnet_ids = module.vpc.public_subnet_ids
  vpc_id = module.vpc.vpc_id
}

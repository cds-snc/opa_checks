module "vpc" {
  source             = "github.com/cds-snc/terraform-modules//vpc"
  name               = "vpc"
  billing_tag_value  = "cal"
  availability_zones = 3
  cidrsubnet_newbits = 8
  enable_eip         = false
}

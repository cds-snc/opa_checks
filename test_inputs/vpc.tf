module "vpc" { 
  source = "github.com/cds-snc/terraform-modules//vpc"
  name = "vpc"
  billing_tag_value = "cal"
  high_availability = true
  enable_eip = false
}
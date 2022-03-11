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
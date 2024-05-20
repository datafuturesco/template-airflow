# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  platform                   = "dwp"  # Default platform name for this repo. Will prefix everything.
  aws_region                 = "us-east-1"  # Default AWS region, can override with the region.hcl file.
  aws_account_id             = "966612968161"
  #aws_account_id             = "966612968161"  # The default account ID.
  bucket_name_prefix         = "dy-dwp-core"  # The bucket name prefix.
  aws_profile_prefix         = "davidyurman"  # The profile prefix with the environment suffixed later.
  terraform_locks_table_name = "terraform_locks_dwp_core"  # The dynamodb terraform locks table name.
}

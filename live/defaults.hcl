# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  platform                   = "UPDATE ME"  # Default platform name for this repo. Will prefix everything.
  aws_region                 = "us-east-1"  # Default AWS region, can override with the region.hcl file.
  aws_account_id             = "<YOUR_AWS_ACCOUNT_ID>"
  #aws_account_id             = "<YOUR_AWS_ACCOUNT_ID>"  # The default account ID.
  bucket_name_prefix         = "UPDATE ME"  # The bucket name prefix eg. dy-dwp-core
  aws_profile_prefix         = "UPDATE ME"  # The profile prefix with the environment suffixed later.
  terraform_locks_table_name = "UPDATE ME"  # The dynamodb terraform locks table name. eg. terraform_locks_dwp_core
}

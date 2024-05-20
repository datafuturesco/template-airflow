# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
# TODO - Set these values if you want to override the defaults.hcl values.
locals {
  aws_account_id = "966612968161"
#  aws_profile    = ""  # This is for local testing only. The default value is: [aws-profile-prefix]-[environment]
}


# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# This is the configuration for Terragrunt, a thin wrapper for Terraform that helps keep your code DRY and
# maintainable: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

# ---------------------------------------------------------------------------------------------------------------------
# Include configurations that are common used across multiple environments.
# ---------------------------------------------------------------------------------------------------------------------

# Include the root `terragrunt.hcl` configuration. The root configuration contains settings that are common across all
# components and environments, such as how to configure remote state.
include "root" {
  path = find_in_parent_folders()
}
##
#### Include the common_tags configuration for the component. It's a general tagging declaration.
###include "common_tags" {
###  path = "${dirname(find_in_parent_folders())}/_envcommon/common_tags.hcl"
###}
##
locals {
}

terraform {
  # This example pulls the newest for the specified branch. In this way you could have divergent code per branch.
  source = "<YOUR_TERRAGRUNT_SSH_GIT_LINK>"  #for eg. git@github.com:<your_organization>/data-terragrunt-mwaa.git//airflow-mwaa?ref=main
}

inputs = merge(
  {
    enabled            = true
    name               = "core" 
    vpc_cidr           = "XX.XX.XX.XX/XX"
    source_cidr        = ["XX.XX.XX.XX/XX"]
    vpc_id             = "vpc-XXXXX"
    security_group_ids = [
      "sg-XXXXX",
      "sg-XXXXX",
      "sg-XXXXX"
    ]
    private_subnet_ids = [
      "subnet-XXXXX",
      "subnet-XXXXX",
    ]
  }
)



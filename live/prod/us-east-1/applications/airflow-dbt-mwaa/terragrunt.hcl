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
  source = "git@github.com:david-yurman/data-terragrunt-mwaa.git//airflow-mwaa?ref=main"
}

inputs = merge(
  {
    enabled            = true
    name               = "core" 
    vpc_cidr           = "10.1.0.0/16"
    source_cidr        = ["10.93.0.0/16"]
    vpc_id             = "vpc-075ecfb13545152a6"
    security_group_ids = [
      "sg-00fdb657390afa457",
      "sg-0e03ceb8d89b25189",
      "sg-039c0a8f494e82d33"
    ]
    private_subnet_ids = [
      "subnet-04757060ff0f3055a",
      "subnet-096d47066a79cfcb4",
    ]
  }
)



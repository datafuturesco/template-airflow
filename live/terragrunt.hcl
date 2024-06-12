# ---------------------------------------------------------------------------------------------------------------------
# TERRAGRUNT CONFIGURATION
# Terragrunt is a thin wrapper for Terraform that provides extra tools for working with multiple Terraform modules,
# remote state, and locking: https://github.com/gruntwork-io/terragrunt
# ---------------------------------------------------------------------------------------------------------------------

locals {
  # Automatically load default repo-level variables
  default_vars = try(read_terragrunt_config(find_in_parent_folders("defaults.hcl")), read_terragrunt_config("defaults.hcl"))

  # Automatically load account-level variables
  account_vars = try(read_terragrunt_config(find_in_parent_folders("account.hcl")), null)

  # Automatically load region-level variables
  region_vars = try(read_terragrunt_config(find_in_parent_folders("region.hcl")), null)

  # Automatically load environment-level variables
  environment_vars = try(read_terragrunt_config(find_in_parent_folders("env.hcl")), null)

  # Extract the variables we need for easy access
  aws_account_id             = try(local.account_vars.locals.aws_account_id, local.default_vars.locals.aws_account_id)
  aws_profile                = try(local.account_vars.locals.aws_profile, "${local.default_vars.locals.aws_profile_prefix}-${local.environment}")
  aws_region                 = try(local.region_vars.locals.aws_region, local.default_vars.locals.aws_region)
  platform                   = local.default_vars.locals.platform
  bucket_name_prefix         = local.default_vars.locals.bucket_name_prefix
  terraform_locks_table_name = local.default_vars.locals.terraform_locks_table_name
  environment                = try(local.environment_vars.locals.environment, "")
  account_name               = "${local.platform}-${local.environment}"
  # Define variables for requirements.txt paths at each level - uncomment variables according to your requirements file placement
  #mwaa_dir_env_path   = "${find_in_parent_folders("dev")}"
  #mwaa_dir_region_path = "${find_in_parent_folders("us-east-1")}"
  #mwaa_dir_app_path    = "${find_in_parent_folders("applications/airflow-dbt-mwaa")}"
}

# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region  = "${local.aws_region}"
  profile = "${local.aws_profile}"
}
EOF
}

# Configure Terragrunt to automatically store tfstate files in an S3 bucket
remote_state {
  backend = "s3"

  config  = {
    profile             = "${local.aws_profile}"
    encrypt             = true
    bucket              = "${get_env("TG_BUCKET_PREFIX", local.bucket_name_prefix)}-${local.platform}-terraform-${local.aws_account_id}"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
    region              = "us-east-1"
    dynamodb_table      = "${get_env("TG_DYNAMODB_TABLE", "${local.platform}_${local.terraform_locks_table_name}")}",
    dynamodb_table_tags = {
      Platform : local.platform
    }
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

terraform {
  extra_arguments "aws_profile" {
    commands = [
      "init",
      "apply",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint"
    ]

    env_vars = {
      AWS_PROFILE = "${local.aws_profile}"
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local,
  local.default_vars.locals,
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "${basename(get_terragrunt_dir())}"
  max_workers = 5
  environment_class = "mw1.small"
  #mwaa_dir_env_path = "${get_terragrunt_dir()}"  #uncomment if providing environment level requirements
}

# Set common variables for the region. This is automatically pulled in in the root terragrunt.hcl configuration to
# configure the remote state bucket and pass forward to the child modules as inputs.
locals {
  aws_region = "${basename(get_terragrunt_dir())}"
  #mwaa_dir_region_path = "${get_terragrunt_dir()}"  #uncomment if providing region level requirements file
}

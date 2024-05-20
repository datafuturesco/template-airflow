locals {
  common_tags = {
    Created_By: "Terraform"
    Environment: local.env,
    Platform: local.platform
  }
}

inputs = {

}
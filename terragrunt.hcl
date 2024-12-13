locals {
  root_dir       = dirname(find_in_parent_folders())
  modules_uri    = "git::https://github.com/mostmm/terraform-base-modules.git"
  component_path = path_relative_to_include()

  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
}

remote_state {
  backend = "local"
  config = {
    path = "${local.root_dir}/../tfremotestate.local/${local.component_path}/terraform.tfstate"
  }

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
}

inputs = {
  account_vars = local.account_vars.locals
  region_vars  = local.region_vars.locals
}

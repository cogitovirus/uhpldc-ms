# Centralized configuration for all environments
terraform {
  extra_arguments "common_vars" {
    commands = ["${get_terraform_commands_that_need_vars()}"]

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars"
    ]
  }
}

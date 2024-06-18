terraform {
  extra_arguments "common_vars" {
    commands = [
      "apply",
      "plan",
      "destroy"
    ]

    arguments = [
      "-var-file=${get_parent_terragrunt_dir()}/common.tfvars"
    ]
  }
}

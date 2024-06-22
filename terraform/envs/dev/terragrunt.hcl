terraform {
  source = "../../..//envs/dev"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  synapse_sql_password = "seCuRe123$%^"
}

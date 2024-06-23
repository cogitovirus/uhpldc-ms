remote_state {
  backend = "local"
  config = {
    path = "${path_relative_to_include()}/terraform.tfstate"
  }
}

inputs = {
  environment = get_env("TF_VAR_ENV", "dev")
}
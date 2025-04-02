module "root_module" {
  source = "./modules/stack_blob"

  resource_group_name = "web-public-static"
  location = data.terraform_remote_state.bootstrap_state.outputs.region
  tags = data.terraform_remote_state.bootstrap_state.outputs.default_tags
}

output "primary_web_host" {
  value = module.root_module.primary_web_host
}
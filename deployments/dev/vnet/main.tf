locals {
  vnet-name = "${local.environment}-example-vnet"
  environment = data.terraform_remote_state.bootstrap_state.outputs.environment
  region = data.terraform_remote_state.bootstrap_state.outputs.region
  tags = data.terraform_remote_state.bootstrap_state.outputs.default_tags
  resource_group_name = data.terraform_remote_state.bootstrap_state.outputs.resource_group_name
}

module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = ">= v0.8.1"

  name                = local.vnet-name
  resource_group_name = local.resource_group_name
  location            = local.region
  address_space       = ["10.0.0.0/16"]

  subnets = {
    public = {
        name = "${local.environment}-subnet-public"
        address_prefixes = ["10.0.0.0/24"]
        delegations      = []
        tags = {
            type        = "public"
            role        = "nat/lb"
        }
    }

    private_db = {
        name = "${local.environment}-subnet-private-db"
        address_prefixes = ["10.0.1.0/24"]
        delegations      = []
        tags = merge(local.tags, {
            type        = "private"
            role        = "database"
        })
    }

    private_vm = {
        name = "${local.environment}-subnet-private-vm"
        address_prefixes = ["10.0.2.0/24"]
        delegations      = []
        tags = merge(local.tags, {
            type        = "private"
            role        = "virtual_machine"
        })
    }
  }

  tags = local.tags
}

output "vnet_id" {
  description = "ID vnet"
  value       = module.vnet.resource_id
}

output "vnet_name" {
  description = "VNet name"
  value       = module.vnet.name
}

# output "vnet_address_space" {
#   description = "cidr VNet"
#   value       = module.vnet.address_space
# }

# output "subnet_ids" {
#   description = "subnets ID"
#   value       = module.vnet.subnet_ids
# }

# output "subnet_names" {
#   description = "subnet names"
#   value       = module.vnet.subnets
# }

# output "subnet_private_db_id" {
#   description = "subnet db id"
#   value       = module.vnet.subnets["private_db"]
# }

# output "subnet_private_vm_id" {
#   description = "subnet vm id"
#   value       = module.vnet.subnets["private_vm"]
# }

# output "subnet_public_id" {
#   description = "subnet public id"
#   value       = module.vnet.subnets["public"]
# }
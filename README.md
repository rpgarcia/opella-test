# Terraform
Provider version >= 4.25.0

## Terraform folder structure
**bootstrap**: Contains one folder per environment and is responsible for creating the foundational infrastructure used to store Terraform remote states securely in private blob containers, as well as defining global variables that can be reused by all resources across environments.

**deployments**: Contains per-environment directories where all resources will be deployed.

**modules**: Contains reusable Terraform modules that can be shared across environments and resources.

# Azure login
```
$ az login (copy the subscription Id to define the env variable later)
$ export ARM_SUBSCRIPTION_ID="output az login"
```

# How to Use This Terraform Setup
If a remote backend to store Terraform states does not exist yet, follow these steps:
1. Initialize and Apply the Bootstrap
Clone and execute the bootstrap configuration to provision the backend infrastructure for secure remote state storage in Azure Blob Storage.
Validate:
- The ip from where will be executed should be added (Azure only support ipv4 for the resource azurerm_storage_account_network_rules)
```
$ cd bootstrap
$ terraform init
$ terraform apply
```

Note: Save the output storage account name, we will need to configure the backend.

This will create a local state file. After this step, you must configure the remote backend to store Terraform states securely.

## Configure the Remote Backend
1.  Edit bootstrap.tf and define the backend block:
```
terraform {
  # backend "azurerm" {} # Uncomment to use the remote backend

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.25.0"
    }
  }
}
```

2. Add your backend configuration to backend.tfbackend:
```
resource_group_name  = "example-resources"
storage_account_name = "output-name-of-storgate-account"
container_name       = "tfstate"
key                  = "dev/bootstrap/terraform.tfstate"
```

3. Set the ARM_ACCESS_KEY (for local execution)
If you're running Terraform locally, export the Storage Account access key to authenticate:
```
    az storage account keys list \
	  --account-name output-name-of-storgate-account \
	  --resource-group example-resources \
	  --query '[0].value' -o tsv
```
Then:
```
export ARM_ACCESS_KEY=<your-access-key>
terraform init -backend-config=./backend.tfbackend
```

This will migrate your local state to the remote backend. After this is complete, you can continue using:
`terraform plan / apply`

**NOTE:** Assign Required Permissions
If the user running Terraform does not have permission to write to the remote backend, you should validate the network rules with your ip added and the permissions user.  
To assign permissions just run the script: bootstrap_backend_config.sh script. This script grants the necessary RBAC role assignments to allow Terraform to write the remote state.
To check the ip, you can see in the storage accounts -> networking rules 

## How to Deploy Infrastructure Once Bootstrap Is Complete
All infrastructure should be placed under deployments/, separated by environment (e.g., dev, staging, prod).

**ALWAYS** Don't forget to add in the terraform.tf the storage account name

1. Deploy base infrastructure (e.g., VNET)
Example for the development environment:

```
cd deployments/dev/vnet
terraform init
terraform apply
```
NOTE: This deployment will read the outputs from the bootstrap state, where global variables are defined, using the following terraform_remote_state block:
```
data "terraform_remote_state" "bootstrap_state" {
  backend = "azurerm"
  config = {
    resource_group_name  = "example-resources"
    storage_account_name = "output-name-of-storgate-account"
    container_name       = "tfstate"
    key                  = "dev/bootstrap/terraform.tfstate"
  }
}
```

2. Deploy a Static Website (Example Using stack_blob Module)

To deploy a public or private static website:
a. Navigate to the deployment folder: `cd deployments/dev/web_private/`<br>
b. Define the terraform.tf file with the appropriate provider and any required terraform_remote_state data sources.<br>
c. Run the deployment: terraform init / apply<br>
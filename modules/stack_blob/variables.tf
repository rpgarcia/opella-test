variable "resource_group_name" {
  description = "resource group name"
  type        = string
}

variable "location" {
    description = "cloud location"
    type = string
}

# variable "storage_account_id" {
#   description = "storage account id"
#   type        = string
# }

# variable "storage_account_name" {
#   description = "storage account name"
#   type        = string
# }

# variable "permissions" {
#   description = "variable for permissions access"
#   type    = string
#   default = "private"
#   validation {
#     condition     = contains(["private", "public"], var.permissions)
#     error_message = "the value should be 'private' or 'public'."
#   }
# }

# variable "metadata" {
#   description = "Metadata for the container"
#   type        = map(string)
#   default     = {}
# }

variable "tags" {}
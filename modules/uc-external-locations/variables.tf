variable "az_subscription_id" {
  description = "Azure subscription ID to use"
  type        = string
}

variable "environment" {
  description = "Environment to deploy the resources to"
  type        = string
  validation {
    condition     = var.environment == "dev" || var.environment == "tst" || var.environment == "uat" || var.environment == "prd"
    error_message = "Invalid environment. Allowed values are dev, tst, uat, prd"
  }
}

variable "databricks_workspace_name" {
  description = "Name of the databricks workspace"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "access_connector_name" {
  description = "The name of the access connector to use for this Storage Credential"
  type        = string
}

variable "storage_credential_owner" {
  description = "The owner of the storage credential"
  type        = string
}

variable "storage_credential_comment" {
  description = "The comment for the storage credential"
  type        = string
}

variable "storage_cred_grants" {
  type = map(list(string))
  description = "Grants for storage credentials"
}

variable "external_locations" {
  description = "External locations to be created"
  type = map(object({
    name                      = string
    storage_account_name      = string
    storage_account_container = string
    storage_path              = string
    owner                     = string
    comment                   = string
    read_only                 = bool
    skip_validation           = bool
    grants                    = map(list(string))
  }))
}
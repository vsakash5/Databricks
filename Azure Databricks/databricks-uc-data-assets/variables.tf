variable "az_subscription_id" {
  description = "Azure subscription ID to use used"
}

variable "tenant_id" {
  description = "Tenant ID of the Microsoft Entra ID tenant"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group"
  type        = string
}

variable "environment" {
  description = "Environment to deploy the resources to"
  default     = "dev"
  // Allowed values: dev, pro
  validation {
    condition     = var.environment == "dev" || var.environment == "prd"
    error_message = "Invalid environment. Allowed values are dev, prd"
  }
}

variable "databricks_workspace_host" {
  description = "Url of the databricks workspace"
  type        = string
}

variable "databricks_workspace_name" {
  description = "Name of the databricks workspace"
  type        = string
}

variable "databricks_metastore_id" {
  description = "Id of the databricks metastore"
  type        = string
}

variable "catalog_storage_account_name" {
  description = "Storage account for catalog root storage"
  type        = string
}

variable "bronze_storage_account_name" {
  description = "Storage account for bronze layer"
  type        = string
}

variable "silver_storage_account_name" {
  description = "Storage account for silver layer"
  type        = string
}

variable "gold_storage_account_name" {
  description = "Storage account for gold layer"
  type        = string
}

variable "landing_1_storage_account_name" {
  description = "Storage account for landing 1"
  type        = string
}

variable "landing_2_storage_account_name" {
  description = "Storage account for landing 2"
  type        = string
}

variable "landing_3_storage_account_name" {
  description = "Storage account for landing 3"
  type        = string
}

variable "cdh_storage_account_name" {
  description = "Storage account for cdh storage"
  type        = string
}

variable "workspace_storage_account_name" {
  description = "Storage account for workspace storage"
  type        = string
}

// variable "trino_spn_app_id" {
//   description = "Service principal app id for trino"
//   type        = string
// }

// variable "adf_spn_app_id" {
//   description = "Service principal app id for adf"
//   type        = string
// }

// variable "landing_grants" {
//  type = map(list(string))
// }

 variable "landing_grants_volumes" {
  type = map(list(string))
 }

variable "cdh_catalog_grants" {
  type = map(list(string))
}

variable "ws_catalog_grants" {
  type = map(list(string))
}

variable "sa_catalog_grants" {
  type = map(list(string))
}

variable "schemas" {
  type = map(object({
    name         = string
    owner        = string
    comment      = string
    storage_root = string
    grants       = optional(map(list(string)), {})
    properties   = map(string)
  }))
}

variable "ws_schemas" {
  type = map(object({
    name         = string
    owner        = string
    comment      = string
    storage_root = string
    grants       = optional(map(list(string)), {})
    properties   = map(string)
  }))
}

variable "catalog_owner" {
  description = "Storage account for cdh storage"
  type        = string
}
variable "ws_catalog_owner" {
  description = "value for ws catalog owner"
  type        = string
}
